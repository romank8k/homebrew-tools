class ModJk < Formula
  desc "An Apache HTTP Server module (mod_jk) for connecting to backends via the AJP protocol"
  homepage "http://tomcat.apache.org/connectors-doc/"
  url "https://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.46-src.tar.gz"
  sha256 "7e1d520e1d1dacd042087ae52be7aae47a093b93cf26931827724aa8ab66cbe9"

  depends_on "httpd"
  depends_on "apr-util" => :build
  depends_on "apr" => :build

  def install
    ENV.O2
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
