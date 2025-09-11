class AwdCli < Formula
  desc "Agent Primitives Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm-cli"
  version "0.2.0"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "5266c0454f99567e34eacc590ca35b50db361683bbeb969193deb1957cb6b517"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "63f43b6d4726455c61557890d055b5d2ccb844785833a7cd300b529fe1dc1fac"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm-cli/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "4bafc5d8033d2c5515169ef544569a42d3f2899c314b3199784a4ec7989616f1"
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