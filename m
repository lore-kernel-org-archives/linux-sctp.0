From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 28 Nov 2012 15:28:47 +0000
Subject: Re: Possible SCTP peer receive window bug
Message-Id: <20121128152847.GA4697@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Tue, Nov 27, 2012 at 02:42:47PM +0000, Jamie Parsons wrote:
> Thanks Neil,
>=20
> That would be great.
>=20
> Jamie
>=20
Ok, so a few thoughts:

1) I didn't read closely enough in your description below.  You're using a =
RHEL6
kernel.  This list is meant for upstream sctp development.  I'll gladly hel=
p you
as best as I can, but you're going to want to reproduce this on an more rec=
ent
upstream kernel.  You should also open a support call with Red Hat, we can =
use
what we determine from testing here to tell if a backport of code to that k=
ernel
is needed

2) I see where your connection fails
and you send a new INIT chunk (frame 1797), after which you start seeing lo=
ts of
HEARTBEAT frames get sent periodically (suggesting that you've really crank=
ed
down the hbinterval sysctl. Not sure why you've done that, but you likely w=
ant
to back it off somewhat, as it generates unneeded traffic.

3) One thing that does jump out at me is the fact that the INIT chunk in fr=
ame
1797, is being made from and too the same src and dst addresses and to the =
same
src/dst ports, indicating this is not an esblishing of a new transport in t=
he
association (the typical failover case), but rather its going to be handled=
 as a
duplicate INIT.  I'm wondering if perhaps we don't loose some information i=
n the
duplicate INIT handling proces, that leads to a few bytes getting dropped f=
rom
the receive window.

Can you please do the following:
1) Provide the complete output of the SCTP_STATUS socket option when you
encounter the issue above

2) Try to recreate this on a recent upstream kernel  (the head of the net-n=
ext
tree would be great).

3) Describe in more detail how you force the failover event to occur, and w=
hat
sort of failover paths exist between Peer A and the Linux box (your descrip=
tion
below suggests there is only one path between the two)

Also, you should open a support ticket with Red Hat, as they will be able to
support this kernel for you (I work for Red Hat, and if we do find a bug he=
re,
we'll need a support ticket to backport it for you).

Thanks
Neil

> -----Original Message-----
> From: Neil Horman [mailto:nhorman@tuxdriver.com]=20
> Sent: 27 November 2012 14:38
> To: Jamie Parsons
> Cc: linux-sctp@vger.kernel.org; Peter Brittain
> Subject: Re: Possible SCTP peer receive window bug
>=20
> On Tue, Nov 27, 2012 at 11:05:03AM +0000, Jamie Parsons wrote:
> > Hi Neil,
> >=20
> > The FTP server is ftp.uk.metaswitch.com.
> > username:  linux-sctp
> > password:  8RyJ97Th
> >=20
> > You will only be able to access it from 99.127.245.201.
> >=20
> > The tcpdump file is called 9932filter.pcap
> >=20
> > My test setup is as follows:
> >=20
> > ___________               ___________               ____________
> > |          |              |  Linux  |               |           |
> > | Peer A   |--------------|   Box   |---------------|  Peer B   |
> > |__________|              |_________|               |___________|
> >=20
> >=20
> > Peer A and Peer B are using the Linux box as a pipe to send ISDN messag=
es between themselves.  The ISDN messages are sent over SCTP connections fr=
om one peer to the linux box, the linux box then forwards them over another=
 SCTP connection to the other peer.  There are multiple SCTP connections be=
tween the linux box and both Peer A and Peer B, each of the SCTP connection=
s uses a different port on the linux box.  Peer A is the box which fails ov=
er.
> >=20
> > The tcpdump which I have placed in the FTP directory was gathered on th=
e linux box and filtered on the port so that only contains packets for one =
particular SCTP connection between Peer A and the linux box.
> >=20
> > In the tcpdump the IP addresses are as follows:
> > Peer A: 10.249.59.1
> > linux box: 10.224.191.1
> >=20
> > Peer A fails over at 12:20:59.
> > The linux box stops sending messages at 12:21:24.
> >=20
> > The kernel version on the linux box (obtained using uname -a) is 2.6.32=
-279.9.1.el6.x86_64.  If there is something more specific you want could yo=
u tell me how to get it? =20
> >=20
> > Thanks for your help,
> >=20
> > Jamie
> >=20
> Thank you, I'm not at my home system at the moment, but I've downloaded t=
he pcap file and will look at it in depth tonight.
> Neil
>=20
> > -----Original Message-----
> > From: Neil Horman [mailto:nhorman@tuxdriver.com]
> > Sent: 26 November 2012 20:11
> > To: Jamie Parsons
> > Cc: linux-sctp@vger.kernel.org; Peter Brittain
> > Subject: Re: Possible SCTP peer receive window bug
> >=20
> > On Mon, Nov 26, 2012 at 05:27:47PM +0000, Jamie Parsons wrote:
> > > Hi Neil,
> > >=20
> > > Could you send me your IP address so that I can give you access to an=
 FTP server?
> > >=20
> > > Thanks,
> > >=20
> > > Jamie
> > >=20
> > 99.127.245.201
> > Neil
> >=20
> > > -----Original Message-----
> > > From: Neil Horman [mailto:nhorman@tuxdriver.com]
> > > Sent: 26 November 2012 15:28
> > > To: Jamie Parsons
> > > Cc: linux-sctp@vger.kernel.org; Peter Brittain
> > > Subject: Re: Possible SCTP peer receive window bug
> > >=20
> > > On Mon, Nov 26, 2012 at 01:31:57PM +0000, Jamie Parsons wrote:
> > > > Hi,
> > > >=20
> > > > My name is Jamie Parsons.=A0 I am working on a test tool that uses =
lksctp (lksctp-tools.x86_64 on a Linux box with a 2.6.32-279.9.1.el6.x86_64=
 kernel) to drive the SCTP interface on one of our products and I think I m=
ay have found a bug with the peer receive window size.
> > > >=20
> > > > Having looked at this kernel maintainers list (http://lxr.linux.no/=
#linux+v3.6.7/MAINTAINERS) I believe that you are the people I should conta=
ct to report a bug.=A0 If not, please let me know who I should be talking t=
o instead.
> > > >=20
> > > > If you are the correct people, can you please look at the detailed =

> > > > description below?=A0 I think that the issue may be some problem to=
 do with data structures not being reinitialized correctly after receiving =
an unexpected INIT.
> > > >=20
> > > > I've had a quick look at recent check ins for the kernel and couldn=
't see anything which was obviously a fix for this bug.=A0 Would you be abl=
e to help debugging/fixing this issue?=A0 I'm happy to repro it to get any =
diagnostics required.
> > > >=20
> > > > Thanks for your help,
> > > >=20
> > > > Jamie
> > > >=20
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >=20
> > > > __TEST SETUP__
> > > > I've set up an SCTP connection between a Linux box and a fault tole=
rant peer.=A0 I collect wireshark snoop from the Linux box throughout the t=
est and periodically poll the Linux kernel for SCTP_STATUS using getsockopt=
() .
> > > >=20
> > > > After letting it run cleanly for a few minutes, I then deliberately=
 induce a fault on the peer to make it failover.=A0 The peer then restarts =
the connection by sending an INIT to the Linux box (as covered by section 5=
.2.2 of RFC 4960).
> > > >=20
> > > > __SYMPTOMS__
> > > > Initially, the peer is advertising a receive window of 2000 (I chec=
k this by looking at sctp.sack_a_rwnd in wireshark).=A0 I can check that th=
e Linux SCTP agrees with this value by doing a getsockopt for SCTP_STATUS a=
nd checking the value of sstat_rwnd.=A0 At this stage there is no problem, =
the SCTP stack reports a value of 2000 with a slight deviation if there is =
some unacked data outstanding. =A0All good so far!
> > > >=20
> > > > After failing over, the wireshark trace still shows that the peer=20
> > > > is advertising a receive window of 2000.=A0 However, if I now check=
 the peer receive window through the Linux SCTP stack as above, it reports =
a consistently lower value (of 916 in my last run) again with slight deviat=
ion if there are unacked packets.
> > > >=20
> > > > At this point I stop sending any data from the Linux box, and wait =
a couple of minutes to ensure that the send buffer is emptied and all packe=
ts have been acked.=A0 The last SACK sent by the peer has a receive window =
value of 2000 but the SCTP stack is still reporting a value of 916 with no =
packets unacked.
> > > >=20
> > > > The problem is compounded by the fact that the SCTP association now=
 can't be brought down from the Linux side.=A0 I have set SO_LINGER 'on' wi=
th a time of 0.=A0 If I call shutdown(SCK, SHUT_RDWR) before a failover the=
n I can see the Linux box send an ABORT in the wireshark trace to tear down=
 the association.
> > > >=20
> > > > If I call shutdown(SCK, SHUT_RDWR) after the peer has failed over t=
hen no ABORT message is sent.=A0 Using SCTP_STATUS on getsockopt I can see =
that the stack is in state 5 (PENDING_SHUTDOWN) and stays there indefinitel=
y, which means it is waiting for packets to be acked.=A0 This is despite th=
e fact that it reports a value of 0 for unacked packets.
> > > >=20
> > > Can you provide a diagram of your network setup, a link to someplace =
I can see your tcpdump, and the specific kernel version that you're using?
> > > Neil
> > >=20
> > > >=20
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-sct=
p"=20
> > > > in the body of a message to majordomo@vger.kernel.org More=20
> > > > majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >=20
> > >=20
> >=20
>=20
