From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 11 Jun 2014 16:19:27 +0000
Subject: [PATCH v3 net-next 0/5] SCTP update
Message-Id: <1402503572-32237-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

This set contains transport path selection improvements in
SCTP. Please see individual patches for details.

Thanks!

v2->v3:
 - Reworded commit message in patch 4, thanks Vlad!
v1->v2:
 - Fixed a typo in a comment in patch 1, thanks Florian Westphal
   for pointing this out, rest stays as is.

Daniel Borkmann (5):
  ktime: add ktime_after and ktime_before helper
  net: sctp: refactor active path selection
  net: sctp: migrate most recently used transport to ktime
  net: sctp: improve sctp_select_active_and_retran_path selection
  net: sctp: fix incorrect type in gfp initializer

 include/linux/ktime.h      |  24 +++++++
 include/net/sctp/structs.h |   6 +-
 net/sctp/associola.c       | 168 ++++++++++++++++++++++++++++-----------------
 net/sctp/endpointola.c     |   2 +-
 net/sctp/sm_make_chunk.c   |   2 +-
 net/sctp/transport.c       |   2 +-
 6 files changed, 136 insertions(+), 68 deletions(-)

-- 
1.7.11.7

