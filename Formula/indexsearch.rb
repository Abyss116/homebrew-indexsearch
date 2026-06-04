class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.10"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.10/indexsearch-linux-x86_64.tar.gz"
    sha256 "63664476b73799378fed98e20c393be513d99057b5177e72fea2e53dddc1ee6c"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.10/indexsearch-macos-aarch64.tar.gz"
    sha256 "c7c8c17d78c63c691eeb0452b77212bc8eefb5dfe7e0333213a2221e8b6ad46a"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.10/indexsearch-macos-x86_64.tar.gz"
    sha256 "853e5128c1b20703796e1985385152ea906c60a8156975cc191cfc13fcee94a6"
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
