From: Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
Date: Wed, 27 Jan 2010 14:12:59 +0000
Subject: [PATCH] sctp: IPsec rules are ineffective with ipv6
Message-Id: <4B6049EB.8030803@dev.6wind.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------060201080905000905020706"
List-Id: <linux-sctp.vger.kernel.org>
To: netdev <netdev@vger.kernel.org>, Vlad Yasevich <vladislav.yasevich@hp.com>, linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------060201080905000905020706
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

xfrm_lookup() is missing in sctp_v6_xmit(), add it.

Signed-off-by: Junwei Zhang <junwei.zhang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

--------------060201080905000905020706
Content-Type: text/x-diff;
 name="x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.diff"

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index cc50fbe..f24e23c 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -197,8 +197,10 @@ out:
 static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 {
 	struct sock *sk = skb->sk;
+	struct dst_entry *dst = skb_dst(skb);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct flowi fl;
+	int err;
 
 	memset(&fl, 0, sizeof(fl));
 
@@ -231,6 +233,9 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 	if (!(transport->param_flags & SPP_PMTUD_ENABLE))
 		skb->local_df = 1;
 
+	if ((err = xfrm_lookup(sock_net(sk), &dst, &fl, sk, 0)) < 0)
+		return err;
+
 	return ip6_xmit(sk, skb, &fl, np->opt, 0);
 }
 

--------------060201080905000905020706--
