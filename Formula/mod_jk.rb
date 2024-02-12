class ModJk < Formula
  desc "An Apache HTTP Server module (mod_jk) for connecting to backends via the AJP protocol"
  homepage "http://tomcat.apache.org/connectors-doc/"
  url "https://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.49-src.tar.gz"
  sha256 "43cb0283c92878e9d4ef110631dbd2beb6b55713c127ce043190b2b308757e9c"

  depends_on "httpd"
  depends_on "apr-util" => :build
  depends_on "apr" => :build

  def install
    ENV["LIBTOOL"] = "glibtool"
    ENV["LIBTOOLIZE"] = "glibtoolize"

    args = %W[
      --prefix=#{prefix}
      --with-apxs=#{Formula["httpd"].opt_bin}/apxs
    ]

    cd buildpath/"native" do
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
