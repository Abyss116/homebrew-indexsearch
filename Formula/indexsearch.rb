class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.9"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.9/indexsearch-linux-x86_64.tar.gz"
    sha256 "8aa50d74a3c3fffc3c4bb938b84f753c7f7004ac44ed601c27d3bb4efd29410a"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.9/indexsearch-macos-aarch64.tar.gz"
    sha256 "876394a73b69634461a30363de706b4ea9460baae7db1d05680c35d477422057"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.9/indexsearch-macos-x86_64.tar.gz"
    sha256 "a33a98c4644f02a713b6513279644acc3611042aa8b9ccd04d747fbe5e7aef86"
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
