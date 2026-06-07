class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.12"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.12/indexsearch-linux-x86_64.tar.gz"
    sha256 "a55b7378503dcfd16cbeaa67a740777084457910135ce6ef20f4c6d21dbedc5b"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.12/indexsearch-macos-aarch64.tar.gz"
    sha256 "a87789b6a9d6d5bd51f57d7cf5928f90be35e71675a328cc50b1f25a0a27904f"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.12/indexsearch-macos-x86_64.tar.gz"
    sha256 "7c0b14d31b7f977e20faeded03ba6ed2195610e8a1dab6f0d27495d9390624b6"
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
