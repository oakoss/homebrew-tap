class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.1/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "d8f8bd86809664ca7b0dd8fdb846eb331b81b38ae2942937a0371331e6fa1b59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.1/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "128f823b891e64cd3607844c8af6fbf85984994df20ef411e02d70bd538295f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.1/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d71d7ae3864f8c08bd7887bc1e5bdc6c89d03c607ae9c7cb8e2881ef099a775"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.1/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53218ad08b7a08e5d53de153ad9bca6bae2772b571b2c73d0555915ee5d2fd8b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "linesmith" if OS.mac? && Hardware::CPU.arm?
    bin.install "linesmith" if OS.mac? && Hardware::CPU.intel?
    bin.install "linesmith" if OS.linux? && Hardware::CPU.arm?
    bin.install "linesmith" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
