class AwdCli < Formula
  desc "Agent Primitives Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm-cli"
  version "0.4.0"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "4bf66233a12119472cd5775e73a1e14b75271d0367866543153aeee08dbd1603"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "1fdf0189b1a8483a2665ab6d556a84684332771741d2a6158b928df3dd6f9fca"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "fb7e12acb24e0efe31eee982e6b2904677d5931c57ba415c26d373a504828030"
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