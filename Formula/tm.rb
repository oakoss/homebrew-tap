class Tm < Formula
  desc "A local-first issue tracker for one human and their AI agents"
  homepage "https://github.com/oakoss/tm"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.5.0/tm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "aa6a55f1cb9a1f63a3765713b07bdb0dc8af6a67f40452e2deda8421c7b3e8a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.5.0/tm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e204567b4f0933445d865723becdc62ebb9966f4a7abcc8c6cde37f83ce21d82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.5.0/tm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9be0422f3b7bd9b8800188e970d231dfbff7d634889800f7cfd2f4b525fa8dd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.5.0/tm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8bd176fa2f44c80829161945bf980a7f1afb706ac13fdad4cd53df44659c1477"
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
