class AwdCli < Formula
  desc "Agent Primitives Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm-cli"
  version "0.1.2"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "9ecd1130796ecc54a8ecac1a92f216c8bd70f72dc23915e02a822f8761b887bf"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "10cac5d5ede38abd3fabbbe0a189a9031739176ddedcfac5ba0ad03bb33e6165"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "735f4f4decfb4281b0c5a912d00fa5a11c0e1d427386534f6a791b9531b867ef"
  end

  def install
    # Install the entire directory structure since the binary depends on _internal for dependencies
    libexec.install Dir["*"]
    
    # Fix PyInstaller framework signing issue: Homebrew fails to sign Python.framework
    # because it's ambiguous between app and framework bundle format
    if OS.mac?
      # Remove the problematic existing signature that confuses Homebrew's codesign
      python_framework = "#{libexec}/_internal/Python.framework/Python"
      if File.exist?(python_framework)
        system "codesign", "--remove-signature", python_framework
      end
    end
    
    bin.write_exec_script libexec/"apm"
  end

  test do
    system "#{bin}/apm", "--version"
  end
end