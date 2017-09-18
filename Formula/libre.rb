class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.5.tar.gz"
  mirror "https://sources.lede-project.org/re-0.5.5.tar.gz"
  sha256 "90917a173de962d3b20ab5f9875ad3051b7b307da4acb80c184b72e6c2ba7bb4"

  bottle do
    cellar :any
    sha256 "b9901620a2d61f89b554a248ddf24ce36d1a441824f9c86081be66c8b8c59f94" => :sierra
    sha256 "e56bda662069338fc50a4298b7f157dfbb21d9c222ff452338853a558f4eaf15" => :el_capitan
    sha256 "0a856274f6cbf6b52e81672a78cd51af8382f0cfd3dfe30fb2c18d201fadbc07" => :x86_64_linux
  end

  depends_on "openssl"
  depends_on "lzlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
