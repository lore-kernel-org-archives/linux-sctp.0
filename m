From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 14 Nov 2017 13:41:54 +0000
Subject: Re: [RFC PATCH 5/5] selinux: Add SCTP support
Message-Id: <1510666914.19398.2.camel@tycho.nsa.gov>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171017135953.4419-1-richard_c_haines@btinternet.com>
	<CAHC9VhShAjQiw-P5vvuULbEZJ7KYHch5ZsnRk=d9vP5kyDvYzQ@mail.gmail.com>
	<1510610721.3652.8.camel@btinternet.com>
	<CAHC9VhRg9xS=ustdcORVPsb9H18nMEq6A99Y3KyOm2sm6Mo5xg@mail.gmail.com>
In-Reply-To: <CAHC9VhRg9xS=ustdcORVPsb9H18nMEq6A99Y3KyOm2sm6Mo5xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-security-module@vger.kernel.org

On Mon, 2017-11-13 at 17:40 -0500, Paul Moore wrote:
> On Mon, Nov 13, 2017 at 5:05 PM, Richard Haines
> <richard_c_haines@btinternet.com> wrote:
> > On Mon, 2017-11-06 at 19:09 -0500, Paul Moore wrote:
> > > On Tue, Oct 17, 2017 at 9:59 AM, Richard Haines
> > > <richard_c_haines@btinternet.com> wrote:
> > > > The SELinux SCTP implementation is explained in:
> > > > Documentation/security/SELinux-sctp.txt
> > > > 
> > > > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > > > ---
> > > >  Documentation/security/SELinux-sctp.txt | 108 +++++++++++++
> > > >  security/selinux/hooks.c                | 268
> > > > ++++++++++++++++++++++++++++++--
> > > >  security/selinux/include/classmap.h     |   3 +-
> > > >  security/selinux/include/netlabel.h     |   9 +-
> > > >  security/selinux/include/objsec.h       |   5 +
> > > >  security/selinux/netlabel.c             |  52 ++++++-
> > > >  6 files changed, 427 insertions(+), 18 deletions(-)
> > > >  create mode 100644 Documentation/security/SELinux-sctp.txt
> 
> ...
> 
> > > > +Policy Statements
> > > > +=========
> > > > +The following class and permissions to support SCTP are
> > > > available
> > > > within the
> > > > +kernel:
> > > > +    class sctp_socket inherits socket { node_bind }
> > > > +
> > > > +whenever the following policy capability is enabled:
> > > > +    policycap extended_socket_class;
> > > > +
> > > > +The SELinux SCTP support adds the additional permissions that
> > > > are
> > > > explained
> > > > +in the sections below:
> > > > +    association bindx connectx
> > > 
> > > Is the distinction between bind and bindx significant?  The same
> > > question applies to connect/connectx.  I think we can probably
> > > just
> > > reuse bind and connect in these cases.
> > 
> > This has been discussed before with Marcelo and keeping
> > bindx/connectx
> > is a useful distinction.
> 
> My apologies, I must have forgotten/missed that discussion.  Do you
> have an archive pointer?
> 
> > > > +SCTP Peer Labeling
> > > > +=========> > > > +An SCTP socket will only have one peer label assigned to it.
> > > > This
> > > > will be
> > > > +assigned during the establishment of the first association.
> > > > Once
> > > > the peer
> > > > +label has been assigned, any new associations will have the
> > > > "association"
> > > > +permission validated by checking the socket peer sid against
> > > > the
> > > > received
> > > > +packets peer sid to determine whether the association should
> > > > be
> > > > allowed or
> > > > +denied.
> > > > +
> > > > +NOTES:
> > > > +   1) If peer labeling is not enabled, then the peer context
> > > > will
> > > > always be
> > > > +      SECINITSID_UNLABELED (unlabeled_t in Reference Policy).
> > > > +
> > > > +   2) As SCTP supports multiple endpoints with multi-homing on
> > > > a
> > > > single socket
> > > > +      it is recommended that peer labels are consistent.
> > > 
> > > My apologies if I'm confused, but I thought it was multiple
> > > associations per-endpoint, with the associations providing the
> > > multi-homing functionality, no?
> > 
> > I've reworded to:
> > As SCTP can support more than one transport address per endpoint
> > (multi-homing) on a single socket, it is possible to configure
> > policy
> > and NetLabel to provide different peer labels for each of these. As
> > the
> > socket peer label is determined by the first associations transport
> > address, it is recommended that all peer labels are consistent.
> 
> I'm still not sure this makes complete sense to me, but since I'm
> still not 100% confident in my understanding of SCTP I'm willing to
> punt on this for the moment.
> 
> > > > +   3) getpeercon(3) may be used by userspace to retrieve the
> > > > sockets peer
> > > > +       context.
> > > > +
> > > > +   4) If using NetLabel be aware that if a label is assigned
> > > > to a
> > > > specific
> > > > +      interface, and that interface 'goes down', then the
> > > > NetLabel
> > > > service
> > > > +      will remove the entry. Therefore ensure that the network
> > > > startup scripts
> > > > +      call netlabelctl(8) to set the required label (see
> > > > netlabel-
> > > > config(8)
> > > > +      helper script for details).
> > > 
> > > Maybe this will be made clear as I work my way through this
> > > patch,
> > > but
> > > how is point #4 SCTP specific?
> > 
> > It's not, I added this as a useful hint as I keep forgetting about
> > it,
> > I'll reword to: While not SCTP specific, be aware .....
> 
> Okay.  Better.
> 
> > > > +/* Called whenever SCTP receives an INIT or INIT_ACK chunk */
> > > > +static int selinux_sctp_assoc_request(struct sctp_endpoint
> > > > *ep,
> > > > +                                     struct sk_buff *skb,
> > > > +                                     int sctp_cid)
> > > > +{
> > > > +       struct sk_security_struct *sksec = ep->base.sk-
> > > > > sk_security;
> > > > 
> > > > +       struct common_audit_data ad;
> > > > +       struct lsm_network_audit net = {0,};
> > > > +       u8 peerlbl_active;
> > > > +       u32 peer_sid = SECINITSID_UNLABELED;
> > > > +       u32 conn_sid;
> > > > +       int err;
> > > > +
> > > > +       if (!selinux_policycap_extsockclass)
> > > > +               return 0;
> > > 
> > > We *may* need to protect a lot of the new SCTP code with a new
> > > policy
> > > capability, I think reusing extsockclass here could be
> > > problematic.
> > 
> > I hope not. I will need some direction here as I've not had
> > problems
> > (yet).
> 
> It's actually not that bad, take a look at the NNP/nosuid patch from
> Stephen, af63f4193f9f ("selinux: Generalize support for NNP/nosuid
> SELinux domain transitions"), pay attention to the
> "selinux_policycap_nnp_nosuid_transition" variable.

AFAICT, Fedora has not yet enabled extended_socket_class policy
capability in their policy, not even in rawhide, so no breakage should
occur in Fedora.  Upstream refpolicy did enable it in the 20170805
release, so it could possibly be enabled in other distributions, but
only if using the latest refpolicy + libsepol.  Android enabled it in
the Android 8.0 policy, although few Android kernels are likely to
include the support yet (Android common kernel appears to be <= 4.9),
so it should presently be a no-op.

> 
> > > > +               if (err)
> > > > +                       return err;
> > > > +
> > > > +               if (peer_sid = SECSID_NULL)
> > > > +                       peer_sid = SECINITSID_UNLABELED;
> > > > +       }
> > > > +
> > > > +       if (sksec->sctp_assoc_state = SCTP_ASSOC_UNSET) {
> > > > +               sksec->sctp_assoc_state = SCTP_ASSOC_SET;
> > > > +
> > > > +               /* Here as first association on socket. As the
> > > > peer
> > > > SID
> > > > +                * was allowed by peer recv (and the netif/node
> > > > checks),
> > > > +                * then it is approved by policy and used as
> > > > the
> > > > primary
> > > > +                * peer SID for getpeercon(3).
> > > > +                */
> > > > +               sksec->peer_sid = peer_sid;
> > > > +       } else if  (sksec->peer_sid != peer_sid) {
> > > > +               /* Other association peer SIDs are checked to
> > > > enforce
> > > > +                * consistency among the peer SIDs.
> > > > +                */
> > > > +               ad.type = LSM_AUDIT_DATA_NET;
> > > > +               ad.u.net = &net;
> > > > +               ad.u.net->sk = ep->base.sk;
> > > > +               err = avc_has_perm(sksec->peer_sid, peer_sid,
> > > > sksec->sclass,
> > > > +                                  SCTP_SOCKET__ASSOCIATION,
> > > > &ad);
> > > 
> > > Can anyone think of any reason why we would ever want to allow an
> > > association that doesn't have the same label as the existing
> > > associations?  Maybe I'm thinking about this wrong, but I can't
> > > imagine this being a good idea ...
> > 
> > This has been discussed a number of times and evolved to this ...
> 
> Yes, I think my comment was the result of faulty SCTP understanding
> on my part.
> 
