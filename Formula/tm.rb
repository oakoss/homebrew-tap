class Tm < Formula
  desc "A local-first issue tracker for one human and their AI agents"
  homepage "https://github.com/oakoss/tm"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.1.0/tm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1b599c3d6f3f50896c69f930cb8a543982b2bac1c02049202b4d588cb3ba8d28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.1.0/tm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d40c6e69fe7d8fa4dd677ce1568bd8b93784526f7c148b32b81de2a270152a07"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.1.0/tm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f6ca0c59e356ea49f7670076045d1cce2c6243e3ba220425e86eb1883c9ab64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.1.0/tm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d62406248b32a2224958e8b4dab0a231d26f302320754a9acdc52348e36c9eda"
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
