From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 11 May 2010 15:45:56 +0000
Subject: Re: [PATCH for net-next-2.6] sctp: fix oops when update assoc retran path
Message-Id: <1273592756-30046-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BE8FC76.40000@cn.fujitsu.com>
In-Reply-To: <4BE8FC76.40000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Here is what I am planning to commit:

sctp: fix oops when updating retransmit path with DEBUG on

commit fbdf501c9374966a56829ecca3a7f25d2b49a305
  sctp: Do no select unconfirmed transports for retransmissions

Introduced the initial falt.

commit d598b166ced20d9b9281ea3527c0e18405ddb803
  sctp: Make sure we always return valid retransmit path

Solved the problem, but forgot to change the DEBUG statement.
Thus it was still possible to dereference a NULL pointer.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/associola.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 65f9a7c..1b26878 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1323,6 +1323,8 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 
 	if (t)
 		asoc->peer.retran_path = t;
+	else
+		t = asoc->peer.retran_path;
 
 	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
 				 " %p addr: ",
-- 
1.6.0.4

