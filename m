From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 16 Oct 2013 02:01:28 +0000
Subject: [PATCH v4 net 0/3] sctp: Use software checksum under certain
Message-Id: <1381888891-31186-1-git-send-email-vyasevich@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, fan.du@windriver.com, Vlad Yasevich <vyasevich@gmail.com>

There are some cards that support SCTP checksum offloading.  When using
these cards with IPSec or forcing IP fragmentation of SCTP traffic,
the checksum is computed incorrectly due to the fact that xfrm and IP/IPv6
fragmentation code do not know that this is SCTP traffic and do not
know that checksum has to be computed differently.

To fix this, we let SCTP detect these conditions and perform software
checksum calculation.

Fan Du (1):
  sctp: Use software crc32 checksum when xfrm transform will happen.

Vlad Yasevich (2):
  net: dst: provide accessor function to dst->xfrm
  sctp: Perform software checksum if packet has to be fragmented.

 include/net/dst.h | 12 ++++++++++++
 net/sctp/output.c |  3 ++-
 2 files changed, 14 insertions(+), 1 deletion(-)

-- 
1.8.3.1

