From: "Kiss, Zoltan (NSN - HU/Budapest)" <zoltan.kiss@nsn.com>
Date: Wed, 24 Nov 2010 15:18:02 +0000
Subject: RE: Source address selection with secondary interface address
Message-Id: <79C4240C13B4C84B910850B96B1B431201C97529@DEMUEXC035.nsn-intra.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
In-Reply-To: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi,

In this routing entry:

10.0.0.36/28 via 10.0.0.153 dev vlan2

.153 is the nexthop, not the source IP! My theory that when it queries this=
 route, it will give back implicitly the primary IP of that interface, whic=
h is .156, and that's why it isn't succeeded.

About the next step, so is this a correct statement?:

sctp_v4_get_dst() is querying the routing table with every local address (.=
146 and .154, in this order) of that association as SRC address, and if it =
receives ANY kind of valid route with this condition (only SRC is defined),=
 it will use that SRC for the packet (right the first query will succeed wi=
th .146), BUT it won't change the outgoing interface according to this rout=
ing entry (OR it change it in the skb, but later IP will overwrite it?)

I will check Vlad's tree later

Regards,

Zoli

-----Original Message-----
From: ext Shan Wei [mailto:shanwei@cn.fujitsu.com]=20
Sent: Wednesday, November 24, 2010 10:04 AM
To: Kiss, Zoltan (NSN - HU/Budapest)
Cc: linux-sctp@vger.kernel.org; lksctp-developers@lists.sourceforge.net
Subject: Re: Source address selection with secondary interface address

Kiss, Zoltan (NSN - HU/Budapest) wrote, at 11/23/2010 11:24 PM:
> Hi,
>=20
> I still don't know am I writing to the good mailing list, because I didn'=
t received any feedback, so please someone reply to me if I'm writing to a =
wrong address.
> I've started to investigate my problem in the kernel code, and I found th=
e following:
>=20
> - before SCTP layer send the packet to IP, it fills the src IP address in=
 the skbuff (see net/sctp/output.c:333 in 2.6.21.7 kernel code)

Yes.

> - it queries the routing table in sctp_transport_route (see transport.c) =
to find a route to the destination (which is the secondary address of the r=
emote end)

The destination is .36.

> - the routing entry will return an address of that interface. Here comes =
the problem, because it returns only one address basically, the primary add=
ress of that interface (except if src IP is explicitly specified to that ro=
ute)
> - it won't match any of the associations local address, of course, becaus=
e they are secondary addresses on those interfaces

The route entry you setted is:
10.0.0.36/28 via 10.0.0.153 dev vlan2

So the source ip address of the route entry is 10.0.0.153 which is not matc=
h any local address of association.
The local address of association is .146(as primary), and .154.

> - the next thing is not clear yet to me: the sctp_v4_get_dst (see protoco=
l.c) tries to find a destination in the routing table according to its loca=
l addresses. Based on this it should choose a different interface than the =
actually used. Or could it be that struct dst_entry doesn't change the actu=
al outgoing interface?

The next things is that:
The association used every local address as source address of flowi struct =
to search route.
If succeed, then use this source address to send HEARTBEAT ACK chunk.
So the source address of HEARTBEAT ACK chunk is .146, not .154.

so, when you set explicitly in the route enty which source address has to b=
e used (10.0.0.154), it works also.
I think you set route entry without source address, it works still ok.
like: ip route add 10.0.0.36 dev eth0


> As I checked, 2.6.31.1 works in a similiar manner. Before I'm going forwa=
rd, could anyone help me in confirming or disclaiming about the above?
>=20
> Thanks for the help,
>=20
> Zolt=E1n, Kiss
>=20
> -----Original Message-----
> From: Kiss, Zoltan (NSN - HU/Budapest)=20
> Sent: Wednesday, November 17, 2010 5:22 PM
> To: 'linux-sctp@vger.kernel.org'
> Subject: Source address selection with secondary interface address
>=20
> Hi,
>=20
> I have an issue with source IP selection in case of multihoming. In my co=
nfiguration the host has two addresses on different VLAN interfaces and sub=
nets:
>=20
> 1: vlan1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     inet 10.0.0.148/29 scope global vlan1
>     inet 10.0.0.146/29 scope global secondary vlan1
>        valid_lft forever preferred_lft forever
> 2: vlan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     inet 10.0.0.156/29 scope global vlan2
>     inet 10.0.0.154/29 scope global secondary vlan2
>        valid_lft forever preferred_lft forever
>=20
> The association uses the secondary addresses for both interface as local =
address:
>=20
> ffff810136d2c000 ffff8101370a3b40 2   1   4  40533    7        0        0=
     100  5866 1111  2222  *10.0.0.146 10.0.0.154 <-> *10.0.0.20 10.0.0.36
>=20
> And there is a routing entry, which tells to use vlan 2 if 10.0.0.36 is t=
he destination:
>=20
> 10.0.0.32/28 via 10.0.0.153 dev vlan2

what is 10.0.0.153?

>=20
> But capturing on that interface shows the HB ACKs going back with a wrong=
 address:
>=20
> 18:43:31.917051 IP 10.0.0.36.2222 > 10.0.0.154.1111: sctp (1) [HB REQ]
> 18:43:31.917057 IP 10.0.0.146.1111 > 10.0.0.36.2222: sctp (1) [HB ACK]
>=20
> More exactly, with the primary address of that association. When I change=
d the second address of the association to 10.0.0.156 instead of .154, it w=
orks well, .156 is used. Also, when I set explicitly in the route enty whic=
h source address has to be used (10.0.0.154), it works also.
> The thing I don't understand why does it work with the interface's second=
ary address only when I specify the source address explicitly? I thought th=
ey are equal from this point of view, and when SCTP stack specifies the sou=
rce address, IP won't overwrite it when it is existing on that interface.
>=20
> Is this a bug or a feature? Unfortunatelly I have to use a pretty old ker=
nel, 2.6.21.7, and I tried to search the changelogs to find if this is a fi=
xed problem, but without luck. So I decided to ask you before I make effort=
s to try this out on a newer kernel.
>=20
> Thanks for your help beforehand!
>=20
> Kiss Zolt=E1n
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20

Best Regards
-----
Shan Wei
