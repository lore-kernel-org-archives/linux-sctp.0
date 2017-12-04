From: Richard Haines <richard_c_haines@btinternet.com>
Date: Mon, 04 Dec 2017 11:40:50 +0000
Subject: Re: [PATCH 4/4] selinux: Add SCTP support
Message-Id: <1512387650.3117.10.camel@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171127193217.2768-1-richard_c_haines@btinternet.com>
	<1511897940.30337.25.camel@tycho.nsa.gov>
	<1511899154.30337.27.camel@tycho.nsa.gov>
In-Reply-To: <1511899154.30337.27.camel@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, 2017-11-28 at 14:59 -0500, Stephen Smalley wrote:
> On Tue, 2017-11-28 at 14:39 -0500, Stephen Smalley wrote:
> > On Mon, 2017-11-27 at 19:32 +0000, Richard Haines wrote:
> > > The SELinux SCTP implementation is explained in:
> > > Documentation/security/SELinux-sctp.rst
> > > 
> > > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > > ---
> > >  Documentation/security/SELinux-sctp.rst | 104 ++++++++++++
> > >  security/selinux/hooks.c                | 278
> > > +++++++++++++++++++++++++++++---
> > >  security/selinux/include/classmap.h     |   2 +-
> > >  security/selinux/include/netlabel.h     |  15 +-
> > >  security/selinux/include/objsec.h       |   4 +
> > >  security/selinux/netlabel.c             | 128 +++++++++++++--
> > >  6 files changed, 499 insertions(+), 32 deletions(-)
> > >  create mode 100644 Documentation/security/SELinux-sctp.rst
> > > 
> > > diff --git a/Documentation/security/SELinux-sctp.rst
> > > b/Documentation/security/SELinux-sctp.rst
> > > new file mode 100644
> > > index 0000000..f6a9162
> > > --- /dev/null
> > > +++ b/Documentation/security/SELinux-sctp.rst
> > > @@ -0,0 +1,104 @@
> > > +SCTP SELinux Support
> > > +==========> > > +
> > > +Security Hooks
> > > +=======> > > +
> > > +The ``Documentation/security/LSM-sctp.rst`` document describes
> > > how
> > > the
> > > +following sctp security hooks are utilised::
> > > +
> > > +    security_sctp_assoc_request()
> > > +    security_sctp_bind_connect()
> > > +    security_sctp_sk_clone()
> > > +    security_inet_conn_established()
> > > +
> > > +
> > > +Policy Statements
> > > +=========
> > > +The following class and permissions to support SCTP are
> > > available
> > > within the
> > > +kernel::
> > > +
> > > +    class sctp_socket inherits socket { node_bind }
> > > +
> > > +whenever the following policy capability is enabled::
> > > +
> > > +    policycap extended_socket_class;
> > > +
> > > +SELinux SCTP support adds the ``name_connect`` permission for
> > > connecting
> > > +to a specific port type and the ``association`` permission that
> > > is
> > > explained
> > > +in the section below.
> > > +
> > > +If userspace tools have been updated, SCTP will support the
> > > ``portcon``
> > > +statement as shown in the following example::
> > > +
> > > +    portcon sctp 1024-1036 system_u:object_r:sctp_ports_t:s0
> > > +
> > > +
> > > +SCTP Bind, Connect and ASCONF Chunk Parameter Permission Checks
> > > +================================
> > > +The hook ``security_sctp_bind_connect()`` is called by SCTP to
> > > check
> > > +permissions required for ipv4/ipv6 addresses based on the ``@opt
> > > na
> > > me
> > > `` as
> > > +follows::
> > > +
> > > +  --------------------------------------------------------------
> > > ----
> > > +  |                   BIND Permission
> > > Checks                       |
> > > +  |       @optname             |         @address
> > > contains         |
> > > +  |----------------------------|--------------------------------
> > > ---|
> > > +  | SCTP_SOCKOPT_BINDX_ADD     | One or more ipv4 / ipv6
> > > addresses
> > > > 
> > > 
> > > +  | SCTP_PRIMARY_ADDR          | Single ipv4 or ipv6
> > > address       |
> > > +  | SCTP_SET_PEER_PRIMARY_ADDR | Single ipv4 or ipv6
> > > address       |
> > > +  --------------------------------------------------------------
> > > ----
> > > +
> > > +  --------------------------------------------------------------
> > > ----
> > > +  |                 CONNECT Permission
> > > Checks                      |
> > > +  |       @optname             |         @address
> > > contains         |
> > > +  |----------------------------|--------------------------------
> > > ---|
> > > +  | SCTP_SOCKOPT_CONNECTX      | One or more ipv4 / ipv6
> > > addresses
> > > > 
> > > 
> > > +  | SCTP_PARAM_ADD_IP          | One or more ipv4 / ipv6
> > > addresses
> > > > 
> > > 
> > > +  | SCTP_SENDMSG_CONNECT       | Single ipv4 or ipv6
> > > address       |
> > > +  | SCTP_PARAM_SET_PRIMARY     | Single ipv4 or ipv6
> > > address       |
> > > +  --------------------------------------------------------------
> > > ----
> > > +
> > > +
> > > +SCTP Peer Labeling
> > > +=========> > > +An SCTP socket will only have one peer label assigned to it.
> > > This
> > > will be
> > > +assigned during the establishment of the first association. Once
> > > the
> > > peer
> > > +label has been assigned, any new associations will have the
> > > ``association``
> > > +permission validated by checking the socket peer sid against the
> > > received
> > > +packets peer sid to determine whether the association should be
> > > allowed or
> > > +denied.
> > > +
> > > +NOTES:
> > > +   1) If peer labeling is not enabled, then the peer context
> > > will
> > > always be
> > > +      ``SECINITSID_UNLABELED`` (``unlabeled_t`` in Reference
> > > Policy).
> > > +
> > > +   2) As SCTP can support more than one transport address per
> > > endpoint
> > > +      (multi-homing) on a single socket, it is possible to
> > > configure
> > > policy
> > > +      and NetLabel to provide different peer labels for each of
> > > these. As the
> > > +      socket peer label is determined by the first associations
> > > transport
> > > +      address, it is recommended that all peer labels are
> > > consistent.
> > > +
> > > +   3) **getpeercon**\(3) may be used by userspace to retrieve
> > > the
> > > sockets peer
> > > +      context.
> > > +
> > > +   4) While not SCTP specific, be aware when using NetLabel that
> > > if
> > > a label
> > > +      is assigned to a specific interface, and that interface
> > > 'goes
> > > down',
> > > +      then the NetLabel service will remove the entry. Therefore
> > > ensure that
> > > +      the network startup scripts call **netlabelctl**\(8) to
> > > set
> > > the required
> > > +      label (see **netlabel-config**\(8) helper script for
> > > details).
> > > +
> > > +   5) The NetLabel SCTP peer labeling rules apply as discussed
> > > in
> > > the following
> > > +      set of posts tagged "netlabel" at: http://www.paul-moore.c
> > > om
> > > /b
> > > log/t.
> > > +
> > > +   6) CIPSO is only supported for IPv4 addressing:
> > > ``socket(AF_INET,
> > > ...)``
> > > +      CALIPSO is only supported for IPv6 addressing:
> > > ``socket(AF_INET6, ...)``
> > > +
> > > +      Note the following when testing CIPSO/CALIPSO:
> > > +         a) CIPSO will send an ICMP packet if an SCTP packet
> > > cannot
> > > be
> > > +            delivered because of an invalid label.
> > > +         b) CALIPSO does not send an ICMP packet, just silently
> > > discards it.
> > > +
> > > +   7) IPSEC is not supported as RFC 3554 - sctp/ipsec support
> > > has
> > > not been
> > > +      implemented in userspace (**racoon**\(8) or
> > > **ipsec_pluto**\(8)),
> > > +      although the kernel supports SCTP/IPSEC.
> > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > index 0110bb5..7bd5886 100644
> > > --- a/security/selinux/hooks.c
> > > +++ b/security/selinux/hooks.c
> > > @@ -67,6 +67,8 @@
> > >  #include <linux/tcp.h>
> > >  #include <linux/udp.h>
> > >  #include <linux/dccp.h>
> > > +#include <linux/sctp.h>
> > > +#include <net/sctp/structs.h>
> > >  #include <linux/quota.h>
> > >  #include <linux/un.h>		/* for Unix socket types */
> > >  #include <net/af_unix.h>	/* for Unix socket types */
> > > @@ -4136,6 +4138,23 @@ static int selinux_parse_skb_ipv4(struct
> > > sk_buff *skb,
> > >  		break;
> > >  	}
> > >  
> > > +#if IS_ENABLED(CONFIG_IP_SCTP)
> > > +	case IPPROTO_SCTP: {
> > > +		struct sctphdr _sctph, *sh;
> > > +
> > > +		if (ntohs(ih->frag_off) & IP_OFFSET)
> > > +			break;
> > > +
> > > +		offset += ihlen;
> > > +		sh = skb_header_pointer(skb, offset,
> > > sizeof(_sctph),
> > > &_sctph);
> > > +		if (sh = NULL)
> > > +			break;
> > > +
> > > +		ad->u.net->sport = sh->source;
> > > +		ad->u.net->dport = sh->dest;
> > > +		break;
> > > +	}
> > > +#endif
> > >  	default:
> > >  		break;
> > >  	}
> > > @@ -4209,6 +4228,19 @@ static int selinux_parse_skb_ipv6(struct
> > > sk_buff *skb,
> > >  		break;
> > >  	}
> > >  
> > > +#if IS_ENABLED(CONFIG_IP_SCTP)
> > > +	case IPPROTO_SCTP: {
> > > +		struct sctphdr _sctph, *sh;
> > > +
> > > +		sh = skb_header_pointer(skb, offset,
> > > sizeof(_sctph),
> > > &_sctph);
> > > +		if (sh = NULL)
> > > +			break;
> > > +
> > > +		ad->u.net->sport = sh->source;
> > > +		ad->u.net->dport = sh->dest;
> > > +		break;
> > > +	}
> > > +#endif
> > >  	/* includes fragments */
> > >  	default:
> > >  		break;
> > > @@ -4398,6 +4430,10 @@ static int
> > > selinux_socket_post_create(struct
> > > socket *sock, int family,
> > >  		sksec = sock->sk->sk_security;
> > >  		sksec->sclass = sclass;
> > >  		sksec->sid = sid;
> > > +		/* Allows detection of the first association on
> > > this
> > > socket */
> > > +		if (sksec->sclass = SECCLASS_SCTP_SOCKET)
> > > +			sksec->sctp_assoc_state > > > SCTP_ASSOC_UNSET;
> > 
> > Same comment as before:
> > What prevents this from interleaving with
> > selinux_sctp_assoc_request()
> > accesses to sksec->sctp_assoc_state?  You aren't holding any lock
> > here.
> >  What ensures that this executes before
> > selinux_sctp_assoc_request()?
> 
> Sorry, maybe I'm wrong. selinux_sctp_assoc_request() can't be called
> until after bind() and listen() have completed?
Correct - In tests I've never had a problem here.
> 
> > 
> > > +
> > >  		err = selinux_netlbl_socket_post_create(sock-
> > > >sk,
> > > family);
> > >  	}
> > >  
> > > @@ -4418,11 +4454,7 @@ static int selinux_socket_bind(struct
> > > socket
> > > *sock, struct sockaddr *address, in
> > >  	if (err)
> > >  		goto out;
> > >  
> > > -	/*
> > > -	 * If PF_INET or PF_INET6, check name_bind permission
> > > for
> > > the port.
> > > -	 * Multiple address binding for SCTP is not supported
> > > yet:
> > > we just
> > > -	 * check the first address now.
> > > -	 */
> > > +	/* If PF_INET or PF_INET6, check name_bind permission
> > > for
> > > the port. */
> > >  	family = sk->sk_family;
> > >  	if (family = PF_INET || family = PF_INET6) {
> > >  		char *addrp;
> > > @@ -4434,7 +4466,13 @@ static int selinux_socket_bind(struct
> > > socket
> > > *sock, struct sockaddr *address, in
> > >  		unsigned short snum;
> > >  		u32 sid, node_perm;
> > >  
> > > -		if (family = PF_INET) {
> > > +		/*
> > > +		 * sctp_bindx(3) calls via
> > > selinux_sctp_bind_connect()
> > > +		 * that validates multiple binding addresses.
> > > Because of this
> > > +		 * need to check address->sa_family as it is
> > > possible to have
> > > +		 * sk->sk_family = PF_INET6 with addr->sa_family 
> > > > > > AF_INET.
> > > +		 */
> > > +		if (address->sa_family = AF_INET) {
> > >  			if (addrlen < sizeof(struct
> > > sockaddr_in))
> > > {
> > >  				err = -EINVAL;
> > >  				goto out;
> > > @@ -4488,6 +4526,10 @@ static int selinux_socket_bind(struct
> > > socket
> > > *sock, struct sockaddr *address, in
> > >  			node_perm = DCCP_SOCKET__NODE_BIND;
> > >  			break;
> > >  
> > > +		case SECCLASS_SCTP_SOCKET:
> > > +			node_perm = SCTP_SOCKET__NODE_BIND;
> > > +			break;
> > > +
> > >  		default:
> > >  			node_perm = RAWIP_SOCKET__NODE_BIND;
> > >  			break;
> > > @@ -4502,7 +4544,7 @@ static int selinux_socket_bind(struct
> > > socket
> > > *sock, struct sockaddr *address, in
> > >  		ad.u.net->sport = htons(snum);
> > >  		ad.u.net->family = family;
> > >  
> > > -		if (family = PF_INET)
> > > +		if (address->sa_family = AF_INET)
> > >  			ad.u.net->v4info.saddr = addr4-
> > > > sin_addr.s_addr;
> > > 
> > >  		else
> > >  			ad.u.net->v6info.saddr = addr6-
> > > >sin6_addr;
> > > @@ -4516,7 +4558,11 @@ static int selinux_socket_bind(struct
> > > socket
> > > *sock, struct sockaddr *address, in
> > >  	return err;
> > >  }
> > >  
> > > -static int selinux_socket_connect(struct socket *sock, struct
> > > sockaddr *address, int addrlen)
> > > +/* This supports connect(2) and SCTP connect services such as
> > > sctp_connectx(3)
> > > + * and sctp_sendmsg(3) as described in
> > > Documentation/security/LSM-
> > > sctp.txt
> > > + */
> > > +static int selinux_socket_connect_helper(struct socket *sock,
> > > +					 struct sockaddr
> > > *address,
> > > int addrlen)
> > >  {
> > >  	struct sock *sk = sock->sk;
> > >  	struct sk_security_struct *sksec = sk->sk_security;
> > > @@ -4527,10 +4573,12 @@ static int selinux_socket_connect(struct
> > > socket *sock, struct sockaddr *address,
> > >  		return err;
> > >  
> > >  	/*
> > > -	 * If a TCP or DCCP socket, check name_connect
> > > permission
> > > for the port.
> > > +	 * If a TCP, DCCP or SCTP socket, check name_connect
> > > permission
> > > +	 * for the port.
> > >  	 */
> > >  	if (sksec->sclass = SECCLASS_TCP_SOCKET ||
> > > -	    sksec->sclass = SECCLASS_DCCP_SOCKET) {
> > > +	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
> > > +	    sksec->sclass = SECCLASS_SCTP_SOCKET) {
> > >  		struct common_audit_data ad;
> > >  		struct lsm_network_audit net = {0,};
> > >  		struct sockaddr_in *addr4 = NULL;
> > > @@ -4538,7 +4586,12 @@ static int selinux_socket_connect(struct
> > > socket *sock, struct sockaddr *address,
> > >  		unsigned short snum;
> > >  		u32 sid, perm;
> > >  
> > > -		if (sk->sk_family = PF_INET) {
> > > +		/* sctp_connectx(3) calls via
> > > selinux_sctp_bind_connect()
> > > +		 * that validates multiple connect addresses.
> > > Because of this
> > > +		 * need to check address->sa_family as it is
> > > possible to have
> > > +		 * sk->sk_family = PF_INET6 with addr->sa_family 
> > > > > > AF_INET.
> > > +		 */
> > > +		if (address->sa_family = AF_INET) {
> > >  			addr4 = (struct sockaddr_in *)address;
> > >  			if (addrlen < sizeof(struct
> > > sockaddr_in))
> > >  				return -EINVAL;
> > > @@ -4552,10 +4605,19 @@ static int selinux_socket_connect(struct
> > > socket *sock, struct sockaddr *address,
> > >  
> > >  		err = sel_netport_sid(sk->sk_protocol, snum,
> > > &sid);
> > >  		if (err)
> > > -			goto out;
> > > +			return err;
> > >  
> > > -		perm = (sksec->sclass = SECCLASS_TCP_SOCKET) ?
> > > -		       TCP_SOCKET__NAME_CONNECT :
> > > DCCP_SOCKET__NAME_CONNECT;
> > > +		switch (sksec->sclass) {
> > > +		case SECCLASS_TCP_SOCKET:
> > > +			perm = TCP_SOCKET__NAME_CONNECT;
> > > +			break;
> > > +		case SECCLASS_DCCP_SOCKET:
> > > +			perm = DCCP_SOCKET__NAME_CONNECT;
> > > +			break;
> > > +		case SECCLASS_SCTP_SOCKET:
> > > +			perm = SCTP_SOCKET__NAME_CONNECT;
> > > +			break;
> > > +		}
> > >  
> > >  		ad.type = LSM_AUDIT_DATA_NET;
> > >  		ad.u.net = &net;
> > > @@ -4563,13 +4625,24 @@ static int selinux_socket_connect(struct
> > > socket *sock, struct sockaddr *address,
> > >  		ad.u.net->family = sk->sk_family;
> > >  		err = avc_has_perm(sksec->sid, sid, sksec-
> > > >sclass,
> > > perm, &ad);
> > >  		if (err)
> > > -			goto out;
> > > +			return err;
> > >  	}
> > >  
> > > -	err = selinux_netlbl_socket_connect(sk, address);
> > > +	return 0;
> > > +}
> > >  
> > > -out:
> > > -	return err;
> > > +/* Supports connect(2), see comments in
> > > selinux_socket_connect_helper() */
> > > +static int selinux_socket_connect(struct socket *sock,
> > > +				  struct sockaddr *address, int
> > > addrlen)
> > > +{
> > > +	int err;
> > > +	struct sock *sk = sock->sk;
> > > +
> > > +	err = selinux_socket_connect_helper(sock, address,
> > > addrlen);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	return selinux_netlbl_socket_connect(sk, address);
> > >  }
> > >  
> > >  static int selinux_socket_listen(struct socket *sock, int
> > > backlog)
> > > @@ -4832,7 +4905,8 @@ static int
> > > selinux_socket_getpeersec_stream(struct socket *sock, char __user
> > > *op
> > >  	u32 peer_sid = SECSID_NULL;
> > >  
> > >  	if (sksec->sclass = SECCLASS_UNIX_STREAM_SOCKET ||
> > > -	    sksec->sclass = SECCLASS_TCP_SOCKET)
> > > +	    sksec->sclass = SECCLASS_TCP_SOCKET ||
> > > +	    sksec->sclass = SECCLASS_SCTP_SOCKET)
> > >  		peer_sid = sksec->peer_sid;
> > >  	if (peer_sid = SECSID_NULL)
> > >  		return -ENOPROTOOPT;
> > > @@ -4945,6 +5019,169 @@ static void selinux_sock_graft(struct
> > > sock
> > > *sk, struct socket *parent)
> > >  	sksec->sclass = isec->sclass;
> > >  }
> > >  
> > > +/* Called whenever SCTP receives an INIT chunk. This happens
> > > when
> > > an
> > > incoming
> > > + * connect(2), sctp_connectx(3) or sctp_sendmsg(3) (with no
> > > association
> > > + * already present).
> > > + * The lock is to ensure sksec->sctp_assoc_state.
> > > + */
> > > +static DEFINE_SPINLOCK(assoc_lock);
> > 
> > The lock needs to be taken by all entities accessing sksec-
> > > sctp_assoc_state, and you need to further ensure proper handling
> > > if
> > 
> > the ordering is reversed.  Also, the lock should be per-sksec, not
> > global.
> > 
> > > +static int selinux_sctp_assoc_request(struct sctp_endpoint *ep,
> > > +				      struct sk_buff *skb)
> > > +{
> > > +	struct sk_security_struct *sksec = ep->base.sk-
> > > > sk_security;
> > > 
> > > +	struct common_audit_data ad;
> > > +	struct lsm_network_audit net = {0,};
> > > +	u8 peerlbl_active;
> > > +	u32 peer_sid = SECINITSID_UNLABELED;
> > > +	u32 conn_sid;
> > > +	int err = 0;
> > > +
> > > +	if (!selinux_policycap_extsockclass)
> > > +		return 0;
> > > +
> > > +	spin_lock(&assoc_lock);
> 
> So what is this protecting?  And if needed, does it need to be
> spin_lock_bh() instead of just spin_lock()? Can multiple calls to
> selinux_sctp_assoc_request() on the same endpoint be interleaved?
> 
In the RFC patch I would also call this on client side INIT_ACK which
is why I had the lock. However I've now dropped this check so the lock
can go. During tests I've not seen any interleaving so removing this
lock seems okay.

I'll submit a new patch to also include the kbuild test robot catch as
well later this week.

> > > +
> > > +	peerlbl_active = selinux_peerlbl_enabled();
> > > +
> > > +	if (peerlbl_active) {
> > > +		/* This will return peer_sid = SECSID_NULL if
> > > there
> > > are
> > > +		 * no peer labels, see
> > > security_net_peersid_resolve().
> > > +		 */
> > > +		err = selinux_skb_peerlbl_sid(skb, ep->base.sk-
> > > > sk_family,
> > > 
> > > +					      &peer_sid);
> > > +		if (err)
> > > +			goto err;
> > > +
> > > +		if (peer_sid = SECSID_NULL)
> > > +			peer_sid = SECINITSID_UNLABELED;
> > > +	}
> > > +
> > > +	if (sksec->sctp_assoc_state = SCTP_ASSOC_UNSET) {
> > > +		sksec->sctp_assoc_state = SCTP_ASSOC_SET;
> > > +
> > > +		/* Here as first association on socket. As the
> > > peer
> > > SID
> > > +		 * was allowed by peer recv (and the netif/node
> > > checks),
> > > +		 * then it is approved by policy and used as the
> > > primary
> > > +		 * peer SID for getpeercon(3).
> > > +		 */
> > > +		sksec->peer_sid = peer_sid;
> > > +	} else if  (sksec->peer_sid != peer_sid) {
> > > +		/* Other association peer SIDs are checked to
> > > enforce
> > > +		 * consistency among the peer SIDs.
> > > +		 */
> > > +		ad.type = LSM_AUDIT_DATA_NET;
> > > +		ad.u.net = &net;
> > > +		ad.u.net->sk = ep->base.sk;
> > > +		err = avc_has_perm(sksec->peer_sid, peer_sid,
> > > sksec-
> > > > sclass,
> > > 
> > > +				   SCTP_SOCKET__ASSOCIATION,
> > > &ad);
> > > +		if (err)
> > > +			goto err;
> > > +	}
> > > +
> > > +	/* Compute the MLS component for the connection and
> > > store
> > > +	 * the information in ep. This will be used by SCTP TCP
> > > type
> > > +	 * sockets and peeled off connections as they cause a
> > > new
> > > +	 * socket to be generated. selinux_sctp_sk_clone() will
> > > then
> > > +	 * plug this into the new socket.
> > > +	 */
> > > +	err = selinux_conn_sid(sksec->sid, peer_sid, &conn_sid);
> > > +	if (err)
> > > +		goto err;
> > > +
> > > +	ep->secid = conn_sid;
> > > +	ep->peer_secid = peer_sid;
> > > +
> > > +	/* Set any NetLabel labels including CIPSO/CALIPSO
> > > options.
> > > */
> > > +	err = selinux_netlbl_sctp_assoc_request(ep, skb);
> > > +
> > > +err:
> > > +	spin_unlock(&assoc_lock);
> > > +	return err;
> > > +}
> > > +
> > > +/*
> > > + * Check if sctp IPv4/IPv6 addresses are valid for binding or
> > > connecting
> > > + * based on their @optname.
> > > + */
> > > +static int selinux_sctp_bind_connect(struct sock *sk, int
> > > optname,
> > > +				     struct sockaddr *address,
> > > +				     int addrlen)
> > > +{
> > > +	int len, err = 0, walk_size = 0;
> > > +	void *addr_buf;
> > > +	struct sockaddr *addr;
> > > +	struct socket *sock;
> > > +
> > > +	if (!selinux_policycap_extsockclass)
> > > +		return 0;
> > > +
> > > +	/* Process one or more addresses that may be IPv4 or
> > > IPv6
> > > */
> > > +	sock = sk->sk_socket;
> > > +	addr_buf = address;
> > > +
> > > +	while (walk_size < addrlen) {
> > > +		addr = addr_buf;
> > > +		switch (addr->sa_family) {
> > > +		case AF_INET:
> > > +			len = sizeof(struct sockaddr_in);
> > > +			break;
> > > +		case AF_INET6:
> > > +			len = sizeof(struct sockaddr_in6);
> > > +			break;
> > > +		default:
> > > +			return -EAFNOSUPPORT;
> > > +		}
> > > +
> > > +		err = -EINVAL;
> > > +		switch (optname) {
> > > +		/* Bind checks */
> > > +		case SCTP_PRIMARY_ADDR:
> > > +		case SCTP_SET_PEER_PRIMARY_ADDR:
> > > +		case SCTP_SOCKOPT_BINDX_ADD:
> > > +			err = selinux_socket_bind(sock, addr,
> > > len);
> > > +			break;
> > > +		/* Connect checks */
> > > +		case SCTP_SOCKOPT_CONNECTX:
> > > +		case SCTP_PARAM_SET_PRIMARY:
> > > +		case SCTP_PARAM_ADD_IP:
> > > +		case SCTP_SENDMSG_CONNECT:
> > > +			err > > > selinux_socket_connect_helper(sock,
> > > addr, len);
> > > +			if (err)
> > > +				return err;
> > > +
> > > +			err > > > selinux_netlbl_sctp_socket_connect(sk,
> > > addr);
> > > +			break;
> > > +		}
> > > +
> > > +		if (err)
> > > +			return err;
> > > +
> > > +		addr_buf += len;
> > > +		walk_size += len;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Called whenever a new socket is created by accept(2) or
> > > sctp_peeloff(3). */
> > > +static void selinux_sctp_sk_clone(struct sctp_endpoint *ep,
> > > struct
> > > sock *sk,
> > > +				  struct sock *newsk)
> > > +{
> > > +	struct sk_security_struct *sksec = sk->sk_security;
> > > +	struct sk_security_struct *newsksec = newsk-
> > > >sk_security;
> > > +
> > > +	/* If policy does not support SECCLASS_SCTP_SOCKET then
> > > call
> > > +	 * the non-sctp clone version.
> > > +	 */
> > > +	if (!selinux_policycap_extsockclass)
> > > +		return selinux_sk_clone_security(sk, newsk);
> > > +
> > > +	newsksec->sid = ep->secid;
> > > +	newsksec->peer_sid = ep->peer_secid;
> > > +	newsksec->sclass = sksec->sclass;
> > > +	newsksec->nlbl_state = sksec->nlbl_state;
> > > +}
> > > +
> > >  static int selinux_inet_conn_request(struct sock *sk, struct
> > > sk_buff
> > > *skb,
> > >  				     struct request_sock *req)
> > >  {
> > > @@ -6433,6 +6670,9 @@ static struct security_hook_list
> > > selinux_hooks[] __lsm_ro_after_init = {
> > >  	LSM_HOOK_INIT(sk_clone_security,
> > > selinux_sk_clone_security),
> > >  	LSM_HOOK_INIT(sk_getsecid, selinux_sk_getsecid),
> > >  	LSM_HOOK_INIT(sock_graft, selinux_sock_graft),
> > > +	LSM_HOOK_INIT(sctp_assoc_request,
> > > selinux_sctp_assoc_request),
> > > +	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
> > > +	LSM_HOOK_INIT(sctp_bind_connect,
> > > selinux_sctp_bind_connect),
> > >  	LSM_HOOK_INIT(inet_conn_request,
> > > selinux_inet_conn_request),
> > >  	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
> > >  	LSM_HOOK_INIT(inet_conn_established,
> > > selinux_inet_conn_established),
> > > diff --git a/security/selinux/include/classmap.h
> > > b/security/selinux/include/classmap.h
> > > index 35ffb29..099065e 100644
> > > --- a/security/selinux/include/classmap.h
> > > +++ b/security/selinux/include/classmap.h
> > > @@ -175,7 +175,7 @@ struct security_class_mapping secclass_map[]
> > > > > > {
> > >  	  { COMMON_CAP2_PERMS, NULL } },
> > >  	{ "sctp_socket",
> > >  	  { COMMON_SOCK_PERMS,
> > > -	    "node_bind", NULL } },
> > > +	    "node_bind", "name_connect", "association", NULL }
> > > },
> > >  	{ "icmp_socket",
> > >  	  { COMMON_SOCK_PERMS,
> > >  	    "node_bind", NULL } },
> > > diff --git a/security/selinux/include/netlabel.h
> > > b/security/selinux/include/netlabel.h
> > > index 75686d5..313c8bd 100644
> > > --- a/security/selinux/include/netlabel.h
> > > +++ b/security/selinux/include/netlabel.h
> > > @@ -33,6 +33,7 @@
> > >  #include <linux/skbuff.h>
> > >  #include <net/sock.h>
> > >  #include <net/request_sock.h>
> > > +#include <net/sctp/structs.h>
> > >  
> > >  #include "avc.h"
> > >  #include "objsec.h"
> > > @@ -53,7 +54,8 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff
> > > *skb,
> > >  int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
> > >  				 u16 family,
> > >  				 u32 sid);
> > > -
> > > +int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
> > > +				     struct sk_buff *skb);
> > >  int selinux_netlbl_inet_conn_request(struct request_sock *req,
> > > u16
> > > family);
> > >  void selinux_netlbl_inet_csk_clone(struct sock *sk, u16 family);
> > >  int selinux_netlbl_socket_post_create(struct sock *sk, u16
> > > family);
> > > @@ -65,6 +67,7 @@ int selinux_netlbl_socket_setsockopt(struct
> > > socket
> > > *sock,
> > >  				     int level,
> > >  				     int optname);
> > >  int selinux_netlbl_socket_connect(struct sock *sk, struct
> > > sockaddr
> > > *addr);
> > > +int selinux_netlbl_sctp_socket_connect(struct sock *sk, struct
> > > sockaddr *addr);
> > >  
> > >  #else
> > >  static inline void selinux_netlbl_cache_invalidate(void)
> > > @@ -114,6 +117,11 @@ static inline int
> > > selinux_netlbl_conn_setsid(struct sock *sk,
> > >  	return 0;
> > >  }
> > >  
> > > +static inline int selinux_netlbl_sctp_assoc_request(struct
> > > sctp_endpoint *ep,
> > > +						    struct
> > > sk_buff
> > > *skb)
> > > +{
> > > +	return 0;
> > > +}
> > >  static inline int selinux_netlbl_inet_conn_request(struct
> > > request_sock *req,
> > >  						   u16 family)
> > >  {
> > > @@ -146,6 +154,11 @@ static inline int
> > > selinux_netlbl_socket_connect(struct sock *sk,
> > >  {
> > >  	return 0;
> > >  }
> > > +static inline int selinux_netlbl_sctp_socket_connect(struct sock
> > > *sk,
> > > +						     struct
> > > sockaddr
> > > *addr)
> > > +{
> > > +	return 0;
> > > +}
> > >  #endif /* CONFIG_NETLABEL */
> > >  
> > >  #endif
> > > diff --git a/security/selinux/include/objsec.h
> > > b/security/selinux/include/objsec.h
> > > index 6ebc61e..e319d5d 100644
> > > --- a/security/selinux/include/objsec.h
> > > +++ b/security/selinux/include/objsec.h
> > > @@ -130,6 +130,10 @@ struct sk_security_struct {
> > >  	u32 sid;			/* SID of this object */
> > >  	u32 peer_sid;			/* SID of peer */
> > >  	u16 sclass;			/* sock security
> > > class
> > > */
> > > +	enum {				/* SCTP
> > > association
> > > state */
> > > +		SCTP_ASSOC_UNSET = 0,
> > > +		SCTP_ASSOC_SET,
> > > +	} sctp_assoc_state;
> > >  };
> > >  
> > >  struct tun_security_struct {
> > > diff --git a/security/selinux/netlabel.c
> > > b/security/selinux/netlabel.c
> > > index aaba667..ac23f29 100644
> > > --- a/security/selinux/netlabel.c
> > > +++ b/security/selinux/netlabel.c
> > > @@ -250,6 +250,7 @@ int selinux_netlbl_skbuff_setsid(struct
> > > sk_buff
> > > *skb,
> > >  	sk = skb_to_full_sk(skb);
> > >  	if (sk != NULL) {
> > >  		struct sk_security_struct *sksec = sk-
> > > > sk_security;
> > > 
> > > +
> > >  		if (sksec->nlbl_state != NLBL_REQSKB)
> > >  			return 0;
> > >  		secattr = selinux_netlbl_sock_getattr(sk, sid);
> > > @@ -270,6 +271,61 @@ int selinux_netlbl_skbuff_setsid(struct
> > > sk_buff
> > > *skb,
> > >  	return rc;
> > >  }
> > >  
> > > +/**
> > > + * selinux_netlbl_sctp_assoc_request - Label an incoming sctp
> > > association.
> > > + * @ep: incoming association endpoint.
> > > + * @skb: the packet.
> > > + *
> > > + * Description:
> > > + * A new incoming connection is represented by @ep, ......
> > > + * Returns zero on success, negative values on failure.
> > > + *
> > > + */
> > > +int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
> > > +				     struct sk_buff *skb)
> > > +{
> > > +	int rc;
> > > +	struct netlbl_lsm_secattr secattr;
> > > +	struct sk_security_struct *sksec = ep->base.sk-
> > > > sk_security;
> > > 
> > > +	struct sockaddr *addr;
> > > +	struct sockaddr_in addr4;
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +	struct sockaddr_in6 addr6;
> > > +#endif
> > > +
> > > +	if (ep->base.sk->sk_family != PF_INET &&
> > > +				ep->base.sk->sk_family !> > > PF_INET6)
> > > +		return 0;
> > > +
> > > +	netlbl_secattr_init(&secattr);
> > > +	rc = security_netlbl_sid_to_secattr(ep->secid,
> > > &secattr);
> > > +	if (rc != 0)
> > > +		goto assoc_request_return;
> > > +
> > > +	/* Move skb hdr address info to a struct sockaddr and
> > > then
> > > call
> > > +	 * netlbl_conn_setattr().
> > > +	 */
> > > +	if (ip_hdr(skb)->version = 4) {
> > > +		addr4.sin_family = AF_INET;
> > > +		addr4.sin_addr.s_addr = ip_hdr(skb)->saddr;
> > > +		addr = (struct sockaddr *)&addr4;
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +	} else {
> > > +		addr6.sin6_family = AF_INET6;
> > > +		addr6.sin6_addr = ipv6_hdr(skb)->saddr;
> > > +		addr = (struct sockaddr *)&addr6;
> > > +#endif
> > > +	}
> > > +
> > > +	rc = netlbl_conn_setattr(ep->base.sk, addr, &secattr);
> > > +	if (rc = 0)
> > > +		sksec->nlbl_state = NLBL_LABELED;
> > > +
> > > +assoc_request_return:
> > > +	netlbl_secattr_destroy(&secattr);
> > > +	return rc;
> > > +}
> > > +
> > >  /**
> > >   * selinux_netlbl_inet_conn_request - Label an incoming stream
> > > connection
> > >   * @req: incoming connection request socket
> > > @@ -470,7 +526,8 @@ int selinux_netlbl_socket_setsockopt(struct
> > > socket *sock,
> > >  }
> > >  
> > >  /**
> > > - * selinux_netlbl_socket_connect - Label a client-side socket on
> > > connect
> > > + * selinux_netlbl_socket_connect_helper - Help label a client-
> > > side
> > > socket on
> > > + * connect
> > >   * @sk: the socket to label
> > >   * @addr: the destination address
> > >   *
> > > @@ -479,18 +536,13 @@ int selinux_netlbl_socket_setsockopt(struct
> > > socket *sock,
> > >   * Returns zero values on success, negative values on failure.
> > >   *
> > >   */
> > > -int selinux_netlbl_socket_connect(struct sock *sk, struct
> > > sockaddr
> > > *addr)
> > > +static int selinux_netlbl_socket_connect_helper(struct sock *sk,
> > > +						struct sockaddr
> > > *addr)
> > >  {
> > >  	int rc;
> > >  	struct sk_security_struct *sksec = sk->sk_security;
> > >  	struct netlbl_lsm_secattr *secattr;
> > >  
> > > -	if (sksec->nlbl_state != NLBL_REQSKB &&
> > > -	    sksec->nlbl_state != NLBL_CONNLABELED)
> > > -		return 0;
> > > -
> > > -	lock_sock(sk);
> > > -
> > >  	/* connected sockets are allowed to disconnect when the
> > > address family
> > >  	 * is set to AF_UNSPEC, if that is what is happening we
> > > want
> > > to reset
> > >  	 * the socket */
> > > @@ -498,18 +550,72 @@ int selinux_netlbl_socket_connect(struct
> > > sock
> > > *sk, struct sockaddr *addr)
> > >  		netlbl_sock_delattr(sk);
> > >  		sksec->nlbl_state = NLBL_REQSKB;
> > >  		rc = 0;
> > > -		goto socket_connect_return;
> > > +		return rc;
> > >  	}
> > >  	secattr = selinux_netlbl_sock_genattr(sk);
> > >  	if (secattr = NULL) {
> > >  		rc = -ENOMEM;
> > > -		goto socket_connect_return;
> > > +		return rc;
> > >  	}
> > >  	rc = netlbl_conn_setattr(sk, addr, secattr);
> > >  	if (rc = 0)
> > >  		sksec->nlbl_state = NLBL_CONNLABELED;
> > >  
> > > -socket_connect_return:
> > > +	return rc;
> > > +}
> > > +
> > > +/**
> > > + * selinux_netlbl_socket_connect - Label a client-side socket on
> > > connect
> > > + * @sk: the socket to label
> > > + * @addr: the destination address
> > > + *
> > > + * Description:
> > > + * Attempt to label a connected socket with NetLabel using the
> > > given
> > > address.
> > > + * Returns zero values on success, negative values on failure.
> > > + *
> > > + */
> > > +int selinux_netlbl_socket_connect(struct sock *sk, struct
> > > sockaddr
> > > *addr)
> > > +{
> > > +	int rc;
> > > +	struct sk_security_struct *sksec = sk->sk_security;
> > > +
> > > +	if (sksec->nlbl_state != NLBL_REQSKB &&
> > > +	    sksec->nlbl_state != NLBL_CONNLABELED)
> > > +		return 0;
> > > +
> > > +	lock_sock(sk);
> > > +	rc = selinux_netlbl_socket_connect_helper(sk, addr);
> > >  	release_sock(sk);
> > > +
> > > +	return rc;
> > > +}
> > > +
> > > +/**
> > > + * selinux_netlbl_sctp_socket_connect - Label an SCTP client-
> > > side
> > > socket on a
> > > + * connect
> > > + * @sk: the socket to label
> > > + * @addr: the destination address
> > > + *
> > > + * Description:
> > > + * Attempt to label a connected socket with NetLabel using the
> > > given
> > > address
> > > + * when called by the SCTP protocol layer. The situations
> > > handled
> > > are:
> > > + * sctp_connectx(3), sctp_sendmsg(3), sendmsg(2), whenever a new
> > > IP
> > > address
> > > + * is added or when a new primary address is selected. Note that
> > > an
> > > SCTP
> > > + * connect(2) call happens before the SCTP protocol layer and is
> > > handled via
> > > + * selinux_netlbl_socket_connect()
> > > + * Returns zero values on success, negative values on failure.
> > > + *
> > > + */
> > > +int selinux_netlbl_sctp_socket_connect(struct sock *sk, struct
> > > sockaddr *addr)
> > > +{
> > > +	int rc;
> > > +	struct sk_security_struct *sksec = sk->sk_security;
> > > +
> > > +	if (sksec->nlbl_state != NLBL_REQSKB &&
> > > +	    sksec->nlbl_state != NLBL_CONNLABELED)
> > > +		return 0;
> > > +
> > > +	rc = selinux_netlbl_socket_connect_helper(sk, addr);
> > > +
> > >  	return rc;
> > >  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
