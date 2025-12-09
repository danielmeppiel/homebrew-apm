class ApmCli < Formula
  desc "Agent Package Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm"
  version "0.6.2"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "f943d80d45e262faf27c1025b34db8012a23cbdc1dd2a9e9c604d4074f892ffb"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "454fb2f60a608c1706003cb7340214db3a1b486024edcf3e58cab57698b1d35c"
  elsif Hardware::CPU.arm? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-arm64.tar.gz"
    sha256 "6e5f93573ce322c8f259483c00f712e1638fcf0f294e10412ea46a86b6132add"
  elsif Hardware::CPU.intel? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "73047fae67445540b2fb06da9749aee5cf9748cf7785aa44b46568790fa7ea8b"
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