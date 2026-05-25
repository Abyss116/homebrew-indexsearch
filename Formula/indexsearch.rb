class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.2.7"
  license "NOASSERTION"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.7/indexsearch-macos-aarch64.tar.gz"
      sha256 "c4fb02833b52ac95e1dc85c8f07a838621878e535972195251c10449e9ed9016"
    else
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.7/indexsearch-macos-x86_64.tar.gz"
      sha256 "a99138024377ccb2bbbbf6a33212026d0f852ab7e618983caaa4b97bcf71b3c2"
    end
  end

  on_linux do
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.7/indexsearch-linux-x86_64.tar.gz"
    sha256 "60f820b86275a4f8b5bbdb7ff0ef1e8d93e8ac7cbb863ef1be8ead5a69eea896"
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
