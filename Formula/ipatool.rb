class Ipatool < Formula
  desc "A terminal UI and CLI for searching, purchasing, and downloading iOS App Store IPA files."
  homepage "https://github.com/Kosthi/ipatool-rs"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.1/ipatool-aarch64-apple-darwin.tar.xz"
      sha256 "046639b64628eb167ab0e5fd05f80aa9f771ffe4de1575821201449933150d95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.1/ipatool-x86_64-apple-darwin.tar.xz"
      sha256 "17ef751345deebf36d4991b0910b50d7c46f4ebb808b414d6e004f70ca36eb7a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.1/ipatool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7772579ad4aa03e1f5de91fd720035c162f9ee257dce3b98ac59baf6248236af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.1/ipatool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "212f291993305f10befbdd0974d63221e9caab0859f0e2ea63a04662e780c896"
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
