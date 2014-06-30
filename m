From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 30 Jun 2014 11:52:07 +0000
Subject: [PATCH net-next 0/2] Misc SCTP updates
Message-Id: <1404129129-23270-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Daniel Borkmann (2):
  net: sctp: improve timer slack calculation for transport HBs
  net: sctp: only warn in proc_sctp_do_alpha_beta if write

 include/net/sctp/sctp.h | 21 ---------------------
 net/sctp/sysctl.c       |  5 +++--
 net/sctp/transport.c    | 17 +++++++++--------
 3 files changed, 12 insertions(+), 31 deletions(-)

-- 
1.7.11.7

