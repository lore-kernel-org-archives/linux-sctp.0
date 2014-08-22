From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 22 Aug 2014 11:03:28 +0000
Subject: [PATCH net 0/2] SCTP fix
Message-Id: <1408705410-28558-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Daniel Borkmann (2):
  net: sctp: spare unnecessary comparison in sctp_trans_elect_best
  net: sctp: fix suboptimal edge-case on non-active active/retrans path selection

 net/sctp/associola.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

-- 
1.7.11.7

