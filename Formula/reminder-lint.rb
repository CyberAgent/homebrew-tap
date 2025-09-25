class ReminderLint < Formula
  desc "reminder-lint command line tool."
  homepage "https://github.com/CyberAgent/reminder-lint"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CyberAgent/reminder-lint/releases/download/0.2.1/reminder-lint-aarch64-apple-darwin.tar.xz"
      sha256 "e80e1db0495f3916d34dd9ecddf54848efef020729625084963915be72b51c3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CyberAgent/reminder-lint/releases/download/0.2.1/reminder-lint-x86_64-apple-darwin.tar.xz"
      sha256 "09ceadff298c7be62a26f13bb9fe23ba53d68c10619af5d738caadfe020b99c4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/CyberAgent/reminder-lint/releases/download/0.2.1/reminder-lint-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "689bf62ea92f0fba8562984604924af94e8b35ce85a1a6bd89d44fddbad20f66"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "reminder-lint" if OS.mac? && Hardware::CPU.arm?
    bin.install "reminder-lint" if OS.mac? && Hardware::CPU.intel?
    bin.install "reminder-lint" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
