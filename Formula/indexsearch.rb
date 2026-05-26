class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.14"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.14/indexsearch-linux-x86_64.tar.gz"
    sha256 "dd0b70be11aa140d8c7d20424d83cf0d172006e781c774d6f275ec39b5d40319"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.14/indexsearch-macos-aarch64.tar.gz"
    sha256 "f9afabbb1e95ef7b14cba3871062f5942b17e8818ed3cf327c1dec9c5f5f1d10"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.14/indexsearch-macos-x86_64.tar.gz"
    sha256 "9845adafeccd713190d8f303d7df4cfdf5d07a2ee3cc2b90a65d9f35ded0950d"
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
