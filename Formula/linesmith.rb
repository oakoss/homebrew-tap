class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.2.1/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "1fa647988dc4bb88d95b2476284d45bc4021cecb6a2001bbd38dc46061b1ec0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.2.1/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "475ab4d3ef39645c4ace0e1004025b47bdbb3ebff7759411dd83280229a92387"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.2.1/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13c19fce70b19412b4b8343cc9b00189cc509ee0413b4a43a61eee12147c5761"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.2.1/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee1b8da8d98b1e470fa99dd1b824cf19e3d2a5c67e3f286b337bb1465315aeb5"
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
