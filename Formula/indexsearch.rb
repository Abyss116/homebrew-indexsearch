class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.2.6"
  license "NOASSERTION"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.6/indexsearch-macos-aarch64.tar.gz"
      sha256 "f4f634cc0b891c48a35f3ae2b3ae7073feea2e451c31dfebc87101ae4967bf7c"
    else
      url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.6/indexsearch-macos-x86_64.tar.gz"
      sha256 "6fa872dfe5cfdad4b99c33e8e1ea24241c0c1521170a188204a3fbd1b537fa30"
    end
  end

  on_linux do
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.6/indexsearch-linux-x86_64.tar.gz"
    sha256 "21bdeea5d56016a9a52f2a071c8a6725a56cf2cb2b7f5d0bf29acb07eecd2226"
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
