class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.2"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.2/indexsearch-linux-x86_64.tar.gz"
    sha256 "b2fb828886f71dd6678275d083ef9da389ef4a6b0758797c704e17eb36a76d04"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.2/indexsearch-macos-aarch64.tar.gz"
    sha256 "46ee8060fad670e9ce515a787bf10763a7cbb4b83c917e27eeff27b3194e8e38"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.2/indexsearch-macos-x86_64.tar.gz"
    sha256 "957e32cb1044dd2fc2c2afaa85400a2896b6e3ce7f4189c0f6d4f9e6125eb5e9"
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
