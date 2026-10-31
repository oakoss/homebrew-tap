class Oakum < Formula
  desc "A polyglot release tool that derives dependent version bumps from the dependency graph"
  homepage "https://github.com/oakoss/oakum"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.8.2/oakum-aarch64-apple-darwin.tar.xz"
      sha256 "8e2af4ed31f42a45cbebb79bcbc72bddd3d4e604f498b25032e26a41bc71f272"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.8.2/oakum-x86_64-apple-darwin.tar.xz"
      sha256 "e405d600e466f58414995b41af486b2179c9ec2a82e61a36ae5487b46f5d5a5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.8.2/oakum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f999b7e9e66b0ee3a0dea62edda0d73d45dbdeafa918f5894e0b5e0700ac51b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.8.2/oakum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e799cf3a3852599e303c6049b6c7c7f8727c9c6908f92a8f7da1d11b310487fe"
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
