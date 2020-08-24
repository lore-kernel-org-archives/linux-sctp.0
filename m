From: Pau Espin Pedrol <pespin@sysmocom.de>
Date: Mon, 24 Aug 2020 10:23:47 +0000
Subject: Re: SCTP multi-homed association (::1)->(::1+127.0.0.1) attempting HEARTBEAT on 127.0.0.1->127.0.0.1
Message-Id: <8d6bafce-225b-32b3-93c2-48640251bac2@sysmocom.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
In-Reply-To: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Andreas,

My point is that the failure is in the client, which is creating an
AF_INET6 socket and only binding on ::1, so it should never try to use
"127.0.0.1" as local IP imho. Your comments may apply to the server,
which is actually behaving fine.

On 8/24/20 12:12 PM, Andreas Fink wrote:
> The problem might be that your socket(AF_INET6,SCTP,STREAM) gives you an
> IPv6 only socket
> but you are binding an IPv4 address to it with sctp_bindx. This will
> probably fail and thus you are binding to "any".

It doesn't fail, I'm checking the result of sctp_bindx() and
/proc/net/sctp/eps I initially attached to the bug tracker shows it's
binding fine as expected.

>=20
> If you want IPv4+IPv6 in one socket, you need to specify a IPv4 address
> in =C2=A0IPv6 compatibility format
> So you should sctp_bindx to =C2=A0 "::ffff:127.0.0.1" not to =C2=A0"127.0=
.0.1"
> =C2=A0(well in any case you should pass a struck sockaddr_in6 and not a
> struct sockaddr_in)

Not really. I'm creating an addr buffer containing both struct
sockaddr_in and struct sockaddr_in6 (see [1] if interested) after having
looked at how libsctp and the kernel handle the sctp_bindx call, and
it's working fine as backed by what /proc/net/sctp/eps shows.

[1]
https://git.osmocom.org/libosmocore/tree/src/socket.c?id=ED42a889004730beb2=
6ce61ee462244b2bad6be9#n470

--=20
- Pau Espin Pedrol <pespin@sysmocom.de>         http://www.sysmocom.de/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D* sysmocom - systems for mobile communication=
s GmbH
* Alt-Moabit 93
* 10559 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschaeftsfuehrer / Managing Director: Harald Welte
