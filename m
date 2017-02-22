From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 22 Feb 2017 17:02:46 +0000
Subject: [RFC v2 PATCH 0/2] kernel: Add SELinux SCTP protocol support
Message-Id: <20170222170246.5326-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

This patch has been tested on Fedora 25 with kernel 4.9.9 using
the targeted policy. It therefore does not require the
"support distinctions among all network address families" [1] kernel
patch.

V2 Changes:
1) All comments in [2], [3] and [4] should now be resolved.
2) After discussions with Marcelo (thanks very much for your help),
   the permissions have been simplified and support added for ASCONF
   chunk processing.
3) The SCTP SELinux code has been moved into hooks.c
4) There are support patches listed in PATCH 2/2 for the new
   sctp portcon statement and sctp tests for the selinux-testsuite.

ToDo:
1) Add code to support a policy capability or utilise the
"extended_socket_class" [1] depending on how this patch progresses.
2) Produce refpolicy updates.

[1] http://marc.info/?l=selinux&m8103642804873&w=2
[2] http://marc.info/?l=linux-sctp&m8173536525998&w=2
[3] http://marc.info/?l=linux-sctp&m8174029127754&w=2
[4] http://marc.info/?l=selinux&m8233701411363&w=2

Richard Haines (2):
  kernel: Add LSM hooks for SCTP support
  kernel: Add SELinux SCTP protocol support

 Documentation/security/LSM-sctp.txt     | 171 +++++++++++++++++++++++++
 Documentation/security/SELinux-sctp.txt | 178 ++++++++++++++++++++++++++
 include/linux/lsm_hooks.h               |  37 ++++++
 include/linux/security.h                |  33 +++++
 include/net/sctp/structs.h              |   7 ++
 net/sctp/sm_make_chunk.c                |  12 ++
 net/sctp/sm_statefuns.c                 |  20 +++
 net/sctp/socket.c                       |  42 ++++++-
 security/security.c                     |  34 +++++
 security/selinux/hooks.c                | 213 ++++++++++++++++++++++++++++++--
 security/selinux/include/classmap.h     |   3 +
 11 files changed, 741 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/security/LSM-sctp.txt
 create mode 100644 Documentation/security/SELinux-sctp.txt

-- 
2.9.3

