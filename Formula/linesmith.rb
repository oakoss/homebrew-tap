class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.0/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "606d52e4820ca808572b05ca0814cc4d3a23eb5eeb5ea2b31ded6d1d5300e9a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.0/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "2db17d1568f6b447b25c55988179b724cbce87ded91f3f13797400a5945bab74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.0/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b37e16ab05b3817904b2de7ac9d4616ef47cfa43d096ba82992f6e7144a4b987"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/v0.1.0/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23c58048d23e7049d88a5b46256e1c227619ed3bb4f7286ac4a19a1dc96ca889"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
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
