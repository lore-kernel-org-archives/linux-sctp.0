From: Casey Schaufler <casey@schaufler-ca.com>
Date: Mon, 26 Jan 2015 17:45:21 +0000
Subject: Re: [RFC PATCH v3] SELinux SCTP protocol support
Message-Id: <54C67D31.6070602@schaufler-ca.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1422198436-5090-1-git-send-email-richard_c_haines@btinternet.com>
In-Reply-To: <1422198436-5090-1-git-send-email-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Haines <richard_c_haines@btinternet.com>, selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org
Cc: dborkman@redhat.com, LSM <linux-security-module@vger.kernel.org>

On 1/25/2015 7:07 AM, Richard Haines wrote:
> The Documentation/security/SELinux-sctp.txt describes how the patch has
> been implemented and tested.
>
> Patches to support the new SCTP portcon statement can be found at [1] and
> will apply to the latest release (rc7) found at [2].
>
> Also minor updates for DCCP to retrieve peer context via getpeercon(3).
>
> Built and tested on Fedora kernel-3.17.3-200.fc20.x86_64
>
> [1] http://marc.info/?l=selinux&m1536871703018&w=2
> [2] https://github.com/SELinuxProject/selinux/wiki/Releases
>
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> ---
>  Documentation/security/SELinux-sctp.txt | 247 ++++++++++++++++++++++++++++++++
>  include/linux/security.h                |  42 ++++++
>  net/sctp/sm_statefuns.c                 |  10 ++
>  net/sctp/socket.c                       |  15 ++
>  security/capability.c                   |  13 ++
>  security/security.c                     |  13 ++

Please add the LSM <linux-security-module@vger.kernel.org> list to this RFC.

>  security/selinux/Makefile               |   2 +
>  security/selinux/hooks.c                | 147 ++++++++++++++++---
>  security/selinux/include/classmap.h     |   4 +
>  security/selinux/include/sctp.h         |  52 +++++++
>  security/selinux/include/sctp_private.h |  51 +++++++
>  security/selinux/netlabel.c             |   3 +
>  security/selinux/sctp.c                 | 185 ++++++++++++++++++++++++
>  13 files changed, 768 insertions(+), 16 deletions(-)
>  create mode 100644 Documentation/security/SELinux-sctp.txt
>  create mode 100644 security/selinux/include/sctp.h
>  create mode 100644 security/selinux/include/sctp_private.h
>  create mode 100644 security/selinux/sctp.c
>
> diff --git a/Documentation/security/SELinux-sctp.txt b/Documentation/security/SELinux-sctp.txt
> new file mode 100644
> index 0000000..476ba24
> --- /dev/null
> +++ b/Documentation/security/SELinux-sctp.txt
> @@ -0,0 +1,247 @@
> +                               SCTP SELinux Support
> +                              ===========
> +
> +Security Hooks
> +=======> +security_sk_setsockopt()
> +-------------------------
> +A new security hook security_sk_setsockopt() is introduced that checks
> +permissions before setting the options associated with sock @sk.
> +This is supported in security/selinux/hooks.c and net/sctp/socket.c
> +An example usage is where sctp_getsockopt_connectx3() and
> +__sctp_setsockopt_connectx() manage the @optval data into a certain
> +state before security_sk_setsockopt is called for permission checks. This
> +means that the code to manage options does not need to be replicated in the
> +security module. See include/linux/security.h for details.
> +
> +security_sctp_assoc_request()
> +-----------------------------
> +security/selinux/hooks.c selinux_sctp_assoc_request() has been introduced to
> +support SCTP and obtains the sock peer context if first association and
> +also checks the association permission as shown in the "SCTP Peer Labeling
> +and Permission Checks" section below.
> +
> +The security_sctp_assoc_request() security hook has been added to
> +net/sctp/sm_statefuns.c where it passes the sk and chunk->skb to the security
> +module.
> +
> +security_sk_clone()
> +--------------------
> +Added to net/sctp/socket.c for cloning the security context on a new socket.
> +
> +
> +Policy Statements
> +=========
> +A new object class "sctp_socket" has been introduced with the following SCTP
> +specific permissions: "association" "bindx_add" "bindx_rem" "connectx"
> +and "peeloff". These are explained in the sections below.
> +
> +Kernel policy language
> +-----------------------
> +class sctp_socket
> +class sctp_socket inherits socket { node_bind name_connect association
> +        bindx_add bindx_rem connectx peeloff }
> +
> +CIL policy language
> +--------------------
> +(classcommon sctp_socket socket)
> +(class sctp_socket (node_bind name_connect association bindx_add bindx_rem
> +       connectx peeloff))
> +
> +Last classorder from refpolicy base:
> +   (classorder (db_language sctp_socket))
> +Last classorder from Fedora targeted base:
> +   (classorder (proxy sctp_socket))
> +
> +If userspace tools have been updated, then the portcon statement may be used
> +as shown in the following example:
> +(portcon sctp (2000 20000) (system_u object_r port_test_t ((s0) (s0))))
> +
> +NOTE: SELinux supports a maximum of 32 permissions per object class. SCTP
> +      has already allocated 29 (22 socket + 7 sctp_socket permissions).
> +      These are the permissions checked for sctp_socket in security/hooks.c:
> +          read write create getattr bind connect listen accept getopt setopt
> +          name_bind node_bind name_connect association bindx_add bindx_rem
> +          connectx peeloff
> +
> +"allow" Rule Validation Parameters (network_peer_controls = 1)
> +-------------------------------------------------------------------
> +allow domain_t socket_t : sctp_socket {bindx_add bindx_rem set_params peeloff};
> +allow socket_t port_t   : sctp_socket {name_bind name_connect};
> +allow socket_t node_t   : sctp_socket {node_bind};
> +allow socket_t peer_t   : sctp_socket {associate};
> +allow peer_t   netif_t  : netif       {ingress egress};
> +allow peer_t   node_t   : node        {recvfrom sendto};
> +allow socket_t peer_t   : peer        {recv};
> +
> +
> +SCTP Socket Option Permissions
> +===============> +These consist of: "bindx_add" "bindx_rem" "connectx" and "peeloff" and are
> +used as follows:
> +
> +SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> +                         associated after (optionally) calling bind(2).
> +
> +SCTP_SOCKOPT_CONNECTX* - Allows the allocation of multiple
> +                         addresses for reaching a multi-homed peer.
> +
> +  Together they form SCTP associations and will be passed over the
> +  link to inform peer of any changes. As these two options can support
> +  multiple addresses, each address is checked via selinux_socket_bind() or
> +  selinux_socket_connect() to determine whether they have the correct
> +  permissions:
> +    bindx_add: bind, name_bind, node_bind + node SID + port SID via the
> +               (portcon sctp port ctx) policy statement.
> +    connectx:  connect, name_connect + port SID via the
> +               (portcon sctp port ctx) policy statement.
> +
> +SCTP_SOCKOPT_BINDX_REM - As the addresses would have already been
> +                         allowed, only the bindx_rem permission is checked.
> +
> +SCTP_PEER_ADDR_PARAMS - Alter heartbeats and address max retransmissions.
> +SCTP_PEER_ADDR_THLDS  - Alter the thresholds.
> + These require the set_params permission.
> +
> +SCTP_PRIMARY_ADDR          - Set local primary address.
> +SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as association primary.
> + These require the set_addr permission.
> +
> +SCTP_SOCKOPT_PEELOFF - Branch off an association into a new socket that
> +will be a one-to-one style socket. As SELinux already handles the creation
> +of new sockets, only the peeloff permission is checked.
> +
> +
> +SCTP Peer Labeling and Permission Checks
> +====================> +An SCTP socket will only have one peer label assigned to it. This will be
> +assigned during the establishment of the first association. Once the peer label
> +has been assigned, the "association" permission will be checked as follows:
> +
> +       allow socket_t peer_t : sctp_socket { associate };
> +
> +As SCTP supports multiple endpoints on a single socket it is possible that
> +each interface may be configured with a different peer label, however it is
> +recommended that the labels are consistant (see "Multi-homing Test" section
> +for examples).
> +
> +NOTES:
> +   1) If peer labeling is not enabled, then the peer context will always be
> +      SECINITSID_UNLABELED (unlabeled_t in Reference Policy).
> +
> +   2) If using NetLabel fallback labeling "netlabelctl unlbl ..." be aware
> +      that if a label is assigned to a specific interface, and that interface
> +      'goes down' (as in the "Multi-homing Test" section), then the NetLabel
> +      service will remove the entry. Therefore ensure that the network
> +      startup scripts call netlabelctl(8) to set the required label (see
> +      netlabel-config(8) helper script for details).
> +
> +   3) SCTP sockets inherit their labels from the creating process (unless
> +      there are policy rules to change this). They do NOT follow the TCP
> +      labeling method even for TCP-style sockets. For reference: TCP child
> +      sockets take the TE information from the parent server socket, but the
> +      MLS/MCS information from the connection.
> +
> +   4) getpeercon(3) may be used by userspace apps to retrieve the sockets
> +      peer context.
> +
> +   5) The peer labeling rules still apply as discussed in the following set
> +      of pages at: http://paulmoore.livejournal.com/tag/netlabel
> +
> +
> +      SCTP endpoint "A"                                SCTP endpoint "Z"
> +      =========                                ========> +    sctp_sf_do_prm_asoc()
> + Initiate an association to
> + SCTP peer endpoint "Z".
> + Send INIT first as we need to obtain
> + a peer label before checking whether
> + this is allowed or not. This will be
> + checked once the INIT ACK has been
> + received.
> +         INIT --------------------------------------------->
> +                                                   sctp_sf_do_5_1B_init()
> +                                                 Respond to an INIT chunk.
> +                                             SCTP peer endpoint "A" is
> +                                             asking for an association. Call
> +                                             security_sctp_assoc_request()
> +                                             to set the peer label if first
> +                                             association, then check ASSOCIATE
> +                                             permission:
> +                             allow socket_t peer_t : sctp_socket { associate };
> +                                             IF valid send:
> +          <----------------------------------------------- INIT ACK
> +          |                                  ELSE audit event and silently
> +          |                                       discard the packet.
> +    sctp_sf_do_5_1C_ack
> + Respond to an INIT ACK chunk.
> + SCTP peer endpoint"A" initiated
> + this association to SCTP peer
> + endpoint "Z". The security checks
> + are done now as we have a peer
> + label to check against, so call
> + security_sctp_assoc_request()
> + to set the peer label if first
> + association, then check ASSOCIATE
> + permission:
> +    allow socket_t peer_t : sctp_socket { associate };
> + IF valid send:
> +    COOKIE ECHO ------------------------------------------------>
> + ELSE audit event and silently                                  |
> +      discard the packet.                                       |
> +                                                                |
> +          <----------------------------------------------- COOKIE ACK
> +          |                                                     |
> +   sctp_sf_do_5_1E_ca                                  sctp_sf_do_5_1D_ce
> +      ESTABLISHED                                          ESTABLISHED
> +          |                                                     |
> +    ------------------------------------------------------------------
> +    |                     Association Established                    |
> +    ------------------------------------------------------------------
> +
> +
> +Testing
> +====
> +All lksctp-tools/src/func_tests run correctly in enforcing mode except when
> +specific permissions are denied (e.g. test_peeloff_v6 will fail with
> +"test_peeloff.c  1 BROK : sctp_peeloff: Permission denied").
> +
> +Tests involving removal of the "association" permission will wait, simply
> +because the INIT or INIT ACK packets will be silently discarded, however as
> +with all AVC denials they are audited in the audit log.
> +
> +Multi-homing Test
> +------------------
> +                      ------- Wireless Router -------
> +                     /                               \
> +                    /                                 \
> +                   /                                   \
> +             192.168.1.66                          192.168.1.64
> +                 /                                       \
> +           ----------  Ethernet         193.168.1.65 ----------
> +           | CLIENT | <----------------------------> | SERVER |
> +           ---------- 193.168.1.67                   ----------
> +        sctp_darn                                 sctp_darn
> +        -H 192.168.1.66                           -H 192.168.1.64
> +        -B 193.168.1.67                           -B 193.168.1.65
> +        -P 19000                                  -P 19001
> +        -c 192.168.1.64                           -l
> +        -c 193.168.1.65
> +        -p 19001
> +        -s
> +
> +Set Netlabel fallback peer labeling on Client and Server as follows:
> +    netlabelctl unlbl add interface:wlan0 address:192.168.1.0/24 \
> +        label:system_u:object_r:sctp_netlabel_peer_t:s0
> +    netlabelctl unlbl add interface:p2p1 address:193.168.1.0/24 \
> +        label:system_u:object_r:sctp_netlabel_peer_t:s0
> +
> +Then:
> +Send data from Client to Server - ok - saddr 192.168.1.66 daddr 192.168.1.64
> +Turn Server Wifi off (192.168.1.64)
> +Send data from Client to Server - ok - saddr 192.168.1.66 daddr 193.168.1.65
> +
> +tshark(1) may be used to monitor traffic on each interface, for example:
> +    tshark -O SCTP -P -x -i wlan0
> +    tshark -O SCTP -P -x -i p2p1
> +
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 623f90e..af62982 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -948,6 +948,23 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@level contains the protocol level to set options for.
>   *	@optname contains the name of the option to set.
>   *	Return 0 if permission is granted.
> + * @sk_setsockopt:
> + *	Check permissions before setting the options associated with sock @sk.
> + *	This is equivalent to @socket_setsockopt, except that it has the
> + *	option parameters, as it is intended to support permission checking
> + *	of options and their parameters within network services.
> + *	An example usage is in net/sctp/socket.c where
> + *	sctp_getsockopt_connectx3() and __sctp_setsockopt_connectx()
> + *	manage the @optval data into a certain state before @sk_setsockopt
> + *	is called for permission checks. This means that the code to
> + *	manage @optval does not need to be replicated in the security
> + *	module.
> + *	@sk contains the sock structure.
> + *	@level contains the protocol level to set options for.
> + *	@optname contains the name of the option to set.
> + *	@optval contains the value(s) to set (already copied from userspace).
> + *	@optlen contains the length of the value(s) to be set.
> + *	Return 0 if permission is granted.
>   * @socket_shutdown:
>   *	Checks permission before all or part of a connection on the socket
>   *	@sock is shut down.
> @@ -997,6 +1014,12 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	authorizations.
>   * @sock_graft:
>   *	Sets the socket's isec sid to the sock's sid.
> + * @sctp_assoc_request:
> + *	Update socket peer label if first association on @sk then check
> + *	whether association allowed.
> + *	@sk contains the sock structure.
> + *	@skb skbuff of association packet (INIT or INIT ACK) being queried.
> + *	Return 0 on success, error on failure.
>   * @inet_conn_request:
>   *	Sets the openreq's sid to socket's sid with MLS portion taken from peer sid.
>   * @inet_csk_clone:
> @@ -1666,6 +1689,8 @@ struct security_operations {
>  	int (*socket_getpeername) (struct socket *sock);
>  	int (*socket_getsockopt) (struct socket *sock, int level, int optname);
>  	int (*socket_setsockopt) (struct socket *sock, int level, int optname);
> +	int (*sk_setsockopt) (struct sock *sk, int level, int optname,
> +				    char *optval, int optlen);
>  	int (*socket_shutdown) (struct socket *sock, int how);
>  	int (*socket_sock_rcv_skb) (struct sock *sk, struct sk_buff *skb);
>  	int (*socket_getpeersec_stream) (struct socket *sock, char __user *optval, int __user *optlen, unsigned len);
> @@ -1675,6 +1700,7 @@ struct security_operations {
>  	void (*sk_clone_security) (const struct sock *sk, struct sock *newsk);
>  	void (*sk_getsecid) (struct sock *sk, u32 *secid);
>  	void (*sock_graft) (struct sock *sk, struct socket *parent);
> +	int (*sctp_assoc_request) (struct sock *sk, struct sk_buff *skb);
>  	int (*inet_conn_request) (struct sock *sk, struct sk_buff *skb,
>  				  struct request_sock *req);
>  	void (*inet_csk_clone) (struct sock *newsk, const struct request_sock *req);
> @@ -2650,6 +2676,8 @@ int security_socket_getsockname(struct socket *sock);
>  int security_socket_getpeername(struct socket *sock);
>  int security_socket_getsockopt(struct socket *sock, int level, int optname);
>  int security_socket_setsockopt(struct socket *sock, int level, int optname);
> +int security_sk_setsockopt(struct sock *sk, int level, int optname,
> +			    char *optval, int optlen);
>  int security_socket_shutdown(struct socket *sock, int how);
>  int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
>  int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
> @@ -2661,6 +2689,7 @@ void security_sk_clone(const struct sock *sk, struct sock *newsk);
>  void security_sk_classify_flow(struct sock *sk, struct flowi *fl);
>  void security_req_classify_flow(const struct request_sock *req, struct flowi *fl);
>  void security_sock_graft(struct sock*sk, struct socket *parent);
> +int security_sctp_assoc_request(struct sock *sk, struct sk_buff *skb);
>  int security_inet_conn_request(struct sock *sk,
>  			struct sk_buff *skb, struct request_sock *req);
>  void security_inet_csk_clone(struct sock *newsk,
> @@ -2767,6 +2796,13 @@ static inline int security_socket_setsockopt(struct socket *sock,
>  	return 0;
>  }
>  
> +static inline int security_sk_setsockopt(struct sock *sk, int level,
> +					    int optname, char *optval,
> +					    int optlen)
> +{
> +	return 0;
> +}
> +
>  static inline int security_socket_shutdown(struct socket *sock, int how)
>  {
>  	return 0;
> @@ -2813,6 +2849,12 @@ static inline void security_sock_graft(struct sock *sk, struct socket *parent)
>  {
>  }
>  
> +static inline int security_sctp_assoc_request(struct sock *sk,
> +			struct sk_buff *skb)
> +{
> +	return 0;
> +}
> +
>  static inline int security_inet_conn_request(struct sock *sk,
>  			struct sk_buff *skb, struct request_sock *req)
>  {
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 3ee27b7..0e7fb3d 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -315,6 +315,11 @@ sctp_disposition_t sctp_sf_do_5_1B_init(struct net *net,
>  	sctp_unrecognized_param_t *unk_param;
>  	int len;
>  
> +	/* Update socket peer label if first association then check
> +	 * whether association allowed. */
> +	if (security_sctp_assoc_request(ep->base.sk, chunk->skb))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	/* 6.10 Bundling
>  	 * An endpoint MUST NOT bundle INIT, INIT ACK or
>  	 * SHUTDOWN COMPLETE with any other chunks.
> @@ -508,6 +513,11 @@ sctp_disposition_t sctp_sf_do_5_1C_ack(struct net *net,
>  	struct sctp_chunk *err_chunk;
>  	struct sctp_packet *packet;
>  
> +	/* Update socket peer label if first association then check
> +	 * whether association allowed. */
> +	if (security_sctp_assoc_request(ep->base.sk, chunk->skb))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	if (!sctp_vtag_verify(chunk, asoc))
>  		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>  
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 634a2ab..d0e0593 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1012,6 +1012,12 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	/* Do the work. */
>  	switch (op) {
>  	case SCTP_BINDX_ADD_ADDR:
> +		/* Allow security module to validate bindx addresses. */
> +		err = security_sk_setsockopt(sk, SOL_SCTP,
> +			    SCTP_SOCKOPT_BINDX_ADD,
> +			    (char *)kaddrs, addrs_size);
> +		if (err)
> +			goto out;
>  		err = sctp_bindx_add(sk, kaddrs, addrcnt);
>  		if (err)
>  			goto out;
> @@ -1327,9 +1333,16 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
>  		err = -EFAULT;
>  	} else {
> +		/* Allow security module to validate connectx addresses. */
> +		err = security_sk_setsockopt(sk, SOL_SCTP,
> +			    SCTP_SOCKOPT_CONNECTX,
> +			   (char *)kaddrs, addrs_size);
> +		if (err)
> +			goto out_free;
>  		err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
>  	}
>  
> +out_free:
>  	kfree(kaddrs);
>  
>  	return err;
> @@ -7335,6 +7348,8 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  		newsk->sk_shutdown |= RCV_SHUTDOWN;
>  
>  	newsk->sk_state = SCTP_SS_ESTABLISHED;
> +	/* Ensure newsk has the same security attributes. */
> +	security_sk_clone(oldsk, newsk);
>  	release_sock(newsk);
>  }
>  
> diff --git a/security/capability.c b/security/capability.c
> index a74fde6..0272b05 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -643,6 +643,12 @@ static int cap_socket_setsockopt(struct socket *sock, int level, int optname)
>  	return 0;
>  }
>  
> +static int cap_sk_setsockopt(struct sock *sk, int level, int optname,
> +					    char *optval, int optlen)
> +{
> +	return 0;
> +}
> +
>  static int cap_socket_getsockopt(struct socket *sock, int level, int optname)
>  {
>  	return 0;
> @@ -692,6 +698,11 @@ static void cap_sock_graft(struct sock *sk, struct socket *parent)
>  {
>  }
>  
> +static int cap_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
> +{
> +	return 0;
> +}
> +
>  static int cap_inet_conn_request(struct sock *sk, struct sk_buff *skb,
>  				 struct request_sock *req)
>  {
> @@ -1084,6 +1095,7 @@ void __init security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, socket_getsockname);
>  	set_to_cap_if_null(ops, socket_getpeername);
>  	set_to_cap_if_null(ops, socket_setsockopt);
> +	set_to_cap_if_null(ops, sk_setsockopt);
>  	set_to_cap_if_null(ops, socket_getsockopt);
>  	set_to_cap_if_null(ops, socket_shutdown);
>  	set_to_cap_if_null(ops, socket_sock_rcv_skb);
> @@ -1094,6 +1106,7 @@ void __init security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, sk_clone_security);
>  	set_to_cap_if_null(ops, sk_getsecid);
>  	set_to_cap_if_null(ops, sock_graft);
> +	set_to_cap_if_null(ops, sctp_assoc_request);
>  	set_to_cap_if_null(ops, inet_conn_request);
>  	set_to_cap_if_null(ops, inet_csk_clone);
>  	set_to_cap_if_null(ops, inet_conn_established);
> diff --git a/security/security.c b/security/security.c
> index e41b1a8..a03ee03 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1207,6 +1207,13 @@ int security_socket_setsockopt(struct socket *sock, int level, int optname)
>  	return security_ops->socket_setsockopt(sock, level, optname);
>  }
>  
> +int security_sk_setsockopt(struct sock *sk, int level, int optname,
> +				    char *optval, int optlen)
> +{
> +	return security_ops->sk_setsockopt(sk, level, optname, optval, optlen);
> +}
> +EXPORT_SYMBOL(security_sk_setsockopt);
> +
>  int security_socket_shutdown(struct socket *sock, int how)
>  {
>  	return security_ops->socket_shutdown(sock, how);
> @@ -1264,6 +1271,12 @@ void security_sock_graft(struct sock *sk, struct socket *parent)
>  }
>  EXPORT_SYMBOL(security_sock_graft);
>  
> +int security_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
> +{
> +	return security_ops->sctp_assoc_request(sk, skb);
> +}
> +EXPORT_SYMBOL(security_sctp_assoc_request);
> +
>  int security_inet_conn_request(struct sock *sk,
>  			struct sk_buff *skb, struct request_sock *req)
>  {
> diff --git a/security/selinux/Makefile b/security/selinux/Makefile
> index ad5cd76..a450c85 100644
> --- a/security/selinux/Makefile
> +++ b/security/selinux/Makefile
> @@ -13,6 +13,8 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
>  
>  selinux-$(CONFIG_NETLABEL) += netlabel.o
>  
> +selinux-$(subst m,y,$(CONFIG_IP_SCTP)) += sctp.o
> +
>  ccflags-y := -Isecurity/selinux -Isecurity/selinux/include
>  
>  $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e03bad5..1440d9a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -66,6 +66,7 @@
>  #include <linux/tcp.h>
>  #include <linux/udp.h>
>  #include <linux/dccp.h>
> +#include <linux/sctp.h>
>  #include <linux/quota.h>
>  #include <linux/un.h>		/* for Unix socket types */
>  #include <net/af_unix.h>	/* for Unix socket types */
> @@ -94,6 +95,7 @@
>  #include "netlabel.h"
>  #include "audit.h"
>  #include "avc_ss.h"
> +#include "sctp.h"
>  
>  extern struct security_operations *security_ops;
>  
> @@ -1185,8 +1187,11 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
>  	case PF_INET6:
>  		switch (type) {
>  		case SOCK_STREAM:
> +		case SOCK_SEQPACKET:
>  			if (default_protocol_stream(protocol))
>  				return SECCLASS_TCP_SOCKET;
> +			else if (protocol = IPPROTO_SCTP)
> +				return SECCLASS_SCTP_SOCKET;
>  			else
>  				return SECCLASS_RAWIP_SOCKET;
>  		case SOCK_DGRAM:
> @@ -3726,6 +3731,23 @@ static int selinux_parse_skb_ipv4(struct sk_buff *skb,
>  		break;
>  	}
>  
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> +	case IPPROTO_SCTP: {
> +		struct sctphdr _sctph, *sh;
> +
> +		if (ntohs(ih->frag_off) & IP_OFFSET)
> +			break;
> +
> +		offset += ihlen;
> +		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
> +		if (sh = NULL)
> +			break;
> +
> +		ad->u.net->sport = sh->source;
> +		ad->u.net->dport = sh->dest;
> +		break;
> +	}
> +#endif
>  	default:
>  		break;
>  	}
> @@ -3799,6 +3821,19 @@ static int selinux_parse_skb_ipv6(struct sk_buff *skb,
>  		break;
>  	}
>  
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> +	case IPPROTO_SCTP: {
> +		struct sctphdr _sctph, *sh;
> +
> +		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
> +		if (sh = NULL)
> +			break;
> +
> +		ad->u.net->sport = sh->source;
> +		ad->u.net->dport = sh->dest;
> +		break;
> +	}
> +#endif
>  	/* includes fragments */
>  	default:
>  		break;
> @@ -3859,7 +3894,7 @@ okay:
>   * Description:
>   * Check the various different forms of network peer labeling and determine
>   * the peer label/SID for the packet; most of the magic actually occurs in
> - * the security server function security_net_peersid_cmp().  The function
> + * the security server function security_net_peersid_resolve().  The function
>   * returns zero if the value in @sid is valid (although it may be SECSID_NULL)
>   * or -EACCES if @sid is invalid due to inconsistencies with the different
>   * peer labels.
> @@ -3928,7 +3963,7 @@ static int socket_sockcreate_sid(const struct task_security_struct *tsec,
>  				       socksid);
>  }
>  
> -static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
> +int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
>  {
>  	struct sk_security_struct *sksec = sk->sk_security;
>  	struct common_audit_data ad;
> @@ -3998,7 +4033,8 @@ static int selinux_socket_post_create(struct socket *sock, int family,
>     Need to determine whether we should perform a name_bind
>     permission check between the socket and the port number. */
>  
> -static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
> +int selinux_socket_bind(struct socket *sock, struct sockaddr *address,
> +							    int addrlen)
>  {
>  	struct sock *sk = sock->sk;
>  	u16 family;
> @@ -4010,8 +4046,8 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
>  
>  	/*
>  	 * If PF_INET or PF_INET6, check name_bind permission for the port.
> -	 * Multiple address binding for SCTP is not supported yet: we just
> -	 * check the first address now.
> +	 * Multiple address binding for SCTP is supported via
> +	 * selinux_sctp_validate_sockopt().
>  	 */
>  	family = sk->sk_family;
>  	if (family = PF_INET || family = PF_INET6) {
> @@ -4069,6 +4105,10 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
>  			node_perm = DCCP_SOCKET__NODE_BIND;
>  			break;
>  
> +		case SECCLASS_SCTP_SOCKET:
> +			node_perm = SCTP_SOCKET__NODE_BIND;
> +			break;
> +
>  		default:
>  			node_perm = RAWIP_SOCKET__NODE_BIND;
>  			break;
> @@ -4097,7 +4137,8 @@ out:
>  	return err;
>  }
>  
> -static int selinux_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
> +int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
> +							    int addrlen)
>  {
>  	struct sock *sk = sock->sk;
>  	struct sk_security_struct *sksec = sk->sk_security;
> @@ -4108,10 +4149,12 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
>  		return err;
>  
>  	/*
> -	 * If a TCP or DCCP socket, check name_connect permission for the port.
> +	 * If a TCP, DCCP or SCTP socket, check name_connect permission
> +	 * for the port.
>  	 */
>  	if (sksec->sclass = SECCLASS_TCP_SOCKET ||
> -	    sksec->sclass = SECCLASS_DCCP_SOCKET) {
> +	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_SCTP_SOCKET) {
>  		struct common_audit_data ad;
>  		struct lsm_network_audit net = {0,};
>  		struct sockaddr_in *addr4 = NULL;
> @@ -4135,8 +4178,12 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
>  		if (err)
>  			goto out;
>  
> -		perm = (sksec->sclass = SECCLASS_TCP_SOCKET) ?
> -		       TCP_SOCKET__NAME_CONNECT : DCCP_SOCKET__NAME_CONNECT;
> +		if (sksec->sclass = SECCLASS_TCP_SOCKET)
> +			perm = TCP_SOCKET__NAME_CONNECT;
> +		else if (sksec->sclass = SECCLASS_DCCP_SOCKET)
> +			perm = DCCP_SOCKET__NAME_CONNECT;
> +		else if (sksec->sclass = SECCLASS_SCTP_SOCKET)
> +			perm = SCTP_SOCKET__NAME_CONNECT;
>  
>  		ad.type = LSM_AUDIT_DATA_NET;
>  		ad.u.net = &net;
> @@ -4208,13 +4255,39 @@ static int selinux_socket_setsockopt(struct socket *sock, int level, int optname
>  	if (err)
>  		return err;
>  
> +	/* SCTP options that do not require handling by SCTP. */
> +	err = selinux_sctp_validate_sockopt(sock->sk, level, optname, NULL, 0);
> +	if (err)
> +		return err;
> +
>  	return selinux_netlbl_socket_setsockopt(sock, level, optname);
>  }
>  
> +static int selinux_sk_setsockopt(struct sock *sk, int level, int optname,
> +					    char *optval, int optlen)
> +{
> +	int err;
> +
> +	err = sock_has_perm(current, sk, SOCKET__SETOPT);
> +	if (err)
> +		return err;
> +
> +	/* SCTP options that require handling by SCTP first. */
> +	return selinux_sctp_validate_sockopt(sk, level, optname, optval,
> +							    optlen);
> +}
> +
>  static int selinux_socket_getsockopt(struct socket *sock, int level,
>  				     int optname)
>  {
> -	return sock_has_perm(current, sock->sk, SOCKET__GETOPT);
> +	int err;
> +
> +	err = sock_has_perm(current, sock->sk, SOCKET__GETOPT);
> +	if (err)
> +		return err;
> +
> +	return selinux_sctp_validate_sockopt(sock->sk, level, optname,
> +					    NULL, 0);
>  }
>  
>  static int selinux_socket_shutdown(struct socket *sock, int how)
> @@ -4407,7 +4480,9 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
>  	u32 peer_sid = SECSID_NULL;
>  
>  	if (sksec->sclass = SECCLASS_UNIX_STREAM_SOCKET ||
> -	    sksec->sclass = SECCLASS_TCP_SOCKET)
> +	    sksec->sclass = SECCLASS_TCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_SCTP_SOCKET)
>  		peer_sid = sksec->peer_sid;
>  	if (peer_sid = SECSID_NULL)
>  		return -ENOPROTOOPT;
> @@ -4516,6 +4591,35 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
>  	sksec->sclass = isec->sclass;
>  }
>  
> +static int selinux_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct sk_security_struct *sksec = sk->sk_security;
> +	struct common_audit_data ad;
> +	struct lsm_network_audit net = {0,};
> +	u8 peerlbl_active;
> +	int err;
> +
> +	peerlbl_active = selinux_peerlbl_enabled();
> +
> +	if (sksec->peer_sid = SECINITSID_UNLABELED && peerlbl_active) {
> +		/* Here because this is the first association on this
> +		 * socket that is always unlabeled, therefore set
> +		 * sksec->peer_sid to new peer ctx. For further info see:
> +		 *    Documentation/security/SELinux-sctp.txt */
> +		err = selinux_skb_peerlbl_sid(skb, sk->sk_family,
> +				    &sksec->peer_sid);
> +		if (err)
> +			return err;
> +	}
> +
> +	ad.type = LSM_AUDIT_DATA_NET;
> +	ad.u.net = &net;
> +	ad.u.net->sk = sk;
> +
> +	return avc_has_perm(sksec->sid, sksec->peer_sid, sksec->sclass,
> +				    SCTP_SOCKET__ASSOCIATION, &ad);
> +}
> +
>  static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
>  				     struct request_sock *req)
>  {
> @@ -4805,7 +4909,10 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
>  	if (sk) {
>  		struct sk_security_struct *sksec;
>  
> -		if (sk->sk_state = TCP_LISTEN)
> +		/* Note that TCP_LISTEN equates to SCTP_SS_LISTENING
> +		 * and DCCP_LISTEN socket states so also check protocol. */
> +		if (sk->sk_state = TCP_LISTEN &&
> +		    sk->sk_protocol = IPPROTO_TCP)
>  			/* if the socket is the listening state then this
>  			 * packet is a SYN-ACK packet which means it needs to
>  			 * be labeled based on the connection/request_sock and
> @@ -4910,9 +5017,12 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
>  	 *       TCP listening state we cannot wait until the XFRM processing
>  	 *       is done as we will miss out on the SA label if we do;
>  	 *       unfortunately, this means more work, but it is only once per
> -	 *       connection. */
> +	 *       connection.
> +	 * NOTE: that TCP_LISTEN equates to SCTP_SS_LISTENING and DCCP_LISTEN
> +	 * socket states so also check protocol. */
>  	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL &&
> -	    !(sk != NULL && sk->sk_state = TCP_LISTEN))
> +	    !(sk != NULL && sk->sk_state = TCP_LISTEN &&
> +	    sk->sk_protocol = IPPROTO_TCP))
>  		return NF_ACCEPT;
>  #endif
>  
> @@ -4929,7 +5039,10 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
>  			secmark_perm = PACKET__SEND;
>  			peer_sid = SECINITSID_KERNEL;
>  		}
> -	} else if (sk->sk_state = TCP_LISTEN) {
> +	/* Note that TCP_LISTEN equates to SCTP_SS_LISTENING and DCCP_LISTEN
> +	 * socket states so also check protocol. */
> +	} else if (sk->sk_state = TCP_LISTEN  &&
> +	    sk->sk_protocol = IPPROTO_TCP) {
>  		/* Locally generated packet but the associated socket is in the
>  		 * listening state which means this is a SYN-ACK packet.  In
>  		 * this particular case the correct security label is assigned
> @@ -5924,6 +6037,7 @@ static struct security_operations selinux_ops = {
>  	.socket_getpeername =		selinux_socket_getpeername,
>  	.socket_getsockopt =		selinux_socket_getsockopt,
>  	.socket_setsockopt =		selinux_socket_setsockopt,
> +	.sk_setsockopt =		selinux_sk_setsockopt,
>  	.socket_shutdown =		selinux_socket_shutdown,
>  	.socket_sock_rcv_skb =		selinux_socket_sock_rcv_skb,
>  	.socket_getpeersec_stream =	selinux_socket_getpeersec_stream,
> @@ -5933,6 +6047,7 @@ static struct security_operations selinux_ops = {
>  	.sk_clone_security =		selinux_sk_clone_security,
>  	.sk_getsecid =			selinux_sk_getsecid,
>  	.sock_graft =			selinux_sock_graft,
> +	.sctp_assoc_request =		selinux_sctp_assoc_request,
>  	.inet_conn_request =		selinux_inet_conn_request,
>  	.inet_csk_clone =		selinux_inet_csk_clone,
>  	.inet_conn_established =	selinux_inet_conn_established,
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index be491a7..09797ee 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -151,5 +151,9 @@ struct security_class_mapping secclass_map[] = {
>  	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
>  	{ "tun_socket",
>  	  { COMMON_SOCK_PERMS, "attach_queue", NULL } },
> +	{ "sctp_socket",
> +	  { COMMON_SOCK_PERMS, "node_bind", "name_connect", "association",
> +	    "bindx_add", "bindx_rem", "connectx", "peeloff", "set_addr",
> +	    "set_params", NULL } },
>  	{ NULL }
>    };
> diff --git a/security/selinux/include/sctp.h b/security/selinux/include/sctp.h
> new file mode 100644
> index 0000000..81dd469
> --- /dev/null
> +++ b/security/selinux/include/sctp.h
> @@ -0,0 +1,52 @@
> +/*
> + * SELinux SCTP Support
> + *
> + * Provides security checks for the SCTP protocol.
> + *
> + * Author: Richard Haines <richard_c_haines@btinternet.com>
> + *
> + */
> +
> +/*
> + * This program is free software;  you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY;  without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + * the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program;  if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +
> +#ifndef _SELINUX_SCTP_H_
> +#define _SELINUX_SCTP_H_
> +
> +#include <linux/types.h>
> +#include <linux/net.h>
> +#include <net/sock.h>
> +#include "objsec.h"
> +
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> +int selinux_sctp_validate_sockopt(struct sock *sk,
> +				    int level,
> +				    int optname,
> +				    char *optval,
> +				    int optlen);
> +#else
> +static inline int selinux_sctp_validate_sockopt(struct sock *sk,
> +				    int level,
> +				    int optname,
> +				    char *optval,
> +				    int optlen)
> +{
> +	return 0;
> +}
> +#endif  /* CONFIG_IP_SCTP */
> +
> +#endif
> diff --git a/security/selinux/include/sctp_private.h b/security/selinux/include/sctp_private.h
> new file mode 100644
> index 0000000..f393f6f
> --- /dev/null
> +++ b/security/selinux/include/sctp_private.h
> @@ -0,0 +1,51 @@
> +/*
> + * SELinux SCTP Support
> + *
> + * Provides security checks for the SCTP protocol.
> + *
> + * Author: Richard Haines <richard_c_haines@btinternet.com>
> + *
> + */
> +
> +/*
> + * This program is free software;  you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY;  without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + * the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program;  if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include <linux/net.h>
> +#include <net/sock.h>
> +#include <linux/sctp.h>
> +#include <uapi/linux/sctp.h>	/* For bindx setsocket option checks */
> +#include <net/ip.h>
> +#include <linux/skbuff.h>
> +
> +#include "security.h"
> +#include "avc.h"
> +#include "objsec.h"
> +
> +extern int sock_has_perm(struct task_struct *task,
> +				    struct sock *sk, u32 perms);
> +
> +extern int selinux_socket_bind(struct socket *sock,
> +				    struct sockaddr *address,
> +					    int addrlen);
> +
> +extern int selinux_socket_connect(struct socket *sock,
> +				    struct sockaddr *address,
> +				    int addrlen);
> +
> diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
> index 0364120..a6c6df1 100644
> --- a/security/selinux/netlabel.c
> +++ b/security/selinux/netlabel.c
> @@ -396,6 +396,9 @@ int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
>  	case SECCLASS_TCP_SOCKET:
>  		perm = TCP_SOCKET__RECVFROM;
>  		break;
> +	case SECCLASS_SCTP_SOCKET:
> +		perm = SCTP_SOCKET__RECVFROM;
> +		break;
>  	default:
>  		perm = RAWIP_SOCKET__RECVFROM;
>  	}
> diff --git a/security/selinux/sctp.c b/security/selinux/sctp.c
> new file mode 100644
> index 0000000..41c646d
> --- /dev/null
> +++ b/security/selinux/sctp.c
> @@ -0,0 +1,185 @@
> +/*
> + * SELinux SCTP Support
> + *
> + * Provides security checks for the SCTP protocol.
> + *
> + * Author: Richard Haines <richard_c_haines@btinternet.com>
> + *
> + */
> +
> +/*
> + * This program is free software;  you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY;  without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + * the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program;  if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +
> +#include "sctp_private.h"	/* #include files + extern functions. */
> +
> +/**
> + * selinux_sctp_validate_sockopt - Check get/setsockopt values.
> + * @sk: the socket
> + * @level: contains the protocol level to validate
> + * @optname: contains the name of the option to validate
> + * @optval: contains the value(s) to set
> + * @optlen: contains the length of the value(s) to be set
> + *
> + * Description:
> + * Check whether SCTP socket options are allowed or not. Returns zero on
> + * success, negative values on failure.
> + *
> + * Supports the following socket options:
> + *
> + *    SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> + *    associated after (optionally) calling bind(3).
> + *    sctp_bindx(3) - adds or removes a set of bind addresses on a socket.
> + *
> + *    SCTP_SOCKOPT_CONNECTX* - Allows the allocation of multiple
> + *    addresses for reaching a peer (multi-homed).
> + *    sctp_connectx(3) - initiate a connection on an SCTP socket using
> + *    multiple destination addresses. May also return an association id.
> + *
> + *   Together they form SCTP associations and will be passed over the
> + *   link to inform peer of any changes. As these two options can support
> + *   multiple addresses, each address is checked via selinux_socket_bind() or
> + *   selinux_socket_connect() to determine whether they have the correct
> + *   permissions:
> + *     bindx_add: bind, name_bind, node_bind + node SID + port SID via the
> + *                (portcon sctp port ctx) policy statement.
> + *     connectx:  connect, name_connect + port SID via the
> + *                (portcon sctp port ctx) policy statement.
> + *
> + *    SCTP_SOCKOPT_BINDX_REM - As the addresses would have already been
> + *    allowed, only the bindx_rem permission is checked.
> + *
> + *    SCTP_PEER_ADDR_PARAMS - Alter heartbeats and address max
> + *    retransmissions.
> + *    SCTP_PEER_ADDR_THLDS - Alter the thresholds.
> + *  These require the set_params permission.
> + *
> + *    SCTP_PRIMARY_ADDR - Set local primary address.
> + *    SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
> + *    association primary.
> + *  These require the set_addr permission.
> + *
> + *    SCTP_SOCKOPT_PEELOFF - Branch off an association into a new socket
> + *    that will be a one-to-one style socket. As SELinux already handles
> + *    the creation of new sockets, only the peeloff permission is checked.
> + *
> + */
> +int selinux_sctp_validate_sockopt(struct sock *sk, int level, int optname,
> +					    char *optval, int optlen)
> +{
> +	int err, addrlen;
> +	void *addr_buf;
> +	struct sockaddr *address;
> +	struct socket *sock;
> +	int walk_size = 0;
> +
> +	/* This handles SCTP specific options. Note that SCTP has the optval
> +	 * in kernel space already therefore no copy is required. */
> +	if (level = SOL_SCTP) {
> +		switch (optname) {
> +		/* Note that for SCTP_SOCKOPT_BINDX_ADD and
> +		 * SCTP_SOCKOPT_CONNECTX SCTP has copied the optval to kernel
> +		 * space already therefore no copy is required. See
> +		 * net/sctp/socket.c security_sk_setsockopt() calls. */
> +		case SCTP_SOCKOPT_BINDX_ADD:
> +		case SCTP_SOCKOPT_CONNECTX:
> +			err = sock_has_perm(current, sk,
> +			    (optname = SCTP_SOCKOPT_BINDX_ADD ?
> +			    SCTP_SOCKET__BINDX_ADD :
> +			    SCTP_SOCKOPT_CONNECTX));
> +			if (err)
> +				return err;
> +
> +			sock = sk->sk_socket;
> +			addr_buf = optval;
> +			/* Process list - may contain IPv4 or IPv6 addr's */
> +			while (walk_size < optlen) {
> +				address = addr_buf;
> +
> +				switch (address->sa_family) {
> +				case PF_INET:
> +					addrlen = sizeof(struct sockaddr_in);
> +					break;
> +				case PF_INET6:
> +					addrlen = sizeof(struct sockaddr_in6);
> +					break;
> +				default:
> +					return -EINVAL;
> +				}
> +
> +				err = -EINVAL;
> +				if (optname = SCTP_SOCKOPT_BINDX_ADD) {
> +					err = selinux_socket_bind(sock,
> +						    address, addrlen);
> +				} else if (optname = SCTP_SOCKOPT_CONNECTX) {
> +					err = selinux_socket_connect(sock,
> +						    address, addrlen);
> +				}
> +				if (err)
> +					return err;
> +
> +				addr_buf += addrlen;
> +				walk_size += addrlen;
> +			}
> +			break;
> +
> +		case SCTP_SOCKOPT_BINDX_REM:
> +			/* The addresses have been checked as they were
> +			 * added, so just see if allowed to be removed. */
> +			err = sock_has_perm(current, sk,
> +			    SCTP_SOCKET__BINDX_REM);
> +			if (err)
> +				return err;
> +			break;
> +
> +		case SCTP_SOCKOPT_PEELOFF:
> +			err = sock_has_perm(current, sk,
> +			    SCTP_SOCKET__PEELOFF);
> +			if (err)
> +				return err;
> +			break;
> +
> +		default:
> +			break;
> +		}
> +	} else if (level = IPPROTO_SCTP) {
> +		switch (optname) {
> +		/* Alter heartbeats and address max retransmissions. */
> +		case SCTP_PEER_ADDR_PARAMS:
> +		/* Alter the thresholds. */
> +		case SCTP_PEER_ADDR_THLDS:
> +			err = sock_has_perm(current, sk,
> +			    SCTP_SOCKET__SET_PARAMS);
> +			if (err)
> +				return err;
> +			break;
> +
> +		/* Set local primary address. */
> +		case SCTP_PRIMARY_ADDR:
> +		/* Request peer sets address as association primary. */
> +		case SCTP_SET_PEER_PRIMARY_ADDR:
> +			err = sock_has_perm(current, sk,
> +			    SCTP_SOCKET__SET_ADDR);
> +			if (err)
> +				return err;
> +			break;
> +
> +		default:
> +			break;
> +		}
> +	}
> +	return 0;
> +}

