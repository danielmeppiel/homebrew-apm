class ApmCli < Formula
  desc "Agent Package Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm"
  version "0.6.1"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "09fd7bab576ea15e9386961f4cd407150c3d958659028eac899c85b663a5a7d7"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "5875d7791f328f68023751a8e8e8f9b0c94a467a463d491ffa60196ee7205635"
  elsif Hardware::CPU.arm? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-arm64.tar.gz"
    sha256 "4a91ae2d04f60cccdfd4840262a7ba29a3982580e16e74adabb0caa6adbb0cee"
  elsif Hardware::CPU.intel? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "04c67a87e91be2a6ac7abf9450f3d8912ad3f75b4b43d4db57e81720ac67b2e5"
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