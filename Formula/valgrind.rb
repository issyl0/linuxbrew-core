class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  license "GPL-2.0"

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.16.1.tar.bz2"
    sha256 "c91f3a2f7b02db0f3bc99479861656154d241d2fdb265614ba918cc6720a33ca"

    depends_on maximum_macos: :high_sierra if OS.mac?
  end

  bottle do
    sha256 "7170a66beb19ccfd79d1559fe57c67fb4a6a7b6369775621f5073af6fea07ea8" => :high_sierra
    sha256 "2d8a4799977d4e8f6e5bfcf2f52decf67c3a39d860c7cd18ed0b4e9a8eb02326" => :x86_64_linux
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-only64bit"
    args << "--build=amd64-darwin" if OS.mac?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage", shell_output("#{bin}/valgrind --help")
    # Fails without the package libc6-dbg or glibc-debuginfo installed.
    system "#{bin}/valgrind", "ls", "-l" if OS.mac?
  end
end
