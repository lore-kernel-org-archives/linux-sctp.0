From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Jun 2017 15:41:47 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <20170620154147.GA18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Tue, Jun 20, 2017 at 10:39:51AM -0400, Neil Horman wrote:
> On Tue, Jun 20, 2017 at 03:24:13PM +0200, Andreas Steinmetz wrote:
> > [please CC me, I'm not subscribed]
> > 
> > It seems that if one does a getsockopt(SCTP_SOCKOPT_PEELOFF) a.k.a.
> > sctp_peeloff(), even if the socket descriptor from which the
> > association is to be peeled off has SOCK_CLOEXEC/SOCK_NONBLOCK set,
> > the peeled off socket descriptor doesn't have so.
> > 
> > It would be advisable to either clone these flags or add an atomic
> > version of SCTP_SOCKOPT_PEELOFF (accept4() style).
> > 
> > The missing SOCK_CLOEXEC requires unintentional additional locking
> > which typically is prone to errors and can slow down processing.
> > -- 
> > Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> Try this patch, and confirm that it fixes the problem please?
> 
> Thanks!
> Neil
> 
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index f16c8d9..a95e3d6 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4912,7 +4912,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
>  		return -EINVAL;
>  
>  	/* Create a new socket.  */
> -	err = sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP, &sock);
> +	err = sock_create(sk->sk_family, sk->sk_type, IPPROTO_SCTP, &sock);

I don't think this will work. Syscall socket() filters out these
flags and handle them separetly after calling sock_create() with just
the type, so I don't think this information is preserved in there.

Interesting to note that according to man page dup() syscall also
doesn't duplicate these flags. One has to use dup3() instead in order to
be able to specify them.

Maybe by extending sctp_peeloff_arg_t to have a flags attribute in
there, we can allow the application to specify it and feed into
get_unused_fd_flags() call in sctp_getsockopt_peeloff() instead, or even
just overload the sd, which is currently an output-only value, to
contain flags as the patch below. (We probably should add some sanity
checking in there, though)

Thanks,
Marcelo

---8<---

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e1fabf67d4ad..50021a925b16 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4950,8 +4950,10 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
 	if (retval < 0)
 		goto out;
 
-	/* Map the socket to an unused fd that can be returned to the user.  */
-	retval = get_unused_fd_flags(0);
+	/* Map the socket to an unused fd that can be returned to the user.
+	 * peeloff.sd[in] is used to transport flags
+	 */
+	retval = get_unused_fd_flags(peeloff.sd);
 	if (retval < 0) {
 		sock_release(newsock);
 		goto out;
