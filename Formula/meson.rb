class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.49.1/meson-0.49.1.tar.gz"
  sha256 "e90c8ee46109d3b9d9a12c76c65811d4a7f7e18503f780eb301866e43d9052cb"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe1ae1d0af6fa9b79e58e667527d907711b1024216b50cdc598f6bf2e1b3515e" => :mojave
    sha256 "fe1ae1d0af6fa9b79e58e667527d907711b1024216b50cdc598f6bf2e1b3515e" => :high_sierra
    sha256 "be67ef4ad8c94e47151afc5784347a4fdac6a3a58fc96bb962a3acb7ddd2d119" => :sierra
    sha256 "f1aad33bf3b26140748aad8c39144d330e1a1da44a7ace8bc6f88dfa630d7aed" => :x86_64_linux
  end

  depends_on "ninja"
  depends_on "python"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
