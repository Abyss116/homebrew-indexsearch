class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.16"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.16/indexsearch-linux-x86_64.tar.gz"
    sha256 "1eae7df51ba68187eafcc483f8539cfbc278f5c260e54105da3bd6baa5af8127"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.16/indexsearch-macos-aarch64.tar.gz"
    sha256 "bea808e0204c33678fdec6e01bcf3cc1f9a5a6d8ab9d64e40bcbc8bb4b85e083"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.16/indexsearch-macos-x86_64.tar.gz"
    sha256 "328513f76731e71056a91dd177d47c65e9d4aae268de1c20ca680ceb6f6e71c1"
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
