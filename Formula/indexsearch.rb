class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.3"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.3/indexsearch-linux-x86_64.tar.gz"
    sha256 "a077a8613b335e2e4729b46d71ba64fe1311e6d203370fb69397d4b8974b16e8"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.3/indexsearch-macos-aarch64.tar.gz"
    sha256 "408388297a5359d2af3d5652d5a504c2cca7e2c036e3cd41cba778fcab56a958"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.3/indexsearch-macos-x86_64.tar.gz"
    sha256 "a3ef0afb5a650a12c5237de184546357cd643ddf91e2b670d820634501db939c"
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
