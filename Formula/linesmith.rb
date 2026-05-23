class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/v0.2.0/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "c56615beba74620d6b2d4b98a32add6ecb374705e246b82a73268111cb3e6e0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/v0.2.0/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "0755b09e9a0f3971781671b7f4a7c39bf52b7edc8b6cf56ff7f99d87c09190ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/v0.2.0/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8d101680fadeaffcf528e45dde992ee2e58b98cef4be9eca38e13d6f9d347d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/v0.2.0/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "716b1e8f81f393e3cb78d73a4905f982a6004dabc793b64c44d1bcf9f57c570f"
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
    bin.install "gen-config-schema", "linesmith" if OS.mac? && Hardware::CPU.arm?
    bin.install "gen-config-schema", "linesmith" if OS.mac? && Hardware::CPU.intel?
    bin.install "gen-config-schema", "linesmith" if OS.linux? && Hardware::CPU.arm?
    bin.install "gen-config-schema", "linesmith" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
