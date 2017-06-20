From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 20 Jun 2017 14:39:51 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <20170620143951.GB10596@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jun 20, 2017 at 03:24:13PM +0200, Andreas Steinmetz wrote:
> [please CC me, I'm not subscribed]
> 
> It seems that if one does a getsockopt(SCTP_SOCKOPT_PEELOFF) a.k.a.
> sctp_peeloff(), even if the socket descriptor from which the
> association is to be peeled off has SOCK_CLOEXEC/SOCK_NONBLOCK set,
> the peeled off socket descriptor doesn't have so.
> 
> It would be advisable to either clone these flags or add an atomic
> version of SCTP_SOCKOPT_PEELOFF (accept4() style).
> 
> The missing SOCK_CLOEXEC requires unintentional additional locking
> which typically is prone to errors and can slow down processing.
> -- 
> Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Try this patch, and confirm that it fixes the problem please?

Thanks!
Neil


diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f16c8d9..a95e3d6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4912,7 +4912,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 		return -EINVAL;
 
 	/* Create a new socket.  */
-	err = sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP, &sock);
+	err = sock_create(sk->sk_family, sk->sk_type, IPPROTO_SCTP, &sock);
 	if (err < 0)
 		return err;
 
