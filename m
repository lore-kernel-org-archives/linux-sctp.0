From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 01 May 2018 10:24:06 +0000
Subject: [PATCH lksctp-tools 0/3] add the support for sctp_sendv and sctp_recvv
Message-Id: <cover.1525170039.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

sctp_sendv and sctp_recvv provide an extensible way for an application
to communicate different snd attributes to the SCTP stack when sending
a message, and to pass up different SCTP attributes associated with a
received message to an application when receiving a message, as said
in rfc6458.

This patchset is to add the sctp_sendv and sctp_recvv functions, their
man docs and the function testing for them. These are based on linux
kernel-4.16.

Xin Long (3):
  lib: add the core functions for sctp_sendv and sctp_recvv
  func_tests: add the testing for sctp_sendv and sctp_recvv
  man: add the man docs for sctp_sendv and sctp_recvv

 man/Makefile.am                       |   2 +-
 man/sctp.7                            |   2 +
 man/sctp_bindx.3                      |   2 +
 man/sctp_connectx.3                   |   2 +
 man/sctp_getladdrs.3                  |   2 +
 man/sctp_getpaddrs.3                  |   2 +
 man/sctp_opt_info.3                   |   2 +
 man/sctp_peeloff.3                    |   2 +
 man/sctp_recvmsg.3                    |   1 +
 man/sctp_recvv.3                      |  99 +++++++++++++
 man/sctp_send.3                       |   4 +-
 man/sctp_sendmsg.3                    |   2 +
 man/sctp_sendv.3                      |  97 ++++++++++++
 src/func_tests/Makefile.am            |   5 +
 src/func_tests/test_sctp_sendvrecvv.c | 270 ++++++++++++++++++++++++++++++++++
 src/include/netinet/sctp.h            |  43 ++++++
 src/lib/Versions.map                  |   2 +
 src/lib/recvmsg.c                     |  88 +++++++++++
 src/lib/sendmsg.c                     | 161 ++++++++++++++++++++
 src/testlib/sctputil.h                |  29 ++++
 20 files changed, 815 insertions(+), 2 deletions(-)
 create mode 100644 man/sctp_recvv.3
 create mode 100644 man/sctp_sendv.3
 create mode 100644 src/func_tests/test_sctp_sendvrecvv.c

-- 
2.1.0

