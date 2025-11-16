class ApmCli < Formula
  desc "Agent Package Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm"
  version "0.5.3"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "df92f3bada0534efeaa1a00fd0b6ba0a4fa0271ea5cd5f9e4d0f7202a9032873"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "b1f3a2fc71044ba1ab4368f8f3a958300fddcb8e6dcd8bf269a66dfa0eeaaab4"
  elsif Hardware::CPU.arm? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-arm64.tar.gz"
    sha256 "d6b08bc56bb5ecba20afe0dc0dfa4842d452d911c9ef3b91b802c3e73e50005d"
  elsif Hardware::CPU.intel? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "20abcb40917907630b0b93b929e31423837e31d2cb3077d4e1b2f06d3dde5247"
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