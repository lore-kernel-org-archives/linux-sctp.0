From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Wed, 03 Dec 2014 10:50:31 +0000
Subject: wrong family for IP addresses given by sctp library
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

          Hello,

I'm trying to use SCTP=A0on Linux machines with 'old' kernels (Debian 5, 2.=
6.26 kernel and Debian 7, 3.2 kernel). I've setup a program which can handl=
es IPv4 and IPv6 addresses, and for that, I use a socket with AF_INET6 fami=
ly, then I=A0bind it to IPv4 or v6 addresses with sctp_bindx() (its manual =
page says this call can handle both v4 and v6 adresses if the socket is an =
IPv6 one).
It seems to work well, but I=A0have a strange behavior :=A0on a test platfo=
rm with only IPv4 addresses, when I=A0get messages or notifications (using =
sctp_recvmsg()), the addresses given in it (IP=A0address of the sender, or =
confirmation/fail of some peer addresses) are always from the IPv6 family !
For example, for received messages, the =AB from =BB socket address returne=
d by sctp_recvmsg() has always a sa_family field to AF_INET6, even if the a=
ddress is in fact an IPv4 address ! Using getnameinfo() with NI_NUMERICHOST=
 option, I  can get the ascii representation of the address, a 4 dotted add=
ress, and then I have to fix the address to use it with its real family (as=
 I=A0expected to receive).
It seems to be directly related to the AF_INET6 family of the socket, but I=
 don't know if it' s a known problem, possibly fixed since then in latest l=
inux-sctip library, or probably a programmatic error from me.

  Have you ever heard for such problem ? What is your feeling about ?

	With regards,
                      Fred.

