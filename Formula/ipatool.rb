class Ipatool < Formula
  desc "A terminal UI and CLI for searching, purchasing, and downloading iOS App Store IPA files."
  homepage "https://github.com/Kosthi/ipatool-rs"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.4/ipatool-aarch64-apple-darwin.tar.xz"
      sha256 "9da2b9e1453bff2306f9e3771384949a241ad25743c9ac11f64827c1db65706a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.4/ipatool-x86_64-apple-darwin.tar.xz"
      sha256 "257e43c805ca51a9bc8c36c181f8bbc105468efaa1669b95b7f0d9235f0891a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.4/ipatool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57e405a6fd3c6049e0326b648f226941fdeb50d19ff843061fe7d69aed62ddd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.4/ipatool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3af04f051a70ef43bbd551cf0b76e183cd0feead7343db525ea568910014d8cb"
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
