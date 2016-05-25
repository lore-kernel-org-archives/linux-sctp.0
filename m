From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 May 2016 19:09:23 +0000
Subject: [PATCH net] sctp: fix double EPs display in sctp_diag
Message-Id: <738ddd5de8d4c5fb8a99cee15de3305215e04962.1464203363.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, phil@nwl.cc

We have this situation: that EP hash table, contains only the EPs
that are listening, while the transports one, has the opposite.
We have to traverse both to dump all.

But when we traverse the transports one we will also get EPs that are
in the EP hash if they are listening. In this case, the EP is dumped
twice.

We will fix it by checking if the endpoint that is in the endpoint
hash table contains any ep->asoc in there, as it means we will also
find it via transport hash, and thus we can/should skip it, depending
on the filters used, like 'ss -l'.

Still, we should NOT skip it if the user is listing only listening
endpoints, because then we are not traversing the transport hash.
so we have to check idiag_states there also.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sctp_diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index 8e3e769..1ce724b 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -356,6 +356,9 @@ static int sctp_ep_dump(struct sctp_endpoint *ep, void *p)
 	if (cb->args[4] < cb->args[1])
 		goto next;
 
+	if ((r->idiag_states & ~TCPF_LISTEN) && !list_empty(&ep->asocs))
+		goto next;
+
 	if (r->sdiag_family != AF_UNSPEC &&
 	    sk->sk_family != r->sdiag_family)
 		goto next;
-- 
2.1.0

