From: Mingyuan Zhu <liyha.zhu@gmail.com>
Date: Tue, 15 Feb 2011 13:58:40 +0000
Subject: Gap is only retransmitted once
Message-Id: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi,



I have observed a problem while doing load testing on SCTP. The tested
equipment is an open suse linux box with 2.6.34 kernel. The
application of the equipment will send/receive messages through linux
kernel sctp. The peer is an equipment using Aricent sctp stack.

During the load testing, the peer equipment drops sctp chunks and
reports gaps through SACK to the tested equipment.

The tested equipment (Linux box) retransmitts the missing chunks. But
it always retransmit=A0the same #TSN only once even it receives more
SACKs with the reporting gap.

From the ethereal captures:

- TSN 2254147468 is not received by=A0the peer equipment, so it reports
the gap by SACK.

- Linux box retransmit TSN 2254147468.

- The peer still does not get it. It reports the gap by SACK again and agai=
n.

- Linux box never retransmit the missing chunk again.

- Finally, neither linux box nor the peer can send/receive any more chunks.



Could someone help to look at the problem? Any help would be highly appreci=
ated!
