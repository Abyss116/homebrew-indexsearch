class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.29"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.29/indexsearch-linux-x86_64.tar.gz"
    sha256 "12328b04a676f852a720f7c1c0b1a26600e238da3b239b048c50572cb41b90da"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.29/indexsearch-macos-aarch64.tar.gz"
    sha256 "ed369687102818e0cbbae21cd7b33c04ac0b04ffe5885374e57f955df99d582b"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.29/indexsearch-macos-x86_64.tar.gz"
    sha256 "23089d8d08cf81e25d7e9f944174ada982c344b76c5251b51e463a18d26ebedd"
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
