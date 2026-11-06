class Oakum < Formula
  desc "A polyglot release tool that derives dependent version bumps from the dependency graph"
  homepage "https://github.com/oakoss/oakum"
  version "0.9.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.3/oakum-aarch64-apple-darwin.tar.xz"
      sha256 "ab40a953360ba2425df2f10633973a8587e694ab15e2d7241086912ca2a8307e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.3/oakum-x86_64-apple-darwin.tar.xz"
      sha256 "af85d3a012809a44be3d4060e7aa89f2390c844533e915f5c85cb52377bc5f9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.3/oakum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "283f44ccb8718e3da4d9da21d3c939f167dab30f0303754b312471298f7499e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.3/oakum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23c29d5939220ca921589c4288f0f23368d3cf60d7ccce0adb2f538ba052fb3c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "oakum"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "oakum"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "oakum"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "oakum"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
