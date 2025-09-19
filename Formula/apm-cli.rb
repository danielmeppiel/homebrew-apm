class ApmCli < Formula
  desc "Agent Package Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm"
  version "0.4.1"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "75a35251e249706c2eea4014facdd797a26cdba4f886dfd89612e8a60c31c57e"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "5b59f4fc61753ecdcca36c7504a4550ab1fa0251ddbffd3e1b3cfe6e1e2ac385"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "acb318e91eb5b10280a74546dcf3ce08d099dd381b4d793bf34bfbdd5ccc210b"
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