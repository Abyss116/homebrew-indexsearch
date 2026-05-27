class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.0/indexsearch-linux-x86_64.tar.gz"
    sha256 "ac31cb69bb3bf832ed7bedcc66c4bc09602a942afaaca93978aa783ee06b5c6f"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.0/indexsearch-macos-aarch64.tar.gz"
    sha256 "0ee74efc1a46ba055973fe2a9fa89e6ac1a1fee2a9f0bc566844e90ed0a6271d"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.0/indexsearch-macos-x86_64.tar.gz"
    sha256 "9587ad680f00ff7b6d885fefd55e98545ffa5fc75f367b70b06b10a5bb486a2e"
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
