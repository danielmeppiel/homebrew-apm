class AwdCli < Formula
  desc "Agent Primitives Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm-cli"
  version "0.1.7"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "2e2d97d760d05b47ef3cde8ef9706248586b5e06d1045578dfefb6fe53015f8b"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "e8aa7273d879e24f3a524004b3da6ac512b8bea6d061fe7705758b0862ae4af5"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "9017b1e02a6f26c5dee79cab2ca919800daf3e5ff56a6d877194aa1d4461ff21"
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