From: "Kiss, Zoltan (NSN - HU/Budapest)" <zoltan.kiss@nsn.com>
Date: Wed, 17 Nov 2010 16:22:23 +0000
Subject: Source address selection with secondary interface address
Message-Id: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi,

I have an issue with source IP selection in case of multihoming. In my conf=
iguration the host has two addresses on different VLAN interfaces and subne=
ts:

1: vlan1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
    inet 10.0.0.148/29 scope global vlan1
    inet 10.0.0.146/29 scope global secondary vlan1
       valid_lft forever preferred_lft forever
2: vlan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
    inet 10.0.0.156/29 scope global vlan2
    inet 10.0.0.154/29 scope global secondary vlan2
       valid_lft forever preferred_lft forever

The association uses the secondary addresses for both interface as local ad=
dress:

ffff810136d2c000 ffff8101370a3b40 2   1   4  40533    7        0        0  =
   100  5866 1111  2222  *10.0.0.146 10.0.0.154 <-> *10.0.0.20 10.0.0.36

And there is a routing entry, which tells to use vlan 2 if 10.0.0.36 is the=
 destination:

10.0.0.32/28 via 10.0.0.153 dev vlan2

But capturing on that interface shows the HB ACKs going back with a wrong a=
ddress:

18:43:31.917051 IP 10.0.0.36.2222 > 10.0.0.154.1111: sctp (1) [HB REQ]
18:43:31.917057 IP 10.0.0.146.1111 > 10.0.0.36.2222: sctp (1) [HB ACK]

More exactly, with the primary address of that association. When I changed =
the second address of the association to 10.0.0.156 instead of .154, it wor=
ks well, .156 is used. Also, when I set explicitly in the route enty which =
source address has to be used (10.0.0.154), it works also.
The thing I don't understand why does it work with the interface's secondar=
y address only when I specify the source address explicitly? I thought they=
 are equal from this point of view, and when SCTP stack specifies the sourc=
e address, IP won't overwrite it when it is existing on that interface.

Is this a bug or a feature? Unfortunatelly I have to use a pretty old kerne=
l, 2.6.21.7, and I tried to search the changelogs to find if this is a fixe=
d problem, but without luck. So I decided to ask you before I make efforts =
to try this out on a newer kernel.

Thanks for your help beforehand!

Kiss Zolt=E1n


