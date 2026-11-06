class Tm < Formula
  desc "A local-first issue tracker for one human and their AI agents"
  homepage "https://github.com/oakoss/tm"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.4.1/tm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e8a11142fa7703ba3f17a2925195c09105fb3e258983b3b429c1d96d48b3fe45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.4.1/tm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0302f2501e527bd3da09eb5e65b8b6e2217a1cfcb007760227689c07407d907b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/tm/releases/download/v0.4.1/tm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f4888fe9420bf3ea736905e30ee2bf5b2830f0310cd82aa2eb7c80a1e034ec48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/tm/releases/download/v0.4.1/tm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1462703375c0eafe4e694605b7b36430440eca7d629087089b721ce2a612b1b1"
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
