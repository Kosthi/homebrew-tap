class Ipatool < Formula
  desc "A terminal UI and CLI for searching, purchasing, and downloading iOS App Store IPA files."
  homepage "https://github.com/Kosthi/ipatool-rs"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.3/ipatool-aarch64-apple-darwin.tar.xz"
      sha256 "12ae09fa7b8ab1851d8c93660414cc9e6a140c7f083ed5f28cd7a6ed6feb025e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.3/ipatool-x86_64-apple-darwin.tar.xz"
      sha256 "69fb3fcacf2f6c19c4a2c23962d8b9ee8b79c758f8d11b0ab7bbf1c93d14f0eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.3/ipatool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67ca67ab1a5b7227c3a66b7463464db5588475f47bdf62c9216b334b7c2a9a05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.3/ipatool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9cb2875d000f9a538a146e1e0443a7d8b77a288a95b958d5829e6dc17dc1e703"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "ipatool" if OS.mac? && Hardware::CPU.arm?
    bin.install "ipatool" if OS.mac? && Hardware::CPU.intel?
    bin.install "ipatool" if OS.linux? && Hardware::CPU.arm?
    bin.install "ipatool" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
