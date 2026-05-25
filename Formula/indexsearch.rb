class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.2.8"
  license :cannot_represent

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.8/indexsearch-linux-x86_64.tar.gz"
    sha256 "1e39f84919b68d50370a71fee7dc061dab3989512618fe9046dfab2987175faa"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.8/indexsearch-macos-aarch64.tar.gz"
    sha256 "fc08b5d4d0d481a6de3d3d6910ef5e9d46218955c8a744fb2f06074c5bd11d07"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.2.8/indexsearch-macos-x86_64.tar.gz"
    sha256 "b92afa87ecdf07f84ecf0f225713202036411fa7c10bfc9fab47b1b2f3faa8e1"
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
