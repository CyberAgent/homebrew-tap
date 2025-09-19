class ReminderLint < Formula
  desc "reminder-lint command line tool."
  homepage "https://github.com/CyberAgent/reminder-lint"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CyberAgent/reminder-lint/releases/download/0.2.0/reminder-lint-aarch64-apple-darwin.tar.xz"
      sha256 "aa9e7603fb7556636c1f28309d8a85c74f1df72c23e27a3c4fc9c444715a759c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CyberAgent/reminder-lint/releases/download/0.2.0/reminder-lint-x86_64-apple-darwin.tar.xz"
      sha256 "ccf6856699b066e3280149c7430a95cad1f9056f464360ec6e14c36c546d5802"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/CyberAgent/reminder-lint/releases/download/0.2.0/reminder-lint-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6fe6b3c8a5fe9c234480d9a6be16860e82a6bddc996de6c0d00a605de4c8d423"
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
