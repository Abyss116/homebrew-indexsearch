class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.7"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.7/indexsearch-linux-x86_64.tar.gz"
    sha256 "1dcf1e084a890e03bc0d775ee65620fd95a3386422f4829d72276bd5aff1f159"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.7/indexsearch-macos-aarch64.tar.gz"
    sha256 "2b1cdcaf40fa9aba1e937608d96758b9760e2317716b32b6ad3453db52229881"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.7/indexsearch-macos-x86_64.tar.gz"
    sha256 "cd48a9160098efeef466c5ff938bb9e829613589efad7145ed02c7c98cf926f0"
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
      if File.exist?("isgrep")
        bin.install "isgrep"
      else
        bin.install_symlink "indexsearch" => "isgrep"
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
