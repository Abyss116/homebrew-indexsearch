class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.8"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.8/indexsearch-linux-x86_64.tar.gz"
    sha256 "8eb1ceddbd87f410d213cff22b8ab7f953896827067056fefc7b3627e07de997"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.8/indexsearch-macos-aarch64.tar.gz"
    sha256 "b55572ad39b7e5e30472d94f932316b38d1b810595a62da0d996aa1e9e2104ff"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.8/indexsearch-macos-x86_64.tar.gz"
    sha256 "dc3ab1a46d0e8f85589610cb0ed16966f645c5f5fe0205b355536cfd20b1307d"
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
