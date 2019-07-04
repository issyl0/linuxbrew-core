class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://pagure.io/releases/newt/newt-0.52.20.tar.gz"
  sha256 "8d66ba6beffc3f786d4ccfee9d2b43d93484680ef8db9397a4fb70b5adbb6dbc"
  revision OS.mac? ? 1 : 2

  bottle do
    cellar :any
    sha256 "5affacd83b0c8584976235ae16a96c5264db5fbe45ed15f618f1da2562a9eb6c" => :mojave
    sha256 "ec087d9023c820072ed8ecd769304ae66d993b9c445949feb020446cee6b3fe2" => :high_sierra
    sha256 "9c5c1376d3346f0417303d9af608c1f2dbded3dd43fe9cc2405117cb412de567" => :sierra
    sha256 "5af95b28d4b3ca4ea3477682e1e52f7b645ec59bba5b21fc00facf748dc4fe86" => :x86_64_linux
  end

  depends_on "gettext"
  depends_on "popt"
  depends_on "s-lang"
  uses_from_macos "python"

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]

    if OS.mac?
      inreplace "Makefile.in" do |s|
        # name libraries correctly
        # https://bugzilla.redhat.com/show_bug.cgi?id=1192285
        s.gsub! "libnewt.$(SOEXT).$(SONAME)", "libnewt.$(SONAME).dylib"
        s.gsub! "libnewt.$(SOEXT).$(VERSION)", "libnewt.$(VERSION).dylib"

        # don't link to libpython.dylib
        # causes https://github.com/Homebrew/homebrew/issues/30252
        # https://bugzilla.redhat.com/show_bug.cgi?id=1192286
        s.gsub! "`$$pyconfig --ldflags`", '"-undefined dynamic_lookup"'
        s.gsub! "`$$pyconfig --libs`", '""'
      end
    end

    inreplace "configure", "/usr/include/python", "#{HOMEBREW_PREFIX}/include/python" unless OS.mac?

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system (OS.mac? ? "python2.7" : "python3"), "-c", "import snack"

    (testpath/"test.c").write <<~EOS
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnewt"
    system "./test"
  end
end
