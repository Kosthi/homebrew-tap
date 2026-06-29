class Ipatool < Formula
  desc "CLI tool for searching, purchasing, and downloading iOS IPA files from the App Store"
  homepage "https://github.com/Kosthi/ipatool-rs"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v#{version}/ipatool-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "696565c43a1977687fbe922aa0114e2ffb8e0434f49c5fe3584813fedf79d787"
    else
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v#{version}/ipatool-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "caad404c354934c4e14c9116fa804f6bfb527394d26e58b84a62834e80f23be2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v#{version}/ipatool-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "90b70a9de19e44b00b00b2d6252a2ece9c40ddc8a19a5ed244c7480f57d15e69"
    else
      url "https://github.com/Kosthi/ipatool-rs/releases/download/v#{version}/ipatool-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "21ed78b5a4ef5b1f820b675ef1bdd5dd51f71b1fab4a51f4a26beaf978b24eba"
    end
  end

  def install
    bin.install "ipatool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")
  end
end
