class Indexsearch < Formula
  desc "Persistent-index rg-like search for large source trees"
  homepage "https://github.com/Abyss116/IndexSearch"
  version "0.3.22"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.linux?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.22/indexsearch-linux-x86_64.tar.gz"
    sha256 "222d5b71b86033f349ce9c6e65d4e00586c9af6d5fc20fe263ef9d3fc650b6c0"
  elsif Hardware::CPU.arm?
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.22/indexsearch-macos-aarch64.tar.gz"
    sha256 "b18d3aaef88d5dac1156e1f30229709b6cf6f7e725cd460ac906bd17707c7e4d"
  else
    url "https://github.com/Abyss116/IndexSearch/releases/download/v0.3.22/indexsearch-macos-x86_64.tar.gz"
    sha256 "6bb7220892581834247bf2fdd782f262ec0003634ada4209a2c836ad26bb8cc5"
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
