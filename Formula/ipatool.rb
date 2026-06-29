class Ipatool < Formula
  desc "A terminal UI and CLI for searching, purchasing, and downloading iOS App Store IPA files."
  homepage "https://github.com/Kosthi/ipatool-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.0/ipatool-aarch64-apple-darwin.tar.xz"
      sha256 "d2166b125e72559d30ca0634026050bd6b0a7e131f73946d7a013677207f40d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.0/ipatool-x86_64-apple-darwin.tar.xz"
      sha256 "cfc23d3d827876896117054d8d684a83e62bad98e1185233624ad6dc32a1e98d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.0/ipatool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95c99405e204b3f053583344d0a5c27bb417c844ecf70cfd46e09839300b7d04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.0/ipatool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0df8168ba5208b9d3dd3a7f595c2f297f680194e6c429c61ab56ac7e25c245cd"
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
