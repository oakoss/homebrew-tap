class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.3/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "4ce42644fe195fdb4315fd4ce5353fe322d90cdc129f6275340703a9c725a1fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.3/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "94abd079073347152eb46f018910dfcf2816ac4500fd4533a4cfad810efc842c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.3/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a4b66cf3248bb11299c8c411ecdfb734443ddcb8d947e5ae5f5d2694ae8e6f28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.3/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6d5e7d9a67f4278ecf71ba615a19a9c94ea6f64739e9d1eee85ec4ea23aadb2"
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
