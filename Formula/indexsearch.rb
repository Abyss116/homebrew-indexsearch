class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.14"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.14/indexsearch-linux-x86_64.tar.gz"
    sha256 "458211e66bf876e3e64767e88d65bcbeb145ff8efc6eccab5350e4479e5ee164"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.14/indexsearch-macos-aarch64.tar.gz"
    sha256 "f30add77a4974294845f5ac2c86058536dbe0a176845937ed1ccc232f1a9746d"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.14/indexsearch-macos-x86_64.tar.gz"
    sha256 "319647dd5c40fe19bdcaf32699197b2a19de0ca830b21c693e2c7f656edde9e2"
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
