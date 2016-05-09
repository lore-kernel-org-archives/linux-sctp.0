From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 09 May 2016 20:53:40 +0000
Subject: New lksctp-tools release: 1.0.17
Message-Id: <20160509205340.GA13980@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I'd like to announce the new release, 1.0.17, mostly composed of small
bug fixes and build-time improvements from Yegor Yefremov:

Gustavo Zacarias (1):
      Build: add option to disable tests build

Marcelo Ricardo Leitner (8):
      sctp_test: fix hostname resolution
      man: remove sysctl listing from sctp.7
      libsctputil: fix str fmt for the argument
      checksctp: fix trivial warnings
      sctp_test: honor listen backlog
      Merge pull request #1 from gustavoz/master
      Add tags to .gitignore
      Release lksctp-tools-1.0.17

Michele Baldessari (3):
      Fix recieved->received typos
      Fix usage help for sctp_test
      Fix mailing list address

Simon Xu (1):
      test_1_to_1_accept_close: also expect EACCES when accept on an established socket

Wang Weidong (1):
      lksctp-tools: make bind_test can do while disable IPV6

Yegor Yefremov (4):
      libsctp: add pkg-config support
      Add .gitignore files
      autoconf: add m4 folder
      Fix musl build

Thank you to all those who contributed to this release.

  Marcelo

