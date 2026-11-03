class Oakum < Formula
  desc "A polyglot release tool that derives dependent version bumps from the dependency graph"
  homepage "https://github.com/oakoss/oakum"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.1/oakum-aarch64-apple-darwin.tar.xz"
      sha256 "b30f963f12cbba1d6b8dc414a7adb3518ac873192ad3e91413491672773cb59f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.1/oakum-x86_64-apple-darwin.tar.xz"
      sha256 "2c295d6b0e2d53b0c9f95392cb832d343c93cbdc4c1fccdace625c045955de95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.1/oakum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4213b7af1fb82a8295938b2455808387e0b150b7fcbcf4b3fb624757d7a56eba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.9.1/oakum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "375ed42086b41ab7a60b491772c3aacc5ebb790131e01a861db3f869e77ea2d5"
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
