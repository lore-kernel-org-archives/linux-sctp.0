From: Jamie Parsons <Jamie.Parsons@metaswitch.com>
Date: Mon, 26 Nov 2012 13:31:57 +0000
Subject: Possible SCTP peer receive window bug
Message-Id: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi,

My name is Jamie Parsons.=A0 I am working on a test tool that uses lksctp (=
lksctp-tools.x86_64 on a Linux box with a 2.6.32-279.9.1.el6.x86_64 kernel)=
 to drive the SCTP interface on one of our products and I think I may have =
found a bug with the peer receive window size.

Having looked at this kernel maintainers list (http://lxr.linux.no/#linux+v=
3.6.7/MAINTAINERS) I believe that you are the people I should contact to re=
port a bug.=A0 If not, please let me know who I should be talking to instea=
d.

If you are the correct people, can you please look at the detailed descript=
ion below?=A0 I think that the issue may be some problem to do with data st=
ructures not being reinitialized correctly after receiving an unexpected IN=
IT. =A0

I've had a quick look at recent check ins for the kernel and couldn't see a=
nything which was obviously a fix for this bug.=A0 Would you be able to hel=
p debugging/fixing this issue?=A0 I'm happy to repro it to get any diagnost=
ics required.

Thanks for your help,

Jamie=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

__TEST SETUP__
I've set up an SCTP connection between a Linux box and a fault tolerant pee=
r.=A0 I collect wireshark snoop from the Linux box throughout the test and =
periodically poll the Linux kernel for SCTP_STATUS using getsockopt() .

After letting it run cleanly for a few minutes, I then deliberately induce =
a fault on the peer to make it failover.=A0 The peer then restarts the conn=
ection by sending an INIT to the Linux box (as covered by section 5.2.2 of =
RFC 4960).

__SYMPTOMS__
Initially, the peer is advertising a receive window of 2000 (I check this b=
y looking at sctp.sack_a_rwnd in wireshark).=A0 I can check that the Linux =
SCTP agrees with this value by doing a getsockopt for SCTP_STATUS and check=
ing the value of sstat_rwnd.=A0 At this stage there is no problem, the SCTP=
 stack reports a value of 2000 with a slight deviation if there is some una=
cked data outstanding. =A0All good so far!

After failing over, the wireshark trace still shows that the peer is advert=
ising a receive window of 2000.=A0 However, if I now check the peer receive=
 window through the Linux SCTP stack as above, it reports a consistently lo=
wer value (of 916 in my last run) again with slight deviation if there are =
unacked packets.=A0=20

At this point I stop sending any data from the Linux box, and wait a couple=
 of minutes to ensure that the send buffer is emptied and all packets have =
been acked.=A0 The last SACK sent by the peer has a receive window value of=
 2000 but the SCTP stack is still reporting a value of 916 with no packets =
unacked.

The problem is compounded by the fact that the SCTP association now can't b=
e brought down from the Linux side.=A0 I have set SO_LINGER 'on' with a tim=
e of 0.=A0 If I call shutdown(SCK, SHUT_RDWR) before a failover then I can =
see the Linux box send an ABORT in the wireshark trace to tear down the ass=
ociation.

If I call shutdown(SCK, SHUT_RDWR) after the peer has failed over then no A=
BORT message is sent.=A0 Using SCTP_STATUS on getsockopt I can see that the=
 stack is in state 5 (PENDING_SHUTDOWN) and stays there indefinitely, which=
 means it is waiting for packets to be acked.=A0 This is despite the fact t=
hat it reports a value of 0 for unacked packets.


