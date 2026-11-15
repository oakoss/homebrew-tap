class Oakum < Formula
  desc "A polyglot release tool that derives dependent version bumps from the dependency graph"
  homepage "https://github.com/oakoss/oakum"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.11.1/oakum-aarch64-apple-darwin.tar.xz"
      sha256 "2628e5fb524cc4c6c3a9520463b0f1abbe995b21d7e1ffa3521e16d5a0bdc590"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.11.1/oakum-x86_64-apple-darwin.tar.xz"
      sha256 "c8b63cad35bce30e482e7d9a28def6044cb6876b37ba714ba5f5aa32052e4c92"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/oakum/releases/download/v0.11.1/oakum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3253f745dabf4795813cfabe83e34f204114295a3a8a978155b06c60c9bd5f34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/oakum/releases/download/v0.11.1/oakum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5983de9c53bf49077424f616614434c8994e77ead06463d28024642515f17a20"
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
