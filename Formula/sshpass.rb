class Sshpass < Formula
  desc "Non-interactive ssh password auth"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "https://sourceforge.net/projects/sshpass/files/sshpass/1.10/sshpass-1.10.tar.gz"
  sha256 "ad1106c203cbb56185ca3bad8c6ccafca3b4064696194da879f81c8d7bdfeeda"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    system "./configure", *args
    system "make install"
  end

  def test
    system "sshpass"
  end
end
