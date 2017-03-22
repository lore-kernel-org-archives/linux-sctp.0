From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 22 Mar 2017 10:11:53 +0000
Subject: Re: [RFC v2 PATCH 2/2] kernel: Add SELinux SCTP protocol support
Message-Id: <1490177513.27019.3.camel@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170222170359.5433-1-richard_c_haines@btinternet.com>
	<1488487540.19896.108.camel@tycho.nsa.gov>
In-Reply-To: <1488487540.19896.108.camel@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-security-module@vger.kernel.org

On Thu, 2017-03-02 at 15:45 -0500, Stephen Smalley wrote:
> On Wed, 2017-02-22 at 17:03 +0000, Richard Haines wrote:
> > Add SELinux support for the SCTP protocol. The SELinux-sctp.txt
> > document
> > describes how the patch has been implemented.
> > 
> > Patches to assist the testing of this kernel patch are:
> > 1) Support new SCTP portcon statement used by SCTP tests in the
> > selinux-testsuite [1].
> > 2) Add SCTP tests to the selinux-testsuite [2].
> > 
> > Built and tested on Fedora 25 with linux-4.9.9 kernel.
> 
> Need to re-base and test on a suitable upstream tree (maybe security
> next or selinux next).  Since the extended socket class policy
> capability has been merged, you can leverage it and drop the
> duplicated
> portions.
> 
Okay I'll find a suitable kernel to build the next patch set

> > 
> > [1] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-
> > Ad
> > d-support-for-the-SCTP-portcon-keyword.patch
> > [2] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-
> > testsuite-Add-SCTP-test-support.patch
> 
> I wouldn't include URLs for these userspace patches in the patch
> description or in-tree documentation; you can note them in your cover
> letter posting as an aid to testing but they shouldn't be part of the
> permanent history since they will presumably be upstreamed too.
> 
I'll add any of these to the cover letter.

> > 
> > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > ---
> >  Documentation/security/SELinux-sctp.txt | 178
> > ++++++++++++++++++++++++++
> >  include/net/sctp/structs.h              |   7 ++
> >  net/sctp/sm_make_chunk.c                |  12 ++
> >  net/sctp/sm_statefuns.c                 |  20 +++
> >  net/sctp/socket.c                       |  42 ++++++-
> 
> I'd either move the net/sctp changes into the first patch that
> defines
> the LSM hooks or move them into their own separate patch between
> these
> two patches.
I'll split these into their own patches (looks like I'll end up with
netlabel patches as well to get CIPSO/CALIPSO working fully !!)

> 
> >  security/selinux/hooks.c                | 213
> > ++++++++++++++++++++++++++++++--
> >  security/selinux/include/classmap.h     |   3 +
> >  7 files changed, 466 insertions(+), 9 deletions(-)
> >  create mode 100644 Documentation/security/SELinux-sctp.txt
> > 
> > diff --git a/Documentation/security/SELinux-sctp.txt
> > b/Documentation/security/SELinux-sctp.txt
> > new file mode 100644
> > index 0000000..ada666f
> > --- /dev/null
> > +++ b/Documentation/security/SELinux-sctp.txt
> > @@ -0,0 +1,178 @@
> > +                               SCTP SELinux Support
> > +                              ===========
> > +
> > +Testing - selinux-testsuite
> > +==============
> > +There is a patch available that adds SCTP/SELinux tests to the
> > +selinux-testsuite. This is available from:
> > +
> > +http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-tes
> > ts
> > uite-Add-SCTP-test-support.patch
> > +
> > +These tests require libsepol to support the new sctp portcon
> > statement.
> > +A patch is available from:
> > +
> > +http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-Add
> > -
> > support-for-the-SCTP-portcon-keyword.patch
> 
> Ditto here; I wouldn't include these patch URLs in the in-tree
> documentation since the patches should get upstreamed.
> 
> > +
> > +Before running these tests, read the selinux-testsuite/README.sctp
> > as it is
> > +also possible to run the lksctp-tools/src/func_tests that are
> > available from:
> > +
> > +https://github.com/sctp/lksctp-tools
> > +
> > +
> > +Security Hooks
> > +=======> > +
> > +The Documentation/security/LSM-sctp.txt document describes how the
> > following
> > +sctp security hooks are utilised:
> > +    security_sctp_assoc_request()
> > +    security_sctp_accept_conn()
> > +    security_sctp_sk_clone()
> > +    security_sctp_addr_list()
> > +
> > +
> > +Policy Statements
> > +=========
> > +A new object class "sctp_socket" has been introduced with the
> > following SCTP
> > +specific permissions: association bindx_add connectx
> > +
> > +The permissions are explained in the sections below.
> > +
> > +Kernel policy language
> > +-----------------------
> > +class sctp_socket
> > +class sctp_socket inherits socket { node_bind name_connect
> > association
> > +                                    bindx_add connectx }
> > +
> > +CIL policy language
> > +--------------------
> > +(classcommon sctp_socket socket)
> > +(class sctp_socket (node_bind name_connect association bindx_add
> > connectx))
> > +(classorder (unordered sctp_socket))
> > +
> > +If the SELinux userspace tools have been updated, then the portcon
> > statement
> > +may be used as shown in the following example:
> > +    (portcon sctp (1024 1035) (system_u object_r sctp_port_t ((s0)
> > (s0))))
> 
> Not a strong objection, but not sure if CIL documentation belongs in
> the kernel tree.
I'll stick to kernel language statements

> 
> <snip>
> > +
> > +SCTP Peer Labeling and Permission Checks
> > +====================> > +An SCTP socket will only have one peer label assigned to it. This
> > will be
> > +assigned during the establishment of the first association. Once
> > the
> > peer
> > +label has been assigned, the "association" permission will be
> > checked as
> > +follows:
> > +
> > +       allow socket_t peer_t : sctp_socket { association };
> > +
> > +This allows policy to decide whether to allow or deny associations
> > from peers,
> > +as there can be multiple associations on a single socket. These
> > associations
> > +could come from any of the policy allowed peers, however it could
> > be
> > that
> > +these are required by other services but sctp associations are not
> > allowed
> > +from all of them.
> 
> I'm still confused by this check.  We should already be performing a
> peer recv check between the socket label and the peer label, so we
> don't need to duplicate that check.  What would make sense would be
> some kind of permission check between the peer label from the first
> association, which is the one you save and return to userspace for
> SO_PEERSEC, and the peer label of any subsequent associations
> established on the socket.  That would allow policy to prohibit or
> restrict mixing of associations with different peer labels on the
> same
> socket (since effectively that permits impersonation of another peer
> label to userspace components).  But instead you are always checking
> between the socket label and the saved peer label from the first
> association.  So you'll just keep repeating the same permission check
> for every association.
See comment below.

> 
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 7f4387f..c0be892 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> 
> <snip>
> > @@ -4827,6 +4879,149 @@ static void selinux_sock_graft(struct sock
> > *sk, struct socket *parent)
> >  	sksec->sclass = isec->sclass;
> >  }
> >  
> > +static int selinux_sctp_assoc_request(struct sock *sk, struct
> > sk_buff *skb)
> > +{
> > +	struct sk_security_struct *sksec = sk->sk_security;
> > +	struct common_audit_data ad;
> > +	struct lsm_network_audit net = {0,};
> > +	u8 peerlbl_active;
> > +	int err;
> > +
> > +	peerlbl_active = selinux_peerlbl_enabled();
> > +
> > +	if (sksec->peer_sid = SECINITSID_UNLABELED &&
> > peerlbl_active) {
> > +		/* Here because this is the first association on
> > this
> > +		 * socket that is always unlabeled, therefore set
> > +		 * sksec->peer_sid to new peer ctx. For further
> > info
> > see:
> > +		 * Documentation/security/SELinux-sctp.txt
> > +		 */
> > +		err = selinux_skb_peerlbl_sid(skb, sk->sk_family,
> > +					      &sksec->peer_sid);
> > +		if (err)
> > +			return err;
> > +	}
> > +
> > +	ad.type = LSM_AUDIT_DATA_NET;
> > +	ad.u.net = &net;
> > +	ad.u.net->sk = sk;
> > +
> > +	err = avc_has_perm(sksec->sid, sksec->peer_sid, sksec-
> > > sclass,
> > 
> > +			   SCTP_SOCKET__ASSOCIATION, &ad);
> 
> As above, you'll end up performing the same permission check
> repeatedly
> here for every association, even when the association itself would
> have
> a different peer label.  And this permission check seems to be no
> different than the peer recv check (same SID arguments).  What would
> make sense is something like:
> 
> 	u32 peer_sid = SECINITSID_UNLABELED;
> 	if (peerlbl_active) {
> 		err = selinux_skb_peerlbl_sid(skb, sk->sk_family,
> &peer_sid);
> 		if (err)
> 			return err;
> 	}
> 	if (sksec->peer_sid = SECINITSID_UNLABELED)
> 		sksec->peer_sid = peer_sid;
> 	else if (sksec->peer_sid != peer_sid) {
> 		err = avc_has_perm(sksec->peer_sid, peer_sid, sksec-
> >sclass,
> 				SCTP_SOCKET_ASSOCIATION, &ad);
> 		if (err)
> 			return err;
> 	}
> 	return 0;
> 
> This would allow preventing multiple associations with different peer
> labels, or controlling their inter-relationships.  You don't need a
> socket-peer check here; that is already covered by the peer recv
> check.
> 

I've now changed this to emulate your suggestion. However instead of
just setting peer_sid to first association I've added an avc check
because I have a case where the packet label was
"deny_assoc_sctp_peer_t" and allowed by peer recv, however this was not
in my "sctp_assoc_peers" attribute list. Checking with:
(allow sctp_assoc_peers self (sctp_socket (association)))
would have denied this as the first association.
Does this seem reasonable ???

> 		
> > +	return err;
> > +}
> > +
> > +static int selinux_sctp_accept_conn(struct sctp_endpoint *ep,
> > +				    struct sk_buff *skb)
> > +{
> > +	struct sk_security_struct *sksec = ep->base.sk-
> > >sk_security;
> > +	int err;
> > +	u32 connsid;
> > +	u32 peersid;
> > +
> > +	/* Have COOKIE ECHO so compute the MLS component for the
> > connection
> > +	 * and store the information in ep. This will only be used
> > by
> > +	 * TCP/peeloff connections as they cause a new socket to
> > be
> > generated.
> 
> Not sure why you say TCP above.  And won't this be true of accept()'d
> sockets too in addition to peeloff ones?
Changed this to read "This will only be used by SCTP TCP type sockets
and peeled off connections"

> 
> > +	 * selinux_sctp_sk_clone() will then plug this into the
> > new
> > socket
> > +	 * as described in Documentation/security/LSM-sctp.txt
> > +	 */
> > +	err = selinux_skb_peerlbl_sid(skb, ep->base.sk->sk_family,
> > &peersid);
> > +	if (err)
> > +		return err;
> > +
> > +	err = selinux_conn_sid(sksec->sid, peersid, &connsid);
> > +	if (err)
> > +		return err;
> > +
> > +	ep->secid = connsid;
> > +	ep->peer_secid = peersid;
> > +
> > +	return 0;
> > +}
> > +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
