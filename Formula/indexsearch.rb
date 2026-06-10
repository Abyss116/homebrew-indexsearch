class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.5.0"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.5.0/indexsearch-linux-x86_64.tar.gz"
    sha256 "3fb79862b11c3734b95a458f05d1605905bcd363324524e80727f82c0a9ff518"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.5.0/indexsearch-macos-aarch64.tar.gz"
    sha256 "d66c4dc54e6933ab0a2fb4dc91572c83e699376a1610c1fd0fe5bb756ef0a948"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.5.0/indexsearch-macos-x86_64.tar.gz"
    sha256 "362ef57aa1bfbea8ec89c7f414ea315837222d92a6533ca432c5a84fbd140f1d"
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
