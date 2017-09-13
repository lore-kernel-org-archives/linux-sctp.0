From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 13 Sep 2017 23:00:54 +0000
Subject: [PATCH v2 net] sctp: potential read out of bounds in sctp_ulpevent_type_enabled()
Message-Id: <20170913230054.fmtidvfi2swvy2mm@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170913.092522.934509429497822082.davem@davemloft.net>
In-Reply-To: <20170913.092522.934509429497822082.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

This code causes a static checker warning because Smatch doesn't trust
anything that comes from skb->data.  I've reviewed this code and I do
think skb->data can be controlled by the user here.

The sctp_event_subscribe struct has 13 __u8 fields and we want to see
if ours is non-zero.  sn_type can be any value in the 0-USHRT_MAX range.
We're subtracting SCTP_SN_TYPE_BASE which is 1 << 15 so we could read
either before the start of the struct or after the end.

This is a very old bug and it's surprising that it would go undetected
for so long but my theory is that it just doesn't have a big impact so
it would be hard to notice.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  Use reverse-christmas-tree local variable ordering.

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 1060494ac230..b8c86ec1a8f5 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -153,8 +153,12 @@ __u16 sctp_ulpevent_get_notification_type(const struct sctp_ulpevent *event);
 static inline int sctp_ulpevent_type_enabled(__u16 sn_type,
 					     struct sctp_event_subscribe *mask)
 {
+	int offset = sn_type - SCTP_SN_TYPE_BASE;
 	char *amask = (char *) mask;
-	return amask[sn_type - SCTP_SN_TYPE_BASE];
+
+	if (offset >= sizeof(struct sctp_event_subscribe))
+		return 0;
+	return amask[offset];
 }
 
 /* Given an event subscription, is this event enabled? */
