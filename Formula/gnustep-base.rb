class GnustepBase < Formula
  desc "GNUstep ObjC Foundation libraries"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-base-1.26.0.tar.gz"
  sha256 "f68bc066c60c73cfc1582326866d0a59be791df56d752dfdc51b838e79364173"
  # tag linuxbrew

  depends_on "libxml2" => :build
  depends_on "pkg-config" => :build
  depends_on "gnustep-make"

  def install
    gnustep_make = Formula["gnustep-make"]

    ENV["GNUSTEP_MAKEFILES"] = "#{gnustep_make.prefix}/share/GNUstep/Makefiles"
    # Allow `./configure` to locate `gnustep-config`.
    ENV.append_path "PATH", gnustep_make.libexec

    system "./configure",
      "--prefix=#{prefix}",
      "--with-default-config=#{gnustep_make.prefix}/etc/GNUstep.conf"

    # Homebrew doesn't run as root, so we need to set the port
    # override so that `make install` is happy.
    inreplace "Tools/gdomap.h",
      "/* #define\tGDOMAP_PORT_OVERRIDE\t6006 */",
      "#define\tGDOMAP_PORT_OVERRIDE\t6006"

    # Silence the "your PATH may be wrong" error that makes the build fail.
    ENV.append_path "PATH", gnustep_make.bin
    system "make"
    system "make", "install"
  end

  test do
  end
end

