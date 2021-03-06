class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 3

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  bottle do
    rebuild 1
    sha256 "44913001d85002b75a715b3b8d12ef0fcbc3a1de152546d8fe5297544af367d6" => :catalina
    sha256 "744efdd95f6dc3152ab39da781d5cc9ef81a5caa7310097b00a903e1e595e188" => :mojave
    sha256 "0ec10e9ba748c3ce1bbb2502b8f9736fcdd1c72d492fdf4c58e2e3c0f6442f4b" => :high_sierra
    sha256 "df7c4f2ede961688c72b588cb4e08702603caf19ad08d2c00721e95c9a503716" => :sierra
    sha256 "3a1c2c21503f8e11b8f1cea52e5ce39e1aa627806edc1c10d8dea6aa9b5c78fd" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
