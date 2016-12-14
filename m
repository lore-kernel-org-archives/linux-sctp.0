From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Wed, 14 Dec 2016 18:34:19 +0000
Subject: Re: [RFC PATCH 1/1] kernel: Add SELinux SCTP protocol support
Message-Id: <1481740459.9065.35.camel@tycho.nsa.gov>
List-Id: <linux-sctp.vger.kernel.org>
References: <20161214133959.3078-1-richard_c_haines@btinternet.com>
In-Reply-To: <20161214133959.3078-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Richard Haines <richard_c_haines@btinternet.com>, selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

On Wed, 2016-12-14 at 13:39 +0000, Richard Haines wrote:
> Add SELinux support for the SCTP protocol. The SELinux-sctp.txt
> document
> describes how the patch has been implemented with an example policy
> and
> tests using lkstcp-tools.
> 
> Patches to assist the testing of this kernel patch are:
> 1) Support the new SCTP portcon statement used in the test CIL policy
> module shown in Documentation/security/SELinux-sctp.txt can be found
> at [1].
> 2) Add SELinux support for the http://lksctp.sourceforge.net/ apps
> sctp_test.c and sctp_darn.c can be found at [2].
> 
> Built and tested on Fedora 25 with linux-4.8 kernel.
> 
> [1] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-Ad
> d-support-for-the-SCTP-portcon-keyword.patch
> [2] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/lksctp-too
> ls-Add-SELinux-support-to-sctp_test-and-sc.patch
> 
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> ---
>  Documentation/security/SELinux-sctp.txt | 508
> ++++++++++++++++++++++++++++++++
>  include/linux/lsm_hooks.h               |  27 ++
>  include/linux/security.h                |  16 +
>  net/sctp/sm_statefuns.c                 |  12 +
>  net/sctp/socket.c                       |  16 +
>  security/security.c                     |  18 ++
>  security/selinux/Makefile               |   2 +
>  security/selinux/hooks.c                | 124 +++++++-
>  security/selinux/include/classmap.h     |   4 +
>  security/selinux/include/sctp.h         |  50 ++++
>  security/selinux/include/sctp_private.h |  39 +++
>  security/selinux/netlabel.c             |   3 +
>  security/selinux/sctp.c                 | 194 ++++++++++++
>  13 files changed, 1002 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/security/SELinux-sctp.txt
>  create mode 100644 security/selinux/include/sctp.h
>  create mode 100644 security/selinux/include/sctp_private.h
>  create mode 100644 security/selinux/sctp.c
> 
> diff --git a/Documentation/security/SELinux-sctp.txt
> b/Documentation/security/SELinux-sctp.txt
> new file mode 100644
> index 0000000..dcad4b2
> --- /dev/null
> +++ b/Documentation/security/SELinux-sctp.txt
> @@ -0,0 +1,508 @@
<snip>
> +Rule validation parameters used when 'network_peer_controls = 1':
> +------------------------------------------------------------------
> -------------
> +Rule  Source   Target     Class        Permissions
> +------------------------------------------------------------------
> -------------
> +allow domain_t self     : sctp_socket {connectx peeloff set_addr
> set_params};
> +allow domain_t socket_t : sctp_socket {bindx_add bindx_rem
> set_params peeloff};

What makes some of these checks against self/domain_t vs socket_t?
 Won't socket_t usually be the same as domain_t except when using
setsockcreatecon()?

Is it useful to distinguish all of these new sctp_socket permissions,
or should some of them be coalesced into equivalence classes?  How
often will we want to allow some but not all?  When will we want to
allow setopt but not all of the sctp-specific ones?

> +allow socket_t port_t   : sctp_socket {name_bind name_connect};

NB the port types may differ for these two checks.

> +allow socket_t node_t   : sctp_socket {node_bind};
> +allow socket_t peer_t   : sctp_socket {associate};

What do we gain from adding this associate check when we also check
peer recv permission on the same pair of contexts (below)?  Also,
earlier you referred to it as "association" rather than "associate";
needs to be consistent.

> +allow peer_t   netif_t  : netif       {ingress egress};
> +allow peer_t   node_t   : node        {recvfrom sendto};
> +allow socket_t peer_t   : peer        {recv};
> +allow domain_t packet_t : packet      {send recv relabelto}
> +
<snip>
> +   3) SCTP sockets inherit their labels from the creating process
> (unless
> +      there are policy rules to change this). They do NOT follow the
> TCP
> +      labeling method even for TCP-style sockets. For reference: TCP
> child
> +      sockets take the TE information from the parent server socket,
> but the
> +      MLS/MCS information from the connection when CIPSO is enabled.

This seems problematic, given that the TCP child socket behavior was
specifically introduced to allow MLS connections to operate correctly.
Why diverge?  At some point, it would be useful to rework that to use
security_transition_sid() or similar to derive the child socket label
and let policy dictate how the MLS information is determined, but
that's a separate change.

<snip>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e15e560..491599c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
<snip>
> @@ -4034,6 +4039,23 @@ static int selinux_parse_skb_ipv4(struct
> sk_buff *skb,
>  		break;
>  	}
>  
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)

Replace throughout with #if IS_ENABLED(CONFIG_IP_SCTP)

<snip>
> @@ -4236,7 +4271,7 @@ static int socket_sockcreate_sid(const struct
> task_security_struct *tsec,
>  				       socksid);
>  }
>  
> -static int sock_has_perm(struct task_struct *task, struct sock *sk,
> u32 perms)
> +int sock_has_perm(struct task_struct *task, struct sock *sk, u32
> perms)

Likely need a prefix if you are making it non-static, e.g.
selinux_sock_has_perm() or similar.  Or maybe make it a static inline
in a header shared with your sctp.c.

>  {
>  	struct sk_security_struct *sksec = sk->sk_security;
>  	struct common_audit_data ad;
> @@ -4306,7 +4341,8 @@ static int selinux_socket_post_create(struct
> socket *sock, int family,
>     Need to determine whether we should perform a name_bind
>     permission check between the socket and the port number. */
>  
> -static int selinux_socket_bind(struct socket *sock, struct sockaddr
> *address, int addrlen)
> +int selinux_socket_bind(struct socket *sock, struct sockaddr
> *address,
> +								int
> addrlen)

Indentation

<snip>
> @@ -4405,7 +4445,8 @@ out:
>  	return err;
>  }
>  
> -static int selinux_socket_connect(struct socket *sock, struct
> sockaddr *address, int addrlen)
> +int selinux_socket_connect(struct socket *sock, struct sockaddr
> *address,
> +								int
> addrlen)

Ditto

>  {
>  	struct sock *sk = sock->sk;
>  	struct sk_security_struct *sksec = sk->sk_security;
> @@ -4416,10 +4457,12 @@ static int selinux_socket_connect(struct
> socket *sock, struct sockaddr *address,
>  		return err;
>  
>  	/*
> -	 * If a TCP or DCCP socket, check name_connect permission
> for the port.
> +	 * If a TCP, DCCP or SCTP socket, check name_connect
> permission
> +	 * for the port.
>  	 */
>  	if (sksec->sclass = SECCLASS_TCP_SOCKET ||
> -	    sksec->sclass = SECCLASS_DCCP_SOCKET) {
> +	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_SCTP_SOCKET) {
>  		struct common_audit_data ad;
>  		struct lsm_network_audit net = {0,};
>  		struct sockaddr_in *addr4 = NULL;
> @@ -4443,8 +4486,12 @@ static int selinux_socket_connect(struct
> socket *sock, struct sockaddr *address,
>  		if (err)
>  			goto out;
>  
> -		perm = (sksec->sclass = SECCLASS_TCP_SOCKET) ?
> -		       TCP_SOCKET__NAME_CONNECT :
> DCCP_SOCKET__NAME_CONNECT;
> +		if (sksec->sclass = SECCLASS_TCP_SOCKET)
> +			perm = TCP_SOCKET__NAME_CONNECT;
> +		else if (sksec->sclass = SECCLASS_DCCP_SOCKET)
> +			perm = DCCP_SOCKET__NAME_CONNECT;
> +		else if (sksec->sclass = SECCLASS_SCTP_SOCKET)
> +			perm = SCTP_SOCKET__NAME_CONNECT;

Use a switch?

>  
>  		ad.type = LSM_AUDIT_DATA_NET;
>  		ad.u.net = &net;
> @@ -4516,13 +4563,35 @@ static int selinux_socket_setsockopt(struct
> socket *sock, int level, int optname
>  	if (err)
>  		return err;
>  
> +	err = selinux_sctp_setsockopt(sock->sk, level, optname,
> NULL, 0);
> +	if (err)
> +		return err;

This seems odd to me; we call selinux_sctp_setsockopt() twice, once
without the value here and once with the value below.  I would split it
into two functions, one which handles the cases where we are only
checking based on optname (available at the socket layer, called from
here) and one which handles the cases where we need to know the actual
optval (not yet copied from userspace here, so deferred to your hook
below).  Avoid duplication between the two.

> +
>  	return selinux_netlbl_socket_setsockopt(sock, level,
> optname);
>  }
>  
> +static int selinux_sk_setsockopt(struct sock *sk, int level, int
> optname,
> +					    char *optval, int
> optlen)
> +{
> +	int err;
> +
> +	err = sock_has_perm(current, sk, SOCKET__SETOPT);
> +	if (err)
> +		return err;

This check should already have occurred from the prior hook, right?

> +
> +	return selinux_sctp_setsockopt(sk, level, optname, optval,
> optlen);
> +}
> +
>  static int selinux_socket_getsockopt(struct socket *sock, int level,
>  				     int optname)
>  {
> -	return sock_has_perm(current, sock->sk, SOCKET__GETOPT);
> +	int err;
> +
> +	err = sock_has_perm(current, sock->sk, SOCKET__GETOPT);
> +	if (err)
> +		return err;
> +
> +	return selinux_sctp_getsockopt(sock->sk, level, optname);
>  }

Is there any use case where we would want to deny peeloff while
otherwise allowing use of the sctp socket?  If not, drop.

>  
>  static int selinux_socket_shutdown(struct socket *sock, int how)
> @@ -4715,7 +4784,8 @@ static int
> selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
>  	u32 peer_sid = SECSID_NULL;
>  
>  	if (sksec->sclass = SECCLASS_UNIX_STREAM_SOCKET ||
> -	    sksec->sclass = SECCLASS_TCP_SOCKET)
> +	    sksec->sclass = SECCLASS_TCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_SCTP_SOCKET)
>  		peer_sid = sksec->peer_sid;
>  	if (peer_sid = SECSID_NULL)
>  		return -ENOPROTOOPT;
> @@ -4828,6 +4898,36 @@ static void selinux_sock_graft(struct sock
> *sk, struct socket *parent)
>  	sksec->sclass = isec->sclass;
>  }
>  
> +static int selinux_sctp_assoc_request(struct sock *sk, struct
> sk_buff *skb)
> +{
> +	struct sk_security_struct *sksec = sk->sk_security;
> +	struct common_audit_data ad;
> +	struct lsm_network_audit net = {0,};
> +	u8 peerlbl_active;
> +	int err;
> +
> +	peerlbl_active = selinux_peerlbl_enabled();
> +
> +	if (sksec->peer_sid = SECINITSID_UNLABELED &&
> peerlbl_active) {
> +		/* Here because this is the first association on
> this
> +		 * socket that is always unlabeled, therefore set
> +		 * sksec->peer_sid to new peer ctx. For further info
> see:
> +		 *    Documentation/security/SELinux-sctp.txt
> +		 */
> +		err = selinux_skb_peerlbl_sid(skb, sk->sk_family,
> +				    &sksec->peer_sid);
> +		if (err)
> +			return err;
> +	}
> +
> +	ad.type = LSM_AUDIT_DATA_NET;
> +	ad.u.net = &net;
> +	ad.u.net->sk = sk;
> +
> +	return avc_has_perm(sksec->sid, sksec->peer_sid, sksec-
> >sclass,
> +				    SCTP_SOCKET__ASSOCIATION, &ad);

Seems redundant with peer recv permission check.  If it is just a
matter of ensuring that we enforce it earlier, then you could just
check peer recv here.  But what happens if we defer the denial to the
existing peer recv check?

> diff --git a/security/selinux/netlabel.c
> b/security/selinux/netlabel.c
> index aaba667..300a195 100644
> --- a/security/selinux/netlabel.c
> +++ b/security/selinux/netlabel.c
> @@ -399,6 +399,9 @@ int selinux_netlbl_sock_rcv_skb(struct
> sk_security_struct *sksec,
>  	case SECCLASS_TCP_SOCKET:
>  		perm = TCP_SOCKET__RECVFROM;
>  		break;
> +	case SECCLASS_SCTP_SOCKET:
> +		perm = SCTP_SOCKET__RECVFROM;
> +		break;

I'm not sure we should be updating the legacy (network_peer_controls=0)
checks with newer logic.  In fact, I'd be inclined to deprecate and
eventually remove them altogether.

