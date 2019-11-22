From: Sasha Levin <sashal@kernel.org>
Date: Fri, 22 Nov 2019 06:01:22 +0000
Subject: [PATCH AUTOSEL 4.9 84/91] sctp: don't compare hb_timer expire date before starting it
Message-Id: <20191122060129.4239-83-sashal@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Maciej Kwiecien <maciej.kwiecien@nokia.com>, Marcin Stojek <marcin.stojek@nokia.com>, Alexander Sverdlin <alexander.sverdlin@nokia.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Maciej Kwiecien <maciej.kwiecien@nokia.com>

[ Upstream commit d1f20c03f48102e52eb98b8651d129b83134cae4 ]

hb_timer might not start at all for a particular transport because its
start is conditional. In a result a node is not sending heartbeats.

Function sctp_transport_reset_hb_timer has two roles:
    - initial start of hb_timer for a given transport,
    - update expire date of hb_timer for a given transport.
The function is optimized to update timer's expire only if it is before
a new calculated one but this comparison is invalid for a timer which
has not yet started. Such a timer has expire = 0 and if a new expire
value is bigger than (MAX_JIFFIES / 2 + 2) then "time_before" macro will
fail and timer will not start resulting in no heartbeat packets send by
the node.

This was found when association was initialized within first 5 mins
after system boot due to jiffies init value which is near to MAX_JIFFIES.

Test kernel version: 4.9.154 (ARCH=arm)
hb_timer.expire = 0;                //initialized, not started timer
new_expire = MAX_JIFFIES / 2 + 2;   //or more
time_before(hb_timer.expire, new_expire) = false

Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
Reported-by: Marcin Stojek <marcin.stojek@nokia.com>
Tested-by: Marcin Stojek <marcin.stojek@nokia.com>
Signed-off-by: Maciej Kwiecien <maciej.kwiecien@nokia.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 03d71cd97ec08..5c78942550e97 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -205,7 +205,8 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if (time_before(transport->hb_timer.expires, expires) &&
+	if ((time_before(transport->hb_timer.expires, expires) ||
+	     !timer_pending(&transport->hb_timer)) &&
 	    !mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
-- 
2.20.1
