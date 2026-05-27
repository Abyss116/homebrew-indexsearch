class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.25"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.25/indexsearch-linux-x86_64.tar.gz"
    sha256 "022190c71cceb0a966d0aeb0a13e330f4c5316ab150fb7c6f7b4b25a58fe74ee"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.25/indexsearch-macos-aarch64.tar.gz"
    sha256 "30b66a5ee3d5cda616710cd0c53d76bebe4e7edc6b097653a777d0404da04e57"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.25/indexsearch-macos-x86_64.tar.gz"
    sha256 "47d1ef2d83d57ee948bde2712760384f47ed0d76d0359c77d8625e8f04c62ad5"
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
