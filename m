From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 16 Sep 2013 10:36:02 +0000
Subject: [PATCH net] net: sctp: rfc4443: do not report ICMP redirects to user space
Message-Id: <1379327762-4638-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, hannes@stressinduktion.org

Adapt the same behaviour for SCTP as present in TCP for ICMP redirect
messages. For IPv6, RFC4443, section 2.4. says:

  ...
  (e) An ICMPv6 error message MUST NOT be originated as a result of
      receiving the following:
  ...
       (e.2) An ICMPv6 redirect message [IPv6-DISC].
  ...

Therefore, do not report an error to user space, just invoke dst's redirect
callback and leave, same for IPv4 as done in TCP as well. The implication
w/o having this patch could be that the reception of such packets would
generate a poll notification and in worst case it could even tear down the
whole connection. Therefore, stop updating sk_err on redirects.

Reported-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/input.c | 3 +--
 net/sctp/ipv6.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 5f20686..98b69bb 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -634,8 +634,7 @@ void sctp_v4_err(struct sk_buff *skb, __u32 info)
 		break;
 	case ICMP_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		err = 0;
-		break;
+		/* Fall through to out_unlock. */
 	default:
 		goto out_unlock;
 	}
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 4f52e2c..e7b2d4f 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -183,7 +183,7 @@ static void sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		break;
 	case NDISC_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		break;
+		goto out_unlock;
 	default:
 		break;
 	}
-- 
1.7.11.7

