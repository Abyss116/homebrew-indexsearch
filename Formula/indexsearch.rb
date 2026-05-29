class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.5"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.5/indexsearch-linux-x86_64.tar.gz"
    sha256 "d5ec23c8bfc7d48b26a610791b404da11c5bd1a656c8279a985883a21546d56c"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.5/indexsearch-macos-aarch64.tar.gz"
    sha256 "a831cb8f324a14a5c451e7f0792e8388478ebfba8ccedc1793c6c28097d3ccab"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.5/indexsearch-macos-x86_64.tar.gz"
    sha256 "1a3e298bb77652be461cc337cba5fc9e90c1fb17ddb6a4e64faef5643bc68c43"
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
      bin.install "istool"
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
        istool install-skills
        istool install-skills --scope project --project /path/to/project --ue-template
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istool --version")
    assert_match version.to_s, shell_output("#{bin}/indexsearch --version")
    assert_match version.to_s, shell_output("#{bin}/is --version")
  end
end
