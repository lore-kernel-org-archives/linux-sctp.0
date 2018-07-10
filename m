From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Jul 2018 11:07:02 +0000
Subject: [PATCH lksctp-tools 0/2] build: add more kernel features detecting when building
Message-Id: <cover.1531220086.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patchset is to add two more kernel features detecting after
Marcelo's fixes "build: detect kernel features when building".

Xin Long (2):
  build: add define HAVE_SCTP_AUTH_NO_AUTH
  build: add two defines for Peer Address Parameters extensions on
    sctp_paddrparams

 configure.ac                        | 10 ++++++++++
 src/func_tests/test_1_to_1_events.c | 11 +++++++++++
 src/include/netinet/sctp.h.in       |  3 +++
 3 files changed, 24 insertions(+)

-- 
2.1.0

