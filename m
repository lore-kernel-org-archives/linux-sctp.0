From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 22 Mar 2017 10:22:47 +0000
Subject: Re: [RFC v2 PATCH 2/2] kernel: Add SELinux SCTP protocol support
Message-Id: <1490178167.27019.8.camel@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170222170359.5433-1-richard_c_haines@btinternet.com>
	<1488487540.19896.108.camel@tycho.nsa.gov>
	<20170320172336.GC23553@localhost.localdomain>
In-Reply-To: <20170320172336.GC23553@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-security-module@vger.kernel.org

On Mon, 2017-03-20 at 14:23 -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Mar 02, 2017 at 03:45:40PM -0500, Stephen Smalley wrote:
> > On Wed, 2017-02-22 at 17:03 +0000, Richard Haines wrote:
> 
> <snip>
> 
> > > +	return err;
> > > +}
> > > +
> > > +static int selinux_sctp_accept_conn(struct sctp_endpoint *ep,
> > > +				    struct sk_buff *skb)
> > > +{
> > > +	struct sk_security_struct *sksec = ep->base.sk-
> > > >sk_security;
> > > +	int err;
> > > +	u32 connsid;
> > > +	u32 peersid;
> > > +
> > > +	/* Have COOKIE ECHO so compute the MLS component for the
> > > connection
> > > +	 * and store the information in ep. This will only be
> > > used
> > > by
> > > +	 * TCP/peeloff connections as they cause a new socket to
> > > be
> > > generated.
> > 
> > Not sure why you say TCP above.  And won't this be true of
> > accept()'d
> 
> Probably just a typo, should be SCTP instead.
Yes so changed to "This will only be used by SCTP TCP type sockets
and peeled off connections".

> 
> > sockets too in addition to peeloff ones?
> 
> Speaking of accept() path, I think we have an issue there with this
> patch, because it's doing:
> @@ -7683,8 +7717,6 @@ void sctp_copy_sock(struct sock *newsk, struct
> sock *sk,
> -       security_sk_clone(sk, newsk);
> @@ -7829,6 +7862,11 @@ static void sctp_sock_migrate(struct sock
> *oldsk,
> struct
> +       security_sctp_sk_clone(oldep, oldsk, newsk);
> 
> But sctp_copy_sock() is called from places other than
> sctp_sock_migrate, mainly:
> net/sctp/ipv6.c:        sctp_copy_sock(newsk, sk, asoc);
> net/sctp/protocol.c:    sctp_copy_sock(newsk, sk, asoc);
> Which are on the accept() path.
> 
> Ideally it's better to keep the call to security_sctp_sk_clone in
> sctp_copy_sock() to get those covered too.

Thanks for pointing this out, I'll fix in next patch set.
> 
>   Marcelo
> 
> > 
> > > +	 * selinux_sctp_sk_clone() will then plug this into the
> > > new
> > > socket
> > > +	 * as described in Documentation/security/LSM-sctp.txt
> > > +	 */
> > > +	err = selinux_skb_peerlbl_sid(skb, ep->base.sk-
> > > >sk_family,
> > > &peersid);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	err = selinux_conn_sid(sksec->sid, peersid, &connsid);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	ep->secid = connsid;
> > > +	ep->peer_secid = peersid;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
