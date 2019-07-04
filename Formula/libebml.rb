class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.9.tar.xz"
  sha256 "c6b6c6cd8b20a46203cb5dce636883aef68beb2846f1e4103b660a7da2c9c548"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "ac543015948d0f4068ffc45c24ae09129ebaef9971d5301ffe43787f3146e4f2" => :mojave
    sha256 "bf005e877a8b7abdef3fc39c5964ad202ab6797ab1467c3209bc947ac4cdf70a" => :high_sierra
    sha256 "60249b3b2a0d6b4c18bd5ee8eb9a475b5a8622c5919b0e22962ce2232b691728" => :sierra
    sha256 "66564d4ca86c090e4809d06745011ac3f0c6772cf24503b2951e0c76d806c3ed" => :x86_64_linux
  end

  depends_on "cmake" => :build
  unless OS.mac?
    fails_with :gcc => "5"
    fails_with :gcc => "6"
    depends_on "gcc@7"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
