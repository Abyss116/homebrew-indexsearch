class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.2.9"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.9/indexsearch-linux-x86_64.tar.gz"
    sha256 "2a07de22e1e23d8b09aae6f261ad682e36715748ac36655fe342b99b040c76e6"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.9/indexsearch-macos-aarch64.tar.gz"
    sha256 "72ddf8e8df890d3c154c4328621430d8e76b0ed253250058d8ac7f8a7bd4bdeb"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.9/indexsearch-macos-x86_64.tar.gz"
    sha256 "8c1c70e77c1b2bb3987a4d03581c889737c95934c741ecd13681c6d541a89add"
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
