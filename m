From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 13:13:11 +0000
Subject: Fragmented ordered user messages with inconsistent stream sequence numbers are accepted and delivere
Message-Id: <20170117131311.GF6494@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="aZoGpuMECXJckB41"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When fragmented ordered user messages are sent to the linux kernel user
messages with inconsistent stream sequence numbers are accepted and
delivered to the application. Take for example an look at the following test case:
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/error-cases/packet-loss/ordered/ordered-packet-loss-2.pkt

Here I first inject two DATA-Chunks with sid/ssn 1/1, 2/1 into the
kernel with packetdrill:
line 67: +0.0 < sctp: DATA[flgs=E, len=1016, tsn=2, sid=1, ssn=1,
ppid=0]
line 69: +0.1 < sctp: DATA[flgs=E, len=1016, tsn=4, sid=2, ssn=1,
ppid=0]

After 0.1 seconds i then inject an FORWARD-TSN with cum_tsn=2 bundled
with an DATA-Chunk that looks like this:
DATA[flgs=B, len=1016, tsn=3, sid=2, ssn=0, ppid=0]

This "looks" like the first segment of the user message where already a
fragment (tsn=4) was received. But the ssn-values are  not consistent.
The DATA-Chunk with tsn=3 has ssn=0 and the ssn=1 therefore they should
be ignored by the IUT and not be delivered to the userland application when
calling sctp_recvmsg. Unfortunatly the linux kernel implementation does
currently deliver these inconsistent user messages.

There are many test-cases that all reproduce this
issue. Just take a look at the README at
https://github.com/nplab/PR_SCTP_Testsuite/tree/master/forward-tsn/error-cases/packet-loss/ordered.

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfhhmAAoJEAvjb6G8Rb/js8IIAIUalnMNsgHyuljWmGcTyxqp
4PxFkabkgspnOIcxmZHEnle1CrOyk8wbJKzf/YhKKEBhtzsXcGSBLf/w/v6GNspL
TZptKcL9JymPuyNf2JLNpqIQ3Rmtzgl6ub3NhY0tx/SBt1wPaZ/TUT8LD2bBNSP1
HOL0vjcTtvTdsVbxn5dZpRjYpwBUOxX0aLZsYqxAldyk1gwN9I8ZtTPgm4GhBo0F
Ih9KR66Qkwf4d6sLTF+eZGpAbMeMQUihegwdDxHvUnOnY8YzgBP3S43ONGnwHK9I
SACwU44ODfx30r+9cqVuZOPFTwyhKYJfcj2xMhKQk12IwY7Dx9EajUhTwrbM21c=
=ZXHz
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
