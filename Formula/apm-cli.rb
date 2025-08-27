class AwdCli < Formula
  desc "Agent Primitives Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm-cli"
  version "0.0.9"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "9ea4b50236f55c5597f324de53716ec4fad9f6a73e4b39f0d6e3a8da7b17d016"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "c025884c37231c17ea46cfacc53a99f7ff9b701bd5257cf0682db7e6bb6f01d0"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "bbda1ba04afd171ab2104e90845227754b3fcc896929b31ca78aee8253bcae32"
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