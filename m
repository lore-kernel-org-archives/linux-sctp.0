From: Ryan <liquidbreeze1@yahoo.com>
Date: Tue, 10 Sep 2013 19:16:29 +0000
Subject: Multihoming setup
Message-Id: <1378840589.23283.YahooMailNeo@web140604.mail.bf1.yahoo.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi all,

I am pretty new to sctp. I am trying to replicate heartbeat packets in a te=
st env, because we believe one of our devices is having issues w/ these pac=
kets

We have enabled.
sysctl -w net.sctp.addip_enable=3D1
sysctl -w net.sctp.auth_enable=3D1=A0

Non-multihomed sctp traffic between an sctp_test client and server works.

But I cannot seem to figure out how to get sctp_test to generate heartbeat =
packets, which I believe multihoming is required.

How do I generate heartbeat packets and/or configure sctp_test to do multih=
oming?

Thanks in advance,
Ryan
