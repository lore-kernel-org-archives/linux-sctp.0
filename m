From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 14 Dec 2016 13:39:13 +0000
Subject: [RFC PATCH 0/1] kernel: Add SELinux SCTP protocol support
Message-Id: <20161214133913.3005-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

This is an updated patch for SCTP support that I submitted some time
ago [1], so decided to restart and see how this one flies.

This patch has been tested on Fedora 25 with kernel 4.8.11 using
the targeted policy. It therefore does not require the
"support distinctions among all network address families" [2] kernel
patch that was submitted last week. The commit message in PATCH [1/1]
has pointers for testing this patch.

ToDo:
1) Add code to support a policy capability or utilise the
"extended_socket_class" [2] depending on how this patch progresses.
2) Produce tests for the selinux testsuite.
3) Produce refpolicy updates.

[1] http://marc.info/?l=selinux&m2227840720255&w=2
[2] http://marc.info/?l=selinux&m8103642804873&w=2

Richard Haines (1):
  kernel: Add SELinux SCTP protocol support

 Documentation/security/SELinux-sctp.txt | 508 ++++++++++++++++++++++++++++++++
 include/linux/lsm_hooks.h               |  27 ++
 include/linux/security.h                |  16 +
 net/sctp/sm_statefuns.c                 |  12 +
 net/sctp/socket.c                       |  16 +
 security/security.c                     |  18 ++
 security/selinux/Makefile               |   2 +
 security/selinux/hooks.c                | 124 +++++++-
 security/selinux/include/classmap.h     |   4 +
 security/selinux/include/sctp.h         |  50 ++++
 security/selinux/include/sctp_private.h |  39 +++
 security/selinux/netlabel.c             |   3 +
 security/selinux/sctp.c                 | 194 ++++++++++++
 13 files changed, 1002 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/security/SELinux-sctp.txt
 create mode 100644 security/selinux/include/sctp.h
 create mode 100644 security/selinux/include/sctp_private.h
 create mode 100644 security/selinux/sctp.c

-- 
2.9.3

