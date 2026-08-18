class Linesmith < Formula
  desc "A Rust status line for Claude Code and other AI coding CLIs"
  homepage "https://github.com/oakoss/linesmith"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.1/linesmith-aarch64-apple-darwin.tar.xz"
      sha256 "267e538ec2e7a6bab176e46fe5cadf6cc44bb5b5fc9ec36d493865ceda737631"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.1/linesmith-x86_64-apple-darwin.tar.xz"
      sha256 "68438cd4ad38a86c33665b1ff7db8e36a82884631891a1ce09e51f5659f0446e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.1/linesmith-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6fae522686890dd5366ebec022e158d0cdf1ed48ae3adfebb5710debaceecb81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oakoss/linesmith/releases/download/linesmith/v0.4.1/linesmith-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "008a624bc35589ee68a50127980801efbc2972906e34b28ebb19751918a1cdb4"
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
      bin.install "gen-config-schema", "linesmith"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gen-config-schema", "linesmith"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gen-config-schema", "linesmith"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gen-config-schema", "linesmith"
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
