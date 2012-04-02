From: Julia Lawall <julia.lawall@lip6.fr>
Date: Mon, 02 Apr 2012 21:01:15 +0000
Subject: Re: question about net/sctp/socket.c
Message-Id: <alpine.DEB.2.02.1204022257371.2054@localhost6.localdomain6>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.DEB.2.02.1204021521460.1959@hadrien>
In-Reply-To: <alpine.DEB.2.02.1204021521460.1959@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Below is an attempt to inline the code.  Is it a problem that the file 
descriptor is copied to the user level before the socket is fully 
initialized?  And does something need to be done at the end of the 
function in the case of failure of put_user and copy_to_user to freethe 
file descriptor?  And finally, perhaps the duplication of code is a bit 
unfortunate.

julia



int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
{
 	struct sctp_association *asoc = sctp_id2assoc(sk, id);
 	struct socket *sock;
 	struct sctp_af *af;
 	int err = 0;

 	if (!asoc)
 		return -EINVAL;

 	/* An association cannot be branched off from an already peeled-off
 	 * socket, nor is this supported for tcp style sockets.
 	 */
 	if (!sctp_style(sk, UDP))
 		return -EINVAL;

 	/* Create a new socket.  */
 	err = sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP, &sock);
 	if (err < 0)
 		return err;

 	sctp_copy_sock(sock->sk, sk, asoc);

 	/* Make peeled-off sockets more like 1-1 accepted sockets.
 	 * Set the daddr and initialize id to something more random
 	 */
 	af = sctp_get_af_specific(asoc->peer.primary_addr.sa.sa_family);
 	af->to_sk_daddr(&asoc->peer.primary_addr, sk);

 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
 	sctp_sock_migrate(sk, sock->sk, asoc, SCTP_SOCKET_UDP_HIGH_BANDWIDTH);

 	*sockp = sock;

 	return err;
}
EXPORT_SYMBOL(sctp_do_peeloff);

static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
{
 	struct sctp_association *asoc;
 	sctp_peeloff_arg_t peeloff;
 	struct socket *newsock;
 	int retval = 0;

 	if (len < sizeof(sctp_peeloff_arg_t))
 		return -EINVAL;
 	len = sizeof(sctp_peeloff_arg_t);
 	if (copy_from_user(&peeloff, optval, len))
 		return -EFAULT;

 	asoc = sctp_id2assoc(sk, peeloff.associd);

 	if (!asoc)
 		return -EINVAL;

 	/* An association cannot be branched off from an already peeled-off
 	 * socket, nor is this supported for tcp style sockets.
 	 */
 	if (!sctp_style(sk, UDP))
 		return -EINVAL;

 	/* Create a new socket.  */
 	err = sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP,
 			  &newsock);
 	if (err < 0)
 		return err;

 	/* Map the socket to an unused fd that can be returned to the user.  */
 	retval = sock_map_fd(newsock, 0);
 	if (retval < 0)
 		goto out;

 	SCTP_DEBUG_PRINTK("%s: sk: %p newsk: %p sd: %d\n",
 			  __func__, sk, newsock->sk, retval);

 	/* Return the fd mapped to the new socket.  */
 	peeloff.sd = retval;
 	if (put_user(len, optlen)) {
 		retval = -EFAULT;
 		goto out;
 	}
 	if (copy_to_user(optval, &peeloff, len)) {
 		retval = -EFAULT;
 		goto out;
 	}

 	sctp_copy_sock(newsock->sk, sk, asoc);

 	/* Make peeled-off sockets more like 1-1 accepted sockets.
 	 * Set the daddr and initialize id to something more random
 	 */
 	af = sctp_get_af_specific(asoc->peer.primary_addr.sa.sa_family);
 	af->to_sk_daddr(&asoc->peer.primary_addr, sk);

 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
 	sctp_sock_migrate(sk, newsock->sk, asoc,
 			  SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
 	return 0;

out:
 	sock_release(newsock);
 	return retval;
}
