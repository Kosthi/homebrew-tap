class Ipatool < Formula
  desc "A terminal UI and CLI for searching, purchasing, and downloading iOS App Store IPA files."
  homepage "https://github.com/Kosthi/ipatool-rs"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.5/ipatool-aarch64-apple-darwin.tar.xz"
      sha256 "6c8d172483c2ba6e90204e4eb5924c3efb1369c6e3a2886a47a629b731408786"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.5/ipatool-x86_64-apple-darwin.tar.xz"
      sha256 "5bb0041aa15e4dda5df2de1b890a8fcb3f69f1338f955dc444214e17474def33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.5/ipatool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0c891cae845d14cf30d7515e21e4859e34360626daae8c980ba7d1faff7c2402"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v0.1.5/ipatool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "661bbec26c3d899d09eee93a887b9b938a1c7c04ad2cc703e4e220b89d99d2b9"
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
