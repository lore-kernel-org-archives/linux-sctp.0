From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 27 Nov 2012 14:38:05 +0000
Subject: Re: Possible SCTP peer receive window bug
Message-Id: <20121127143805.GA17541@shamino.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Tue, Nov 27, 2012 at 11:05:03AM +0000, Jamie Parsons wrote:
> Hi Neil,
>=20
> The FTP server is ftp.uk.metaswitch.com.
> username:  linux-sctp
> password:  8RyJ97Th
>=20
> You will only be able to access it from 99.127.245.201.
>=20
> The tcpdump file is called 9932filter.pcap
>=20
> My test setup is as follows:
>=20
> ___________               ___________               ____________
> |          |              |  Linux  |               |           |
> | Peer A   |--------------|   Box   |---------------|  Peer B   |
> |__________|              |_________|               |___________|
>=20
>=20
> Peer A and Peer B are using the Linux box as a pipe to send ISDN messages=
 between themselves.  The ISDN messages are sent over SCTP connections from=
 one peer to the linux box, the linux box then forwards them over another S=
CTP connection to the other peer.  There are multiple SCTP connections betw=
een the linux box and both Peer A and Peer B, each of the SCTP connections =
uses a different port on the linux box.  Peer A is the box which fails over.
>=20
> The tcpdump which I have placed in the FTP directory was gathered on the =
linux box and filtered on the port so that only contains packets for one pa=
rticular SCTP connection between Peer A and the linux box.
>=20
> In the tcpdump the IP addresses are as follows:
> Peer A: 10.249.59.1
> linux box: 10.224.191.1
>=20
> Peer A fails over at 12:20:59.
> The linux box stops sending messages at 12:21:24.
>=20
> The kernel version on the linux box (obtained using uname -a) is 2.6.32-2=
79.9.1.el6.x86_64.  If there is something more specific you want could you =
tell me how to get it? =20
>=20
> Thanks for your help,
>=20
> Jamie
>=20
Thank you, I'm not at my home system at the moment, but I've downloaded the=
 pcap
file and will look at it in depth tonight.
Neil

> -----Original Message-----
> From: Neil Horman [mailto:nhorman@tuxdriver.com]=20
> Sent: 26 November 2012 20:11
> To: Jamie Parsons
> Cc: linux-sctp@vger.kernel.org; Peter Brittain
> Subject: Re: Possible SCTP peer receive window bug
>=20
> On Mon, Nov 26, 2012 at 05:27:47PM +0000, Jamie Parsons wrote:
> > Hi Neil,
> >=20
> > Could you send me your IP address so that I can give you access to an F=
TP server?
> >=20
> > Thanks,
> >=20
> > Jamie
> >=20
> 99.127.245.201
> Neil
>=20
> > -----Original Message-----
> > From: Neil Horman [mailto:nhorman@tuxdriver.com]
> > Sent: 26 November 2012 15:28
> > To: Jamie Parsons
> > Cc: linux-sctp@vger.kernel.org; Peter Brittain
> > Subject: Re: Possible SCTP peer receive window bug
> >=20
> > On Mon, Nov 26, 2012 at 01:31:57PM +0000, Jamie Parsons wrote:
> > > Hi,
> > >=20
> > > My name is Jamie Parsons.=A0 I am working on a test tool that uses lk=
sctp (lksctp-tools.x86_64 on a Linux box with a 2.6.32-279.9.1.el6.x86_64 k=
ernel) to drive the SCTP interface on one of our products and I think I may=
 have found a bug with the peer receive window size.
> > >=20
> > > Having looked at this kernel maintainers list (http://lxr.linux.no/#l=
inux+v3.6.7/MAINTAINERS) I believe that you are the people I should contact=
 to report a bug.=A0 If not, please let me know who I should be talking to =
instead.
> > >=20
> > > If you are the correct people, can you please look at the detailed=20
> > > description below?=A0 I think that the issue may be some problem to d=
o with data structures not being reinitialized correctly after receiving an=
 unexpected INIT.
> > >=20
> > > I've had a quick look at recent check ins for the kernel and couldn't=
 see anything which was obviously a fix for this bug.=A0 Would you be able =
to help debugging/fixing this issue?=A0 I'm happy to repro it to get any di=
agnostics required.
> > >=20
> > > Thanks for your help,
> > >=20
> > > Jamie
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > __TEST SETUP__
> > > I've set up an SCTP connection between a Linux box and a fault tolera=
nt peer.=A0 I collect wireshark snoop from the Linux box throughout the tes=
t and periodically poll the Linux kernel for SCTP_STATUS using getsockopt()=
 .
> > >=20
> > > After letting it run cleanly for a few minutes, I then deliberately i=
nduce a fault on the peer to make it failover.=A0 The peer then restarts th=
e connection by sending an INIT to the Linux box (as covered by section 5.2=
.2 of RFC 4960).
> > >=20
> > > __SYMPTOMS__
> > > Initially, the peer is advertising a receive window of 2000 (I check =
this by looking at sctp.sack_a_rwnd in wireshark).=A0 I can check that the =
Linux SCTP agrees with this value by doing a getsockopt for SCTP_STATUS and=
 checking the value of sstat_rwnd.=A0 At this stage there is no problem, th=
e SCTP stack reports a value of 2000 with a slight deviation if there is so=
me unacked data outstanding. =A0All good so far!
> > >=20
> > > After failing over, the wireshark trace still shows that the peer is =

> > > advertising a receive window of 2000.=A0 However, if I now check the =
peer receive window through the Linux SCTP stack as above, it reports a con=
sistently lower value (of 916 in my last run) again with slight deviation i=
f there are unacked packets.
> > >=20
> > > At this point I stop sending any data from the Linux box, and wait a =
couple of minutes to ensure that the send buffer is emptied and all packets=
 have been acked.=A0 The last SACK sent by the peer has a receive window va=
lue of 2000 but the SCTP stack is still reporting a value of 916 with no pa=
ckets unacked.
> > >=20
> > > The problem is compounded by the fact that the SCTP association now c=
an't be brought down from the Linux side.=A0 I have set SO_LINGER 'on' with=
 a time of 0.=A0 If I call shutdown(SCK, SHUT_RDWR) before a failover then =
I can see the Linux box send an ABORT in the wireshark trace to tear down t=
he association.
> > >=20
> > > If I call shutdown(SCK, SHUT_RDWR) after the peer has failed over the=
n no ABORT message is sent.=A0 Using SCTP_STATUS on getsockopt I can see th=
at the stack is in state 5 (PENDING_SHUTDOWN) and stays there indefinitely,=
 which means it is waiting for packets to be acked.=A0 This is despite the =
fact that it reports a value of 0 for unacked packets.
> > >=20
> > Can you provide a diagram of your network setup, a link to someplace I =
can see your tcpdump, and the specific kernel version that you're using?
> > Neil
> >=20
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-sctp"=
=20
> > > in the body of a message to majordomo@vger.kernel.org More majordomo =

> > > info at  http://vger.kernel.org/majordomo-info.html
> > >=20
> >=20
>=20
