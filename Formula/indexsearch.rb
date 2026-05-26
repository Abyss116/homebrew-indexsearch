class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.0"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.0/indexsearch-linux-x86_64.tar.gz"
    sha256 "e9ee3650e782706ba8cfc1a4b76a4b41d86714beebb740e7bc4c1675e0887dcf"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.0/indexsearch-macos-aarch64.tar.gz"
    sha256 "96043425b34a1df082848800af035b4e4ae991edb869d1742cf2880b0c6c921c"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.0/indexsearch-macos-x86_64.tar.gz"
    sha256 "eb583ee2de409f6ada01d6b95d3d514b743f8e3a54508c78deee4528f46c21c6"
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
