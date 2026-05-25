class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.2.5"
  license "NOASSERTION"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.5/indexsearch-macos-aarch64.tar.gz"
      sha256 "b836a8be4397b0107fe41203d175480296c9a1868af09297aff08ee2b3034126"
    else
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.5/indexsearch-macos-x86_64.tar.gz"
      sha256 "be185040fb7325c2d540de5ab8ace09ce04ef702c589f1507d09b2f7dfac13fc"
    end
  end

  on_linux do
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.5/indexsearch-linux-x86_64.tar.gz"
    sha256 "5ea53cbdc689fa00ae9306ae9f327a95897bb001d607f861a9eba15eab876496"
  end

  def install
    payload = if File.exist?("indexsearch")
      "."
    else
      Dir["indexsearch-*"].find { |entry| File.directory?(entry) }
    end
    odie "IndexSearch archive layout changed" if payload.nil?
    cd payload do
      bin.install "indexsearch"
      bin.install_symlink "indexsearch" => "is"
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
