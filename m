From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 21 May 2018 11:46:12 +0000
Subject: Re: [PATCH net] sctp: fix the issue that flags are ignored when using kernel_connect
Message-Id: <20180521114612.GB17593@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4863916c3e574b0d860725466d7d4a2f445fbe5b.1526805550.git.lucien.xin@gmail.com>
In-Reply-To: <4863916c3e574b0d860725466d7d4a2f445fbe5b.1526805550.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, mkubecek@suse.cz

On Sun, May 20, 2018 at 04:39:10PM +0800, Xin Long wrote:
> Now sctp uses inet_dgram_connect as its proto_ops .connect, and the flags
> param can't be passed into its proto .connect where this flags is really
> needed.
> 
> sctp works around it by getting flags from socket file in __sctp_connect.
> It works for connecting from userspace, as inherently the user sock has
> socket file and it passes f_flags as the flags param into the proto_ops
> .connect.
> 
> However, the sock created by sock_create_kern doesn't have a socket file,
> and it passes the flags (like O_NONBLOCK) by using the flags param in
> kernel_connect, which calls proto_ops .connect later.
> 
> So to fix it, this patch defines a new proto_ops .connect for sctp,
> sctp_inet_connect, which calls __sctp_connect() directly with this
> flags param. After this, the sctp's proto .connect can be removed.
> 
> Note that sctp_inet_connect doesn't need to do some checks that are not
> needed for sctp, which makes thing better than with inet_dgram_connect.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/sctp.h |  2 ++
>  net/sctp/ipv6.c         |  2 +-
>  net/sctp/protocol.c     |  2 +-
>  net/sctp/socket.c       | 51 +++++++++++++++++++++++++++++++++----------------
>  4 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 28b996d..35498e6 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -103,6 +103,8 @@ void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
>  /*
>   * sctp/socket.c
>   */
> +int sctp_inet_connect(struct socket *sock, struct sockaddr *uaddr,
> +		      int addr_len, int flags);
>  int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
>  int sctp_inet_listen(struct socket *sock, int backlog);
>  void sctp_write_space(struct sock *sk);
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 4224711..0cd2e76 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -1006,7 +1006,7 @@ static const struct proto_ops inet6_seqpacket_ops = {
>  	.owner		   = THIS_MODULE,
>  	.release	   = inet6_release,
>  	.bind		   = inet6_bind,
> -	.connect	   = inet_dgram_connect,
> +	.connect	   = sctp_inet_connect,
>  	.socketpair	   = sock_no_socketpair,
>  	.accept		   = inet_accept,
>  	.getname	   = sctp_getname,
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index d685f84..6bf0a99 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1012,7 +1012,7 @@ static const struct proto_ops inet_seqpacket_ops = {
>  	.owner		   = THIS_MODULE,
>  	.release	   = inet_release,	/* Needs to be wrapped... */
>  	.bind		   = inet_bind,
> -	.connect	   = inet_dgram_connect,
> +	.connect	   = sctp_inet_connect,
>  	.socketpair	   = sock_no_socketpair,
>  	.accept		   = inet_accept,
>  	.getname	   = inet_getname,	/* Semantics are different.  */
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 80835ac..ae7e7c6 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1086,7 +1086,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>   */
>  static int __sctp_connect(struct sock *sk,
>  			  struct sockaddr *kaddrs,
> -			  int addrs_size,
> +			  int addrs_size, int flags,
>  			  sctp_assoc_t *assoc_id)
>  {
>  	struct net *net = sock_net(sk);
> @@ -1104,7 +1104,6 @@ static int __sctp_connect(struct sock *sk,
>  	union sctp_addr *sa_addr = NULL;
>  	void *addr_buf;
>  	unsigned short port;
> -	unsigned int f_flags = 0;
>  
>  	sp = sctp_sk(sk);
>  	ep = sp->ep;
> @@ -1254,13 +1253,7 @@ static int __sctp_connect(struct sock *sk,
>  	sp->pf->to_sk_daddr(sa_addr, sk);
>  	sk->sk_err = 0;
>  
> -	/* in-kernel sockets don't generally have a file allocated to them
> -	 * if all they do is call sock_create_kern().
> -	 */
> -	if (sk->sk_socket->file)
> -		f_flags = sk->sk_socket->file->f_flags;
> -
> -	timeo = sock_sndtimeo(sk, f_flags & O_NONBLOCK);
> +	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
>  
>  	if (assoc_id)
>  		*assoc_id = asoc->assoc_id;
> @@ -1348,7 +1341,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  				      sctp_assoc_t *assoc_id)
>  {
>  	struct sockaddr *kaddrs;
> -	int err = 0;
> +	int err = 0, flags = 0;
>  
>  	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
>  		 __func__, sk, addrs, addrs_size);
> @@ -1367,7 +1360,13 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	if (err)
>  		goto out_free;
>  
> -	err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
> +	/* in-kernel sockets don't generally have a file allocated to them
> +	 * if all they do is call sock_create_kern().
> +	 */
> +	if (sk->sk_socket->file)
> +		flags = sk->sk_socket->file->f_flags;
> +
> +	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
>  
>  out_free:
>  	kvfree(kaddrs);
> @@ -4397,16 +4396,26 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
>   * len: the size of the address.
>   */
>  static int sctp_connect(struct sock *sk, struct sockaddr *addr,
> -			int addr_len)
> +			int addr_len, int flags)
>  {
> -	int err = 0;
> +	struct inet_sock *inet = inet_sk(sk);
>  	struct sctp_af *af;
> +	int err = 0;
>  
>  	lock_sock(sk);
>  
>  	pr_debug("%s: sk:%p, sockaddr:%p, addr_len:%d\n", __func__, sk,
>  		 addr, addr_len);
>  
> +	/* We may need to bind the socket. */
> +	if (!inet->inet_num) {
> +		if (sk->sk_prot->get_port(sk, 0)) {
> +			release_sock(sk);
> +			return -EAGAIN;
> +		}
> +		inet->inet_sport = htons(inet->inet_num);
> +	}
> +
>  	/* Validate addr_len before calling common connect/connectx routine. */
>  	af = sctp_get_af_specific(addr->sa_family);
>  	if (!af || addr_len < af->sockaddr_len) {
> @@ -4415,13 +4424,25 @@ static int sctp_connect(struct sock *sk, struct sockaddr *addr,
>  		/* Pass correct addr len to common routine (so it knows there
>  		 * is only one address being passed.
>  		 */
> -		err = __sctp_connect(sk, addr, af->sockaddr_len, NULL);
> +		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
>  	}
>  
>  	release_sock(sk);
>  	return err;
>  }
>  
> +int sctp_inet_connect(struct socket *sock, struct sockaddr *uaddr,
> +		      int addr_len, int flags)
> +{
> +	if (addr_len < sizeof(uaddr->sa_family))
> +		return -EINVAL;
> +
> +	if (uaddr->sa_family = AF_UNSPEC)
> +		return -EOPNOTSUPP;
> +
> +	return sctp_connect(sock->sk, uaddr, addr_len, flags);
> +}
> +
>  /* FIXME: Write comments. */
>  static int sctp_disconnect(struct sock *sk, int flags)
>  {
> @@ -8724,7 +8745,6 @@ struct proto sctp_prot = {
>  	.name        =	"SCTP",
>  	.owner       =	THIS_MODULE,
>  	.close       =	sctp_close,
> -	.connect     =	sctp_connect,
>  	.disconnect  =	sctp_disconnect,
>  	.accept      =	sctp_accept,
>  	.ioctl       =	sctp_ioctl,
> @@ -8767,7 +8787,6 @@ struct proto sctpv6_prot = {
>  	.name		= "SCTPv6",
>  	.owner		= THIS_MODULE,
>  	.close		= sctp_close,
> -	.connect	= sctp_connect,
>  	.disconnect	= sctp_disconnect,
>  	.accept		= sctp_accept,
>  	.ioctl		= sctp_ioctl,
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

