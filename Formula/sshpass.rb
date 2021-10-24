class Sshpass < Formula
  desc "Non-interactive ssh password auth"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "https://sourceforge.net/projects/sshpass/files/sshpass/1.08/sshpass-1.08.tar.gz"
  sha256 "03223d0fbe27bc42c08ae2995152d487bd00aa1e0350e887cc64abc5412c5daf"

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
