class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.9.tar.gz"
  sha256 "062cf1f91364d2d6ea717e92304ca163cfba5d14b30bb440ee118d1b8e10328d"
  license "MIT"

  bottle do
    cellar :any
    sha256 "d85ec4ab953ce62ec26b3f632943f4155c7b4b06a6c7bfeec4af334bd3453c5d" => :catalina
    sha256 "8a4663dd80ed90899b51c5a568b1a8330b06441eba93cfa70e773514dbba4b2d" => :mojave
    sha256 "a3c07658f4050be94c37c341f262b7c82a808dd696f349841aa0e83b07eaf8e7" => :high_sierra
    sha256 "bd02c7d499042883e3fc3a879a45d3e280d2a0ebd8dd0e0eedff74fe033bcc47" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  # fix Makefile issue, remove in next release
  if OS.mac?
    patch do
      url "https://github.com/Javanaise/mrboom-libretro/commit/c777f1059c9a4b3fcefe6e2a19cfe9f81a13740b.diff?full_index=1"
      sha256 "19f469ccde5f1a9bc45fa440fd4cbfd294947f17b191f299822db17de66a5a23"
    end
  else
    patch :DATA
  end

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
  end

  test do
    require "pty"
    require "expect"
    require "timeout"
    PTY.spawn(bin/"mrboom", "-m", "-f 0", "-z") do |r, _w, pid|
      sleep 1
      Process.kill "SIGINT", pid
      assert_match "monster", r.expect(/monster/, 10)[0]
    ensure
      begin
        Timeout.timeout(10) do
          Process.wait pid
        end
      rescue Timeout::Error
        Process.kill "KILL", pid
      end
    end
  end
end
__END__
diff --git a/Makefile b/Makefile
index f10b4d073d5d05fb91254479bc6186ca0fd4b8f8..17b8a4052ef0813a04792da8d4ff0cfadd088e6c 100644
--- a/Makefile
+++ b/Makefile
@@ -500,11 +500,11 @@ clean:
	rm -f *.d */*.d */*/*.d */*/*/*.d */*/*/*/*.d */*/*/*/*/*.d

 strip:
-	$(STRIP) $(TARGET_NAME).out
+	$(STRIP) $(TARGET_NAME)

 install: strip
	$(INSTALL) -m 0755 -d $(DESTDIR)$(PREFIX)/$(BINDIR)
-	$(INSTALL) -m 555 $(TARGET_NAME).out $(DESTDIR)$(PREFIX)/$(BINDIR)/$(TARGET_NAME)
+	$(INSTALL) -m 555 $(TARGET_NAME) $(DESTDIR)$(PREFIX)/$(BINDIR)/$(TARGET_NAME)
	$(INSTALL) -m 0755 -d $(DESTDIR)$(PREFIX)/$(MANDIR)
	$(INSTALL) -m 644 Assets/$(TARGET_NAME).6 $(DESTDIR)$(PREFIX)/$(MANDIR)
