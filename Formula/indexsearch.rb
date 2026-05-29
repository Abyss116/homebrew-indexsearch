class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.4"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.4/indexsearch-linux-x86_64.tar.gz"
    sha256 "e737d0130b1154a8aaa0ccebecdc92008ad40575cfdea9b26f31ca07a0ad9f7c"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.4/indexsearch-macos-aarch64.tar.gz"
    sha256 "b23a5f9a998acf8f816874b5766aeb623bcb26cc7f481e7156b3ffab12b6b5bc"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.4/indexsearch-macos-x86_64.tar.gz"
    sha256 "4c7c367be847bd9528577bd5dab90d4a9ef00c47f7e404a5c97bd6301f20ea97"
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
