From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 04 Dec 2014 13:46:47 +0000
Subject: Re: Problem with a host having an UNREACHABLE address ?
Message-Id: <20141204134647.GD16249@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Wed, Dec 03, 2014 at 05:57:18PM +0100, Boiteux Frederic wrote:
> 	Hi Vlad,
>=20
> >> When I start SCTP messages exchanges, the hosts are using the first=20
> >> address, which is working, and messages are correctly transmitted. On =

> >> the peer of the failing-IP host, I get notifications that this IP=20
> >> address is UNREACHABLE, it's correct. In fact, I get one notification =

> >> each 100ms, but this can probably be setup.
>=20
> >No, this was an issue that was recently addressed.  See >https://git.ker=
nel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=061079ac0b9be7a578dc=
d09f7865c2c0d6ac894a
>=20
> Right. But it's not a big problem to ignore them...
>=20
> >> The problem is that after some time of message exchanges, about 20=20
> >> seconds, the hosts get a LOST notification for the association and no =

> >> message can't be sent anymore until a new association is built.
>=20
> >Which host gets the LOST notification?
>=20
> It's the host receiving UNREACHABLE=A0notifications (not the host having =
a failed IP, but its peer). It's why I wondered if association breakage and=
 these notifications was related.
>=20
It sounds to me like you just can't include multihoming with the address yo=
u're
referring to.  E.g.:

Host A has ip addresses 1 and 2
Host B has ip addresses 3 and 4

Host A ip 2 isn't routeable

Regardless of Host A's unrouteable ip address 2, its getting included in the
INIT chunk when you establish a connection with Host B, and Host B is then
trying to reach Host A by ip address 2, which your network is rejecting due=
 to
its unrouteable nature.  The only thing I'm aware of to do here is not inlu=
cde
that address, but using the connectx call and not including the unrouteable
address.

Neil

> ...
>=20
> >> is the LOST related to these UNREACHABLE notifications, or should I=20
> >> look for other cause ?
>=20
> >It might be, or it might be related to some transport selection code tha=
t has seen some good fixes.
> > It would be good if you could try this on a recent kernel to see if you=
 still see the issue.
>=20
> I tested my application on virtual systems having the same kernel/system,=
 and tried to do the same configuration, but didn't reproduce the problem.
>=20
> As it's difficult/impossible to upgrade the kernel (without modifying the=
 system, and I can't do that), do you think backporting sctp kernel module =
is a way to test this ?
>=20
> Anyway, given the 'UNREACHABLE' notifications is a wrong suspect, I'll tr=
y to do some network packets' capture to try to understand what is going on=
...
>=20
>   Many thanks,
>              Fred.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
