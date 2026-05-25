class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.2.4"
  license "NOASSERTION"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.4/indexsearch-macos-aarch64.tar.gz"
      sha256 "6855d223dafbc4bbcb364d578d8e53bf2d4c805249ca8660755d16a8eb1befae"
    else
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.4/indexsearch-macos-x86_64.tar.gz"
      sha256 "15d818cca902f0f5a011f2cd94681d490fbb39853192c7911198a1a0ca7f825c"
    end
  end

  on_linux do
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.4/indexsearch-linux-x86_64.tar.gz"
    sha256 "5c29f82aa8861e625a9b5f411a49df92d9615b39670836b0e3af17e54403aa89"
  end

  def install
    artifact = Dir["indexsearch-*"].find { |entry| File.directory?(entry) }
    odie "IndexSearch archive layout changed" if artifact.nil?
    cd artifact do
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
