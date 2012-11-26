From: Jamie Parsons <Jamie.Parsons@metaswitch.com>
Date: Mon, 26 Nov 2012 17:27:47 +0000
Subject: RE: Possible SCTP peer receive window bug
Message-Id: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D38726D@ENFIRHMBX1.datcon.co.uk>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Neil,

Could you send me your IP address so that I can give you access to an FTP s=
erver?

Thanks,

Jamie

-----Original Message-----
From: Neil Horman [mailto:nhorman@tuxdriver.com]=20
Sent: 26 November 2012 15:28
To: Jamie Parsons
Cc: linux-sctp@vger.kernel.org; Peter Brittain
Subject: Re: Possible SCTP peer receive window bug

On Mon, Nov 26, 2012 at 01:31:57PM +0000, Jamie Parsons wrote:
> Hi,
>=20
> My name is Jamie Parsons.=A0 I am working on a test tool that uses lksctp=
 (lksctp-tools.x86_64 on a Linux box with a 2.6.32-279.9.1.el6.x86_64 kerne=
l) to drive the SCTP interface on one of our products and I think I may hav=
e found a bug with the peer receive window size.
>=20
> Having looked at this kernel maintainers list (http://lxr.linux.no/#linux=
+v3.6.7/MAINTAINERS) I believe that you are the people I should contact to =
report a bug.=A0 If not, please let me know who I should be talking to inst=
ead.
>=20
> If you are the correct people, can you please look at the detailed=20
> description below?=A0 I think that the issue may be some problem to do wi=
th data structures not being reinitialized correctly after receiving an une=
xpected INIT.
>=20
> I've had a quick look at recent check ins for the kernel and couldn't see=
 anything which was obviously a fix for this bug.=A0 Would you be able to h=
elp debugging/fixing this issue?=A0 I'm happy to repro it to get any diagno=
stics required.
>=20
> Thanks for your help,
>=20
> Jamie
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> __TEST SETUP__
> I've set up an SCTP connection between a Linux box and a fault tolerant p=
eer.=A0 I collect wireshark snoop from the Linux box throughout the test an=
d periodically poll the Linux kernel for SCTP_STATUS using getsockopt() .
>=20
> After letting it run cleanly for a few minutes, I then deliberately induc=
e a fault on the peer to make it failover.=A0 The peer then restarts the co=
nnection by sending an INIT to the Linux box (as covered by section 5.2.2 o=
f RFC 4960).
>=20
> __SYMPTOMS__
> Initially, the peer is advertising a receive window of 2000 (I check this=
 by looking at sctp.sack_a_rwnd in wireshark).=A0 I can check that the Linu=
x SCTP agrees with this value by doing a getsockopt for SCTP_STATUS and che=
cking the value of sstat_rwnd.=A0 At this stage there is no problem, the SC=
TP stack reports a value of 2000 with a slight deviation if there is some u=
nacked data outstanding. =A0All good so far!
>=20
> After failing over, the wireshark trace still shows that the peer is=20
> advertising a receive window of 2000.=A0 However, if I now check the peer=
 receive window through the Linux SCTP stack as above, it reports a consist=
ently lower value (of 916 in my last run) again with slight deviation if th=
ere are unacked packets.
>=20
> At this point I stop sending any data from the Linux box, and wait a coup=
le of minutes to ensure that the send buffer is emptied and all packets hav=
e been acked.=A0 The last SACK sent by the peer has a receive window value =
of 2000 but the SCTP stack is still reporting a value of 916 with no packet=
s unacked.
>=20
> The problem is compounded by the fact that the SCTP association now can't=
 be brought down from the Linux side.=A0 I have set SO_LINGER 'on' with a t=
ime of 0.=A0 If I call shutdown(SCK, SHUT_RDWR) before a failover then I ca=
n see the Linux box send an ABORT in the wireshark trace to tear down the a=
ssociation.
>=20
> If I call shutdown(SCK, SHUT_RDWR) after the peer has failed over then no=
 ABORT message is sent.=A0 Using SCTP_STATUS on getsockopt I can see that t=
he stack is in state 5 (PENDING_SHUTDOWN) and stays there indefinitely, whi=
ch means it is waiting for packets to be acked.=A0 This is despite the fact=
 that it reports a value of 0 for unacked packets.
>=20
Can you provide a diagram of your network setup, a link to someplace I can =
see your tcpdump, and the specific kernel version that you're using?
Neil

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp"=20
> in the body of a message to majordomo@vger.kernel.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html
>=20
