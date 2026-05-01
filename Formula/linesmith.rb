class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.2/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "0ab66964a4224d4e9b7e4b120b514e7bcba2b52666409620ac79c989421bb169"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.2/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "64d15d131b7e8765d58fdceb2884b899aea925da565309ca03660f483a5a26b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.2/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "66122635796aaa56da0c56a9b2c138d7067d4de4f8d43b8ca41071938a177ccf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith-v0.1.2/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "824e8dd7bff5a595b2bcc60b041008ade4c5d03489b581752e31da459e325a3c"
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
