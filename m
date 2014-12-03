From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Wed, 03 Dec 2014 11:25:49 +0000
Subject: Re: wrong family for IP addresses given by sctp library
Message-Id: <AD8F1D69-A45E-4A9D-BE52-8470DC65BF95@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 03 Dec 2014, at 11:50, Boiteux Frederic <fboiteux@prosodie.com> wrote:

>          Hello,
>=20
> I'm trying to use SCTP on Linux machines with 'old' kernels (Debian 5, 2.=
6.26 kernel and Debian 7, 3.2 kernel). I've setup a program which can handl=
es IPv4 and IPv6 addresses, and for that, I use a socket with AF_INET6 fami=
ly, then I bind it to IPv4 or v6 addresses with sctp_bindx() (its manual pa=
ge says this call can handle both v4 and v6 adresses if the socket is an IP=
v6 one).
> It seems to work well, but I have a strange behavior : on a test platform=
 with only IPv4 addresses, when I get messages or notifications (using sctp=
_recvmsg()), the addresses given in it (IP address of the sender, or confir=
mation/fail of some peer addresses) are always from the IPv6 family !
Is it possible that the address are mapped V4 addresses?

Best regards
Michael
> For example, for received messages, the =AB from =BB socket address retur=
ned by sctp_recvmsg() has always a sa_family field to AF_INET6, even if the=
 address is in fact an IPv4 address ! Using getnameinfo() with NI_NUMERICHO=
ST option, I  can get the ascii representation of the address, a 4 dotted a=
ddress, and then I have to fix the address to use it with its real family (=
as I expected to receive).
> It seems to be directly related to the AF_INET6 family of the socket, but=
 I don't know if it' s a known problem, possibly fixed since then in latest=
 linux-sctip library, or probably a programmatic error from me.
>=20
>  Have you ever heard for such problem ? What is your feeling about ?
>=20
> 	With regards,
>                      Fred.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

