From: David Miller <davem@davemloft.net>
Date: Tue, 29 May 2018 02:55:42 +0000
Subject: Re: [PATCH net-next] vrf: add CRC32c offload to device features
Message-Id: <20180528.225542.1722255732303958123.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
In-Reply-To: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: dcaratti@redhat.com
Cc: dsa@cumulusnetworks.com, vyasevich@gmail.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Thu, 24 May 2018 17:49:35 +0200

> SCTP sockets originated in a VRF can improve their performance if CRC32c
> computation is delegated to underlying devices: update device features,
> setting NETIF_F_SCTP_CRC. Iterating the following command in the topology
> proposed with [1],
>=20
>  # ip vrf exec vrf-h2 netperf -H 192.0.2.1 -t SCTP_STREAM -- -m 10K
>=20
> the measured throughput in Mbit/s improved from 2395 =B1 1% to 2720 =B1 1=
%.
>=20
> [1] https://www.spinics.net/lists/netdev/msg486007.html
>=20
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thank you.
