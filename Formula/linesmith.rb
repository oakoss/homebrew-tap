class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.0/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "fa22776c8f8afa2467174285281d8d3fe32036c2864044ddf13ffd1415125a1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.0/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "118c506a1db8d1d937327c650fb8a2052221ba1eafce0f60f2e3c1b06db2f086"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.0/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7604c281c2c6a33bfc8759721add6a8143825fd61c10f5516af5cbc1f5e490a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.0/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddf35072c1fd41b023c7bc0defdc3064f9cf0c149e47ad044dfc2f2158092d4a"
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
