From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 22 Apr 2011 08:41:02 +0000
Subject: Re: Lksctp and receiving ancilliary data from IP
Message-Id: <4DB13F1E.1030008@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <79C4240C13B4C84B910850B96B1B4312026FFF28@DEMUEXC035.nsn-intra.net>
In-Reply-To: <79C4240C13B4C84B910850B96B1B4312026FFF28@DEMUEXC035.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



> Hi,
>
> Recently I wanted to write an application which receives DSCP value from kernel through recvmsg's ancilliary control data feature, but I had to realize that despite I've used setsockopt with IP_RECVTOS parameter to achieve this, the buffer contained only SCTP level control data. When I looked into the code, I found that in net/sctp/socket.c::sctp_recvmsg() the necessary lines are commented out:
>
> 	if (sp->subscribe.sctp_data_io_event)
> 		sctp_ulpevent_read_sndrcvinfo(event, msg);
> #if 0
> 	/* FIXME: we should be calling IP/IPv6 layers.  */
> 	if (sk->sk_protinfo.af_inet.cmsg_flags)
> 		ip_cmsg_recv(msg, skb);
> #endif

those code do not run any more, and maybe only run for IPv4 before
it be removed.

> I've tried to search about the reasons, but I couldn't find any answers about why is this left like this. Is there any special reason? At first look this code snippet looks working, but I suppose it's not an accident why it is not included in the official code.

You can try the following un-test patch, only for IPv4.

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 5c9bada..7dcbca8 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -631,6 +631,8 @@ struct sctp_pf {
 	struct sock *(*create_accept_sk) (struct sock *sk,
 					  struct sctp_association *asoc);
 	void (*addr_v4map) (struct sctp_sock *, union sctp_addr *);
+	void (*cmsg_recv_ctl)(struct sock *sk, struct msghdr *msg,
+			      struct sk_buff *skb);
 	struct sctp_af *af;
 };
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 865ce7b..01bde2d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -893,6 +893,12 @@ static int sctp_inet6_supported_addrs(const struct sctp_sock *opt,
 	return 1;
 }
 
+static void sctp_v6_cmsg_recv_ctl(struct sock *sk, struct msghdr *msg,
+				  struct sk_buff *skb)
+{
+	// skip
+}
+
 static const struct proto_ops inet6_seqpacket_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
@@ -988,6 +994,7 @@ static struct sctp_pf sctp_pf_inet6 = {
 	.supported_addrs = sctp_inet6_supported_addrs,
 	.create_accept_sk = sctp_v6_create_accept_sk,
 	.addr_v4map    = sctp_v6_addr_v4map,
+	.cmsg_recv_ctl = sctp_v6_cmsg_recv_ctl,
 	.af            = &sctp_af_inet6,
 };
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d5bf91d..64ec7ed 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -846,6 +846,15 @@ static int sctp_inet_supported_addrs(const struct sctp_sock *opt,
 	return 1;
 }
 
+static void sctp_v4_cmsg_recv_ctl(struct sock *sk, struct msghdr *msg,
+				  struct sk_buff *skb)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	if (inet->cmsg_flags)
+		ip_cmsg_recv(msg, skb);
+}
+
 /* Wrapper routine that calls the ip transmit routine. */
 static inline int sctp_v4_xmit(struct sk_buff *skb,
 			       struct sctp_transport *transport)
@@ -876,6 +885,7 @@ static struct sctp_pf sctp_pf_inet = {
 	.supported_addrs = sctp_inet_supported_addrs,
 	.create_accept_sk = sctp_v4_create_accept_sk,
 	.addr_v4map	= sctp_v4_addr_v4map,
+	.cmsg_recv_ctl = sctp_v4_cmsg_recv_ctl,
 	.af            = &sctp_af_inet
 };
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f694ee1..c8bb106 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1997,11 +1997,8 @@ SCTP_STATIC int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,
 	/* Check if we allow SCTP_SNDRCVINFO. */
 	if (sp->subscribe.sctp_data_io_event)
 		sctp_ulpevent_read_sndrcvinfo(event, msg);
-#if 0
-	/* FIXME: we should be calling IP/IPv6 layers.  */
-	if (sk->sk_protinfo.af_inet.cmsg_flags)
-		ip_cmsg_recv(msg, skb);
-#endif
+
+	sp->pf->cmsg_recv_ctl(sk, msg, skb);
 
 	err = copied;
 


