From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 09 Oct 2014 20:55:30 +0000
Subject: [PATCH net 0/3] SCTP fixes
Message-Id: <1412888133-833-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Here are some SCTP fixes.

[ Note, immediate workaround would be to disable ASCONF (it
  is sysctl disabled by default). It is actually only used
  together with chunk authentication. ]

Thanks!

Daniel Borkmann (3):
  net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks
  net: sctp: fix panic on duplicate ASCONF chunks
  net: sctp: fix remote memory pressure from excessive queueing

 include/net/sctp/sctp.h  |  5 +++
 include/net/sctp/sm.h    |  6 +--
 net/sctp/associola.c     |  2 +
 net/sctp/inqueue.c       | 33 ++++------------
 net/sctp/sm_make_chunk.c | 99 +++++++++++++++++++++++++++---------------------
 net/sctp/sm_statefuns.c  | 21 +++-------
 6 files changed, 77 insertions(+), 89 deletions(-)

-- 
1.7.11.7

