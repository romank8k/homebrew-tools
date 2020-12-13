class Sshpass < Formula
  desc "Non-interactive ssh password auth"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "http://sourceforge.net/projects/sshpass/files/sshpass/1.06/sshpass-1.06.tar.gz"
  sha256 "c6324fcee608b99a58f9870157dfa754837f8c48be3df0f5e2f3accf145dee60"

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
