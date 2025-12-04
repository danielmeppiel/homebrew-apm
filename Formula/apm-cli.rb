class ApmCli < Formula
  desc "Agent Package Manager (APM): The NPM for AI-Native Development"
  homepage "https://github.com/danielmeppiel/apm"
  version "0.5.9"
  license "MIT"

  if Hardware::CPU.arm? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-arm64.tar.gz"
    sha256 "faeb574b19973d850c9b126931e9018852a5b2a065813eda6e5f9a3a73b70ac3"
  elsif Hardware::CPU.intel? && OS.mac?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-darwin-x86_64.tar.gz"
    sha256 "1d985320f8d4c4edf095327ded27112d498525a556c2bb60685e9c5772b3ff35"
  elsif Hardware::CPU.arm? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-arm64.tar.gz"
    sha256 "2fc4ecb2b1365ed9f38b1eddefb6eadbba1e3e376ad12894229d4ba94151be6c"
  elsif Hardware::CPU.intel? && OS.linux?
    url "https://github.com/danielmeppiel/apm/releases/download/v#{version}/apm-linux-x86_64.tar.gz"
    sha256 "995a621a91335b570f17a2bcc2e1b1e79b7e2468735ba363aee4e342dc71efe7"
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