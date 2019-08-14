require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.1.3.tar.gz"
  sha256 "6a5b07e06585133bd385632c610f38d0c225a887e1ccb697ab09fec387838976"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a1a1e67c0884e8c4d9fae16e006ae77bb1658bf07a02f408cca6d0f75a497d1" => :mojave
    sha256 "43a526d7665e5c77a42bc31c86673731cb18f9dd57b7c55c8015270e5f0bbf68" => :high_sierra
    sha256 "c31f96e6b957ef560cd360a772bf9caa2100d053ce0873de12916e9e49e6866b" => :sierra
  end

  depends_on "cabal-install" => :build
  uses_from_macos "zlib"

  # Stack requires stack to build itself. Yep.
  resource "bootstrap-stack" do
    if OS.mac?
      url "https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-osx-x86_64.tar.gz"
      sha256 "84b05b9cdb280fbc4b3d5fe23d1fc82a468956c917e16af7eeeabec5e5815d9f"
    else
      url "https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-linux-x86_64.tar.gz"
      sha256 "c724b207831fe5f06b087bac7e01d33e61a1c9cad6be0468f9c117d383ec5673"
    end
  end

  # Stack has very specific GHC requirements.
  # For 2.1.1, it requires 8.4.4.
  resource "bootstrap-ghc" do
    if OS.mac?
      url "https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-apple-darwin.tar.xz"
      sha256 "28dc89ebd231335337c656f4c5ead2ae2a1acc166aafe74a14f084393c5ef03a"
    else
      url "https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-deb9-linux.tar.xz"
      sha256 "47c80a32d8f02838a2401414c94ba260d1fe82b7d090479994522242c767cc83"
    end
  end

  def install
    (buildpath/"bootstrap-stack").install resource("bootstrap-stack")
    ENV.append_path "PATH", "#{buildpath}/bootstrap-stack"

    resource("bootstrap-ghc").stage do
      binary = buildpath/"bootstrap-ghc"

      system "./configure", "--prefix=#{binary}"
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    cabal_sandbox do
      # Let `stack` handle its own parallelization
      # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
      jobs = ENV.make_jobs
      ENV.deparallelize

      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "build"
      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
             "install"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
