class Sshpass < Formula
  desc "Non-interactive ssh password auth"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "https://sourceforge.net/projects/sshpass/files/sshpass/1.08/sshpass-1.08.tar.gz"
  sha256 "8bdacb8ca4ecf82c84a5effa2f75a8bf4ed9dd6f9d030f308fe11cffb3830b02"

  def install
    ENV.O2
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    system "./configure", *args
    system "make install"
  end

  def test
    system "sshpass"
  end
end
