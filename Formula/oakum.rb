class Oakum < Formula
  desc "A polyglot release tool that derives dependent version bumps from the dependency graph"
  homepage "https://github.com/oakoss/oakum"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.6.0/oakum-aarch64-apple-darwin.tar.xz"
      sha256 "a987aa9a662ac2a7ec0af453c43a0c1c8735c5ea37e0d071eb1f8ea703baed53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.6.0/oakum-x86_64-apple-darwin.tar.xz"
      sha256 "24800fb86d2f5b3293faa42a02acb85387b2ba639683861874209ad88b08ca5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.6.0/oakum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e573d37baffb295892ec7e04155b248e7bd3d3cc0d9406aa3008256041c1a8d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.6.0/oakum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "237270c037e6b75124b13f54d74b8651a2c81eeb1b1addd0ffeb03beaf03962e"
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
