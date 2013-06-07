From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 07 Jun 2013 08:35:05 +0000
Subject: [PATCH net-next 2/3] net: sctp: sctp_association_init: hold refs in reverse order
Message-Id: <1370594106-25745-3-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1370594106-25745-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1370594106-25745-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

In case we need to bail out for whatever reason during assoc
init, we call sctp_endpoint_put() and then sock_put(), however,
we've hold both refs in reverse order, so first sctp_endpoint_hold()
and then sock_hold(). Reverse this, so that we have sock_hold()
with sctp_endpoint_hold() first and then in error case
sctp_endpoint_put() and then sock_put(). Actually shouldn't
matter much since we just increase an atomic, but that way, it's
more clean.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/associola.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 91cfd8f..04795fb 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,11 +86,10 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 
 	/* Discarding const is appropriate here.  */
 	asoc->ep = (struct sctp_endpoint *)ep;
-	sctp_endpoint_hold(asoc->ep);
-
-	/* Hold the sock.  */
 	asoc->base.sk = (struct sock *)sk;
+
 	sock_hold(asoc->base.sk);
+	sctp_endpoint_hold(asoc->ep);
 
 	/* Initialize the common base substructure.  */
 	asoc->base.type = SCTP_EP_TYPE_ASSOCIATION;
-- 
1.7.11.7

