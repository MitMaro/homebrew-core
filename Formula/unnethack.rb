class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://unnethack.wordpress.com/"
  url "https://github.com/UnNetHack/UnNetHack/archive/5.3.2.tar.gz"
  sha256 "a32a2c0e758eb91842033d53d43f718f3bc719a346e993d9b23bac06f0ac9004"
  head "https://github.com/UnNetHack/UnNetHack.git"

  bottle do
    sha256 "2bc88eb355efec5f772e5e555b428290a014e4f6e84e0945d88ce867060af66b" => :catalina
    sha256 "c95ffced18c9be00207e55c4d592f477cd5975fd04412115de66629d74e66088" => :mojave
    sha256 "4648259b51fa627ee3ad0ef01b5040e573741f9528385d8c04d8b6354ec745c8" => :high_sierra
    sha256 "4ccafeafee0cd1e9cc7705ee312101229748100ea32b5cb1c7c63b29ed1d7742" => :sierra
  end

  # directory for temporary level data of running games
  skip_clean "var/unnethack/level"

  def install
    # directory for version specific files that shouldn't be deleted when
    # upgrading/uninstalling
    version_specific_directory = "#{var}/unnethack/#{version}"

    args = [
      "--prefix=#{prefix}",
      "--with-owner=#{`id -un`}",
      "--with-group=admin",
      # common xlogfile for all versions
      "--enable-xlogfile=#{var}/unnethack/xlogfile",
      "--with-bonesdir=#{version_specific_directory}/bones",
      "--with-savesdir=#{version_specific_directory}/saves",
      "--enable-wizmode=#{`id -un`}",
    ]

    system "./configure", *args
    ENV.deparallelize # Race condition in make

    # disable the `chgrp` calls
    system "make", "install", "CHGRP=#"
  end
end
