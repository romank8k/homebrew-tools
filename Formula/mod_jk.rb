class ModJk < Formula
  desc "An Apache HTTP Server module (mod_jk) for connecting to backends via the AJP protocol"
  homepage "http://tomcat.apache.org/connectors-doc/"
  url "https://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.48-src.tar.gz"
  sha256 "cb1b360ba0a12b2dbec119b60f561e9f657ed75df8188e5d902534b56b908e97"

  depends_on "httpd"
  depends_on "apr-util" => :build
  depends_on "apr" => :build

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Apply patch to fix a compile error on macOS >= 11.0.
  # Requires a dependency on autoconf, automake and libtool to apply.
  patch :p0 do
    url "https://raw.githubusercontent.com/rkhmelichek/homebrew-tools/master/Patches/mod_jk/macos11.patch"
    sha256 "4d7028b28c83555248e0af2f42191373705196232d4d7ac140b02a628ebb42ac"
  end

  def install
    ENV["LIBTOOL"] = Formula["libtool"].bin

    args = %W[
      --prefix=#{prefix}
      --with-apxs=#{Formula["httpd"].opt_bin}/apxs
    ]

    cd buildpath/"native" do
      # Needed to apply the patch.
      system "./buildconf.sh"

      system "./configure", *args
      system "make"
      libexec.install "./apache-2.0/mod_jk.so"
    end
  end

  def caveats
    <<~EOS
      You must manually edit httpd.conf to include
      LoadModule mod_jk #{libexec}/mod_jk.so
    EOS
  end
end
