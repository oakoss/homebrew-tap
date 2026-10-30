class Tm < Formula
  desc "A local-first issue tracker for one human and their AI agents"
  homepage "https://github.com/oakoss/tm"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.3.0/tm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9be4ee79244595e95326b960b891ca7fddfaf5f4451b3d723594ad8f2e8a6462"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.3.0/tm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0eea1c58e9816d452810e39cc34bc4cc8059c6ed6a5f9312bab35f22797acadf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.3.0/tm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d632f71a28a54cf5e906489ff4fba63bb9a8afc81ca618e1e0cfb7d2006e1f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.3.0/tm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "61d3a997a639c5d169864aa8b48373722c650763f65379e774cb4898c30a2850"
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
