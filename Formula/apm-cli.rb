class ApmCli < Formula
  desc "Agent Package Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm"
  version "0.5.4"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "6cf74e42ab68680dc73f88024a92ea42e0044a69a7fc319f9300a94107298062"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "47c8f7c6a2edcf40629a705a74d2f998c1388170ec223289c8195bf74b849d16"
  elsif Hardware::CPU.arm? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-arm64.tar.gz"
    sha256 "c3ebf69b17173adf63b26369c55aed7b7473511714191433e62e5fe97e813311"
  elsif Hardware::CPU.intel? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "7b3b76f90c32f167d29fba8f1aca96eccbd483a5c3b1c2e2bbd6a6a1f3063cd1"
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