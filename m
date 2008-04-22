From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 22 Apr 2008 05:43:16 +0000
Subject: [PATCH 1/2] SCTP: Do not enable peer IPv6 address support on PF_INET
Message-Id: <480D7AF4.9060304@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If socket is create by PF_INET type, it can not used IPv6 address to 
send/recv DATA, So we can not used IPv6 address even if peer tell us it 
support IPv6 address.
This patch fix to only enabled peer IPv6 address support on PF_INET6 socket.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

--- a/net/sctp/sm_make_chunk.c	2008-04-18 09:00:59.000000000 -0400
+++ b/net/sctp/sm_make_chunk.c	2008-04-19 06:42:46.000000000 -0400
@@ -2418,7 +2418,8 @@ static int sctp_process_param(struct sct
 				break;
 
 			case SCTP_PARAM_IPV6_ADDRESS:
-				asoc->peer.ipv6_address = 1;
+				if (PF_INET6 = asoc->base.sk->sk_family)
+					asoc->peer.ipv6_address = 1;
 				break;
 
 			case SCTP_PARAM_HOST_NAME_ADDRESS:


