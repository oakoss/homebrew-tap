class Tm < Formula
  desc "A local-first issue tracker for one human and their AI agents"
  homepage "https://github.com/oakoss/tm"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.6.0/tm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "126e5576fd03b86294ad5ef7a015beefd25d073635a978cc6336f05909b5907e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.6.0/tm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "353534f19fdf010450153441fef85902a1961042ab897e24ed20084a1f0782eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.6.0/tm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed28277b008971a6483c0fbc240178c2f63d5a7419e52dcac6846c52acd5d573"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.6.0/tm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9d5fb1f8860ff91474dae4d96779de2c7f6b2d001841bfcaec64ba1766d61f2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
      bin.install "tm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tm"
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
