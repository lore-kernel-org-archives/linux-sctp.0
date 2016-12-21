From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 21 Dec 2016 16:09:01 +0000
Subject: Re: [RFC PATCH 1/1] kernel: Add SELinux SCTP protocol support
Message-Id: <20161221160901.GH4731@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20161214133959.3078-1-richard_c_haines@btinternet.com>
In-Reply-To: <20161214133959.3078-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Haines <richard_c_haines@btinternet.com>
Cc: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

On Wed, Dec 14, 2016 at 01:39:59PM +0000, Richard Haines wrote:
> +SCTP Socket Option Permissions
> +===============> +The permissions consist of: "bindx_add" "bindx_rem" "connectx" "set_addr" and
> +"set_params" that are validated on setsockopt(2) calls, and "peeloff" that is
> +validated on getsockopt(2) calls.
> +
> +SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> +                         associated after (optionally) calling bind(2)
> +                         if given the "bind_add" permission.
> +
> +SCTP_SOCKOPT_CONNECTX  - Allows the allocation of multiple
> +                         addresses for reaching a multi-homed peer
> +                         if given the "connectx" permission.
> +
> +  Together they are used to form SCTP associations with information being
> +  passed over the link to inform the peer of any changes. As these two options
> +  can support multiple addresses, each address is checked via
> +  selinux_socket_bind() or selinux_socket_connect() to determine whether they
> +  have the correct permissions:
> +    bindx_add: bind, name_bind, node_bind + node SID + port SID via the
> +               (portcon sctp port ctx) policy statement.
> +    connectx:  connect, name_connect + port SID via the
> +               (portcon sctp port ctx) policy statement.
> +
> +SCTP_SOCKOPT_BINDX_REM - Allows additional bind addresses to be removed
> +                         if given the "bind_rem" permission.
> +
> +SCTP_PEER_ADDR_PARAMS - Alter heartbeats and address max retransmissions.
> +SCTP_PEER_ADDR_THLDS  - Alter the thresholds.
> +SCTP_ASSOCINFO        - Alter association and endpoint parameters.
> + These require the "set_params" permission.
> +
> +SCTP_PRIMARY_ADDR          - Set local primary address.
> +SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as association primary.
> + These require the "set_addr" permission.
> +
> +SCTP_SOCKOPT_PEELOFF - Branch off an association into a new socket that
> +will be a one-to-one style socket. As SELinux already handles the creation
> +of new sockets, only the "peeloff" permission is checked.

...

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 7b0e059..ff4f1a8 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1009,6 +1009,12 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	/* Do the work. */
>  	switch (op) {
>  	case SCTP_BINDX_ADD_ADDR:
> +		/* Allow security module to validate bindx addresses. */
> +		err = security_sk_setsockopt(sk, SOL_SCTP,
> +					     SCTP_SOCKOPT_BINDX_ADD,
> +					     (char *)kaddrs, addrs_size);

Here, kaddrs is about the addresses that we are going to bind to.

> +		if (err)
> +			goto out;
>  		err = sctp_bindx_add(sk, kaddrs, addrcnt);
>  		if (err)
>  			goto out;
> @@ -1329,9 +1335,17 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
>  		err = -EFAULT;
>  	} else {
> +		/* Allow security module to validate connectx addresses. */
> +		err = security_sk_setsockopt(sk, SOL_SCTP,
> +					     SCTP_SOCKOPT_CONNECTX,
> +					    (char *)kaddrs, addrs_size);

Here, kaddrs is about the remote addresses that we are connecting to.
Not sure how feasible this is for SELinux, to maintain a list of allowed
peers. But this being right, I think we are missing the hooks at ASCONF
handling side.

One SCTP peer can start/stop binding to another IP in runtime using
ASCONF chunks. So considering that peer A here validated that it can
associate to be peer B, if B is using ASCONF to inform A that it's now
also binding on address X, A should validate so before ACKing it.

This validation would be around sctp_process_asconf_param. Not sure you
can hook it on selinux_sctp_setsockopt too as it would be similar to the
validation done for CONNECT.

Richard, the other point we talked offline, was for validating that peer
A can actually request to add address X, that would be ok, yes.

Thanks,
  Marcelo

> +		if (err)
> +			goto out_free;
> +
>  		err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
>  	}
>  
> +out_free:
>  	kfree(kaddrs);
>  
>  	return err;



> +int selinux_sctp_setsockopt(struct sock *sk, int level, int optname,
> +					    char *optval, int optlen)
> +{
> +	int err, addrlen;
> +	void *addr_buf;
> +	struct sockaddr *address;
> +	struct socket *sock;
> +	int walk_size = 0;
> +
> +	if (level != SOL_SCTP || level != IPPROTO_SCTP)
> +		return 0;
> +
> +	switch (optname) {
> +	case SCTP_SOCKOPT_BINDX_ADD:
> +	case SCTP_SOCKOPT_CONNECTX:
> +		/* Note that for SCTP_SOCKOPT_BINDX_ADD and
> +		 * SCTP_SOCKOPT_CONNECTX the sctp kernel code has already
> +		 * copied the optval to kernel space. See net/sctp/socket.c
> +		 * security_sk_setsockopt() calls.
> +		 */
> +		err = sock_has_perm(current, sk,
> +			    (optname = SCTP_SOCKOPT_BINDX_ADD ?
> +			     SCTP_SOCKET__BINDX_ADD :
> +			     SCTP_SOCKET__CONNECTX));
> +		if (err)
> +			return err;
> +
> +		sock = sk->sk_socket;
> +		addr_buf = optval;
> +		/* Process list - may contain IPv4 or IPv6 addr's */
> +		while (walk_size < optlen) {
> +			address = addr_buf;
> +
> +			switch (address->sa_family) {
> +			case PF_INET:
> +				addrlen = sizeof(struct sockaddr_in);
> +				break;
> +			case PF_INET6:
> +				addrlen = sizeof(struct sockaddr_in6);
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +
> +			err = -EINVAL;
> +			if (optname = SCTP_SOCKOPT_BINDX_ADD) {
> +				err = selinux_socket_bind(sock,
> +					    address, addrlen);
> +			} else if (optname = SCTP_SOCKOPT_CONNECTX) {
> +				err = selinux_socket_connect(sock,
> +					    address, addrlen);
> +			}
> +			if (err)
> +				return err;
> +
> +			addr_buf += addrlen;
> +			walk_size += addrlen;
> +		}
> +		break;
> +
> +	case SCTP_SOCKOPT_BINDX_REM:
> +		/* The addresses have been checked as they were
> +		 * added, so just see if allowed to be removed.
> +		 */
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__BINDX_REM);
> +		if (err)
> +			return err;
> +		break;
> +
> +	/* Set heartbeats and address max retransmissions. */
> +	case SCTP_PEER_ADDR_PARAMS:
> +	/* Set thresholds. */
> +	case SCTP_PEER_ADDR_THLDS:
> +	/* Set association and endpoint parameters */
> +	case SCTP_ASSOCINFO:
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__SET_PARAMS);
> +		if (err)
> +			return err;
> +		break;
> +
> +	/* Set local primary address. */
> +	case SCTP_PRIMARY_ADDR:
> +	/* Request peer sets address as association primary. */
> +	case SCTP_SET_PEER_PRIMARY_ADDR:
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__SET_ADDR);
> +		if (err)
> +			return err;
> +		break;
> +	}
> +
> +	return 0;
> +}



