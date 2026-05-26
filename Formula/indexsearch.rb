class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.2"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.2/indexsearch-linux-x86_64.tar.gz"
    sha256 "5914fc2b4ba65847b0bcb8c1fa93bdd9ed0190360fbb126e42741c34e7c58cbc"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.2/indexsearch-macos-aarch64.tar.gz"
    sha256 "5f8b798b47bfb6d38b0fe6c40113a79be0ccea854bfb06031df10c8f5ba91448"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.2/indexsearch-macos-x86_64.tar.gz"
    sha256 "5d0d54dec5ee544e24b98462fbd2998e0d39dfe68f68909400be3ef7736e564c"
  end

  def install
    payload = if File.exist?("indexsearch")
      "."
    else
      Dir["indexsearch-*"].find { |entry| File.directory?(entry) }
    end
    odie "IndexSearch archive layout changed" if payload.nil?
    cd payload do
      bin.install "is-daemon" if File.exist?("is-daemon")
      bin.install "indexsearch"
      if File.exist?("is")
        bin.install "is"
      else
        bin.install_symlink "indexsearch" => "is"
      end
      pkgshare.install "skills" if Dir.exist?("skills")
      pkgshare.install "agent-rules" if Dir.exist?("agent-rules")
      pkgshare.install "templates" if Dir.exist?("templates")
    end
  end

  def caveats
    <<~EOS
      Agent integrations are bundled into the binary:
        is install-skills
        is install-skills --scope project --project /path/to/project --ue-template
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/indexsearch --version")
    assert_match version.to_s, shell_output("#{bin}/is --version")
  end
end
