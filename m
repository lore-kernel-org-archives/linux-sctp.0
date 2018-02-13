From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 13 Feb 2018 20:52:52 +0000
Subject: [PATCH V6 0/4] Add SELinux SCTP protocol support
Message-Id: <20180213205252.4447-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

These patches have been built on Fedora 27 with kernel-4.16.0-0.rc1 plus
the following userspace patches to enable testing:

1) Updates to libsepol 2.7 to support the sctp portcon statement.
   The patch is available from:
         http://arctic.selinuxproject.org/~rhaines/selinux-sctp/
         selinux-Add-support-for-the-SCTP-portcon-keyword.patch

2) Updates to the SELinux Test Suite adding SCTP tests. Please read the
   selinux-testsuite/README.sctp for details. The patch is available from:
         http://arctic.selinuxproject.org/~rhaines/selinux-sctp/
         selinux-testsuite-Add-SCTP-test-support.patch

3) Updates to lksctp-tools that show SELinux info in sctp_darn and
   sctp_test. It also contains a minor patch for test_1_to_1_connect.c
   as when CIPSO/CALIPSO configured, NetLabel returns a different error
   code for illegal addresses in test 5. The patch is available from:
         http://arctic.selinuxproject.org/~rhaines/selinux-sctp/
         lksctp-tools-Add-SELinux-support-to-sctp_test-and-sc.patch

All SCTP lksctp-tools/src/func_tests run correctly in enforcing mode.

All SCTP regression tests "./sctp-tests run" run correctly in enforcing
mode. These tests are obtained from: https://github.com/sctp/sctp-tests

The selinux-testsuite patch also adds remote tests (that need some manual
configuration). These are useful for testing CIPSO/CALIPSO over a network
with a number of categories to produce large ip option fields with various
message sizes forcing fragmentation etc..

Changes since RFC Patch:
Removed the NetLabel patch (was [RFC PATCH 4/5] netlabel: Add SCTP support)
as re-engineered. However this patchset will require the NetLabel
patch at [1] to fully run the SCTP selinux-testsuite.

V1 Changes:
PATCH 1/4
Remove unused parameter from security_sctp_assoc_request().
Reformat and update LSM-sctp.rst documentation.
PATCH 2/4
Add variables and RCU locks as requested in [2] to support IP options.
PATCH 3/4
Added security_sctp_assoc_request() hook to sctp_sf_do_unexpected_init()
and sctp_sf_do_5_2_4_dupcook().
Removed security_sctp_assoc_request() hook from sctp_sf_do_5_1C_ack() as
no longer required.
PATCH 4/4
Reformat and update SELinux-sctp.rst documentation.
Remove bindx and connectx permissions.
Rework selinux_socket_connect() and selinux_netlbl_socket_connect() to
utilise helpers for code reuse.
Add spinlock to selinux_sctp_assoc_request().
Remove unused parameter from security_sctp_assoc_request().
Use address->sa_family = AF_INET in *_bind and *_connect to ensure
correct address type.
Minor cleanups.

V2 Changes:
PATCH 4/4 - Remove spin lock from selinux_sctp_assoc_request()
PATCH 4/4 - Fix selinux_sctp_sk_clone() kbuild test robot catch [3]

V3 Changes:
PATCH 2/4 - Account for IP options length in sctp.h sctp_frag_point() by
Marcelo

V4 Changes:
PATCH 1/4 - Move specific SELinux descriptions from LSM-sctp.rst and
lsm_hooks.h to SELinux-sctp.rst in PATCH 4/4
PATCH 4/4 - Rename selinux_netlbl_sctp_socket_connect() to
selinux_netlbl_socket_connect_locked() and move description comments to
selinux_sctp_bind_connect()

V5 Change: Rework selinux_netlbl_socket_connect() and
selinux_netlbl_socket_connect_locked as requested by Paul.

V6 Changes:
Rework SCTP patches 2/4 and 3/4 as there have been major SCTP updates since
kernel 4.14.

[1] https://marc.info/?l=selinux&m1061619115945&w=2
[2] https://marc.info/?l=selinux&m0962470215797&w=2
[3] https://marc.info/?l=selinux&m1198281817779&w=2

Richard Haines (4):
  security: Add support for SCTP security hooks
  sctp: Add ip option support
  sctp: Add LSM hooks
  selinux: Add SCTP support

 Documentation/security/LSM-sctp.rst     | 175 ++++++++++++++++++++
 Documentation/security/SELinux-sctp.rst | 157 ++++++++++++++++++
 include/linux/lsm_hooks.h               |  36 ++++
 include/linux/security.h                |  25 +++
 include/net/sctp/sctp.h                 |   4 +-
 include/net/sctp/structs.h              |  12 ++
 include/uapi/linux/sctp.h               |   1 +
 net/sctp/chunk.c                        |  12 +-
 net/sctp/ipv6.c                         |  42 ++++-
 net/sctp/output.c                       |   5 +-
 net/sctp/protocol.c                     |  36 ++++
 net/sctp/sm_make_chunk.c                |  12 ++
 net/sctp/sm_statefuns.c                 |  18 ++
 net/sctp/socket.c                       |  76 ++++++++-
 security/security.c                     |  22 +++
 security/selinux/hooks.c                | 280 +++++++++++++++++++++++++++++---
 security/selinux/include/classmap.h     |   2 +-
 security/selinux/include/netlabel.h     |  21 ++-
 security/selinux/include/objsec.h       |   4 +
 security/selinux/netlabel.c             | 133 +++++++++++++--
 20 files changed, 1022 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/security/LSM-sctp.rst
 create mode 100644 Documentation/security/SELinux-sctp.rst

-- 
2.14.3

