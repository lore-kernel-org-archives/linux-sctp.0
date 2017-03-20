From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 20 Mar 2017 17:23:36 +0000
Subject: Re: [RFC v2 PATCH 2/2] kernel: Add SELinux SCTP protocol support
Message-Id: <20170320172336.GC23553@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170222170359.5433-1-richard_c_haines@btinternet.com>
	<1488487540.19896.108.camel@tycho.nsa.gov>
In-Reply-To: <1488487540.19896.108.camel@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-security-module@vger.kernel.org

On Thu, Mar 02, 2017 at 03:45:40PM -0500, Stephen Smalley wrote:
> On Wed, 2017-02-22 at 17:03 +0000, Richard Haines wrote:
<snip>

> > +	return err;
> > +}
> > +
> > +static int selinux_sctp_accept_conn(struct sctp_endpoint *ep,
> > +				=A0=A0=A0=A0struct sk_buff *skb)
> > +{
> > +	struct sk_security_struct *sksec =3D ep->base.sk->sk_security;
> > +	int err;
> > +	u32 connsid;
> > +	u32 peersid;
> > +
> > +	/* Have COOKIE ECHO so compute the MLS component for the
> > connection
> > +	=A0* and store the information in ep. This will only be used
> > by
> > +	=A0* TCP/peeloff connections as they cause a new socket to be
> > generated.
>=20
> Not sure why you say TCP above. =A0And won't this be true of accept()'d

Probably just a typo, should be SCTP instead.

> sockets too in addition to peeloff ones?

Speaking of accept() path, I think we have an issue there with this
patch, because it's doing:
@@ -7683,8 +7717,6 @@ void sctp_copy_sock(struct sock *newsk, struct
sock *sk,
-       security_sk_clone(sk, newsk);
@@ -7829,6 +7862,11 @@ static void sctp_sock_migrate(struct sock *oldsk,
struct
+       security_sctp_sk_clone(oldep, oldsk, newsk);

But sctp_copy_sock() is called from places other than
sctp_sock_migrate, mainly:
net/sctp/ipv6.c:        sctp_copy_sock(newsk, sk, asoc);
net/sctp/protocol.c:    sctp_copy_sock(newsk, sk, asoc);
Which are on the accept() path.

Ideally it's better to keep the call to security_sctp_sk_clone in
sctp_copy_sock() to get those covered too.

  Marcelo

>=20
> > +	=A0* selinux_sctp_sk_clone() will then plug this into the new
> > socket
> > +	=A0* as described in Documentation/security/LSM-sctp.txt
> > +	=A0*/
> > +	err =3D selinux_skb_peerlbl_sid(skb, ep->base.sk->sk_family,
> > &peersid);
> > +	if (err)
> > +		return err;
> > +
> > +	err =3D selinux_conn_sid(sksec->sid, peersid, &connsid);
> > +	if (err)
> > +		return err;
> > +
> > +	ep->secid =3D connsid;
> > +	ep->peer_secid =3D peersid;
> > +
> > +	return 0;
> > +}
> > +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
