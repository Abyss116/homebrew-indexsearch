class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.11"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.11/indexsearch-linux-x86_64.tar.gz"
    sha256 "616035e2870f4ebf5d1fecf8ba62c6e79144a48af058b0f370afcad3b553ba87"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.11/indexsearch-macos-aarch64.tar.gz"
    sha256 "3035162242c2952d07f1ab0334dead76c50d035f5c4a834733d487b5f436f04b"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.11/indexsearch-macos-x86_64.tar.gz"
    sha256 "4e80c9edc7edeacf5ba3d166cdabc19db46a24a9dba74a6a830c222e383e2b58"
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
