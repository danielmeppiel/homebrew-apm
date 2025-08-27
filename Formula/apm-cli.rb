class AwdCli < Formula
  desc "Agent Primitives Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm-cli"
  version "0.1.0"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "045888cf8427a46264292371855d9c18a0e9e89b85b46b6ac8b86c784dff5092"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "9b86f58724d00e8bdb4405963d4c432f271148fccc7c7fa781dc57c159c967fe"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "bc23fd477167bc8639338a16dc6b9c14b3af1643bf21e3a4777ee529f033baea"
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