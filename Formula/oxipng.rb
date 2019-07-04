class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.2.2.tar.gz"
  sha256 "f2addda729b287ce02a2b853aaa22420ee00cf20e178d6f2238c03438e89c7fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "83f39a695788d36e81ba308da53403aa7b160bad1895be20970a9f5feeba6ab0" => :mojave
    sha256 "4137060ab6b019b98c1f9f5f9dc357062563f9639add33798b52e1bddf733aa7" => :high_sierra
    sha256 "629c0ba06af7be85b205bd89c0430b2bbaf4200cab77ac86fc73ec7e824cbabe" => :sierra
    sha256 "e6c02f841d1e392f6618e59b13aa599a11a210087efd212e8e720ee6d5e23400" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
