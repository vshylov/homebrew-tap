# Rendered by bump.py from formula.rb.in — edit the template, not Formula/mindfork.rb.
class Mindfork < Formula
  desc "Terminal AI chat with memory: local models via llama.cpp, or the clouds"
  homepage "https://mindfork.io"
  url "https://github.com/vshylov/mindfork-rs/releases/download/v0.16.0/mindfork-rs-v0.16.0-aarch64-macos.tar.gz"
  sha256 "f71b642003c417591eb7300586dfab97eb2b55549a2a832cc04f5df2a3254211"
  license "MIT"

  # The release builds macOS for Apple Silicon only: an Intel Mac would have
  # neither the Python sandbox nor Metal (mindfork-rs, docs/research/macos.md §1).
  depends_on arch: :arm64
  depends_on :macos

  def install
    # The release's archive as it is: the binary, and beside it data/ with the
    # spellcheck dictionaries, and the licence texts.
    libexec.install Dir["*"]
    # Chats, notes and settings in ~/Library/Application Support/mindfork-rs
    # rather than beside the binary: an upgrade replaces this Cellar directory.
    # The app follows bin/'s link back here, where it reads this file.
    (libexec/"defaults.json").write "{ \"mode\": \"system\" }\n"
    bin.install_symlink libexec/"mindfork"
  end

  def caveats
    <<~EOS
      Chats, notes and settings live in ~/Library/Application Support/mindfork-rs:
      an upgrade or an uninstall leaves them in place.
      No model yet? `mindfork demo` opens the app with sample chats and a scripted engine.
    EOS
  end

  test do
    assert_match "mindfork #{version}", shell_output("#{bin}/mindfork --version")
  end
end
