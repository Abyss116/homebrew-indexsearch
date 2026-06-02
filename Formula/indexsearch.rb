class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.4.6"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.6/indexsearch-linux-x86_64.tar.gz"
    sha256 "342469563a4eec4140d21b973cf46b4909791a50b107a3385f0e2d0a6048c287"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.6/indexsearch-macos-aarch64.tar.gz"
    sha256 "633b658a76e5f00093b7eca67063609bae00502149a8e23c920039128c5d78c9"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.4.6/indexsearch-macos-x86_64.tar.gz"
    sha256 "9cd4ef3ab95991ef404f838e9c3827cba7a80ab8b2df0861b02ff65f715b27fe"
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
