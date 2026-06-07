class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.12"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.12/indexsearch-linux-x86_64.tar.gz"
    sha256 "bd2f31e5028f4ddd8306618f19d66c4c8eba7edf82d7ec578ffab7a00deb316b"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.12/indexsearch-macos-aarch64.tar.gz"
    sha256 "31802d1d2a03b063a8a9416e5f526c8d212e70ee057e998f912a3babbb9f1b33"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.12/indexsearch-macos-x86_64.tar.gz"
    sha256 "28d0db31f8e516a865d5048e844e664c7059a3117a102aca12aa50b14da572fb"
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
      bin.install_symlink "indexsearch" => "is"
      bin.install_symlink "indexsearch" => "isgrep"
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
