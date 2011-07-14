From: David Miller <davem@davemloft.net>
Date: Thu, 14 Jul 2011 21:37:10 +0000
Subject: Re: [PATCH 01/10] net: sctp: fix checksum marking for outgoing
Message-Id: <20110714.143710.1285450081984113368.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1310601401.git.mirq-linux@rere.qmqm.pl>
	<d67799da9624127ffabf05226c0f20090be4f785.1310601401.git.mirq-linux@rere.qmqm.pl>
In-Reply-To: <d67799da9624127ffabf05226c0f20090be4f785.1310601401.git.mirq-linux@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: mirq-linux@rere.qmqm.pl
Cc: netdev@vger.kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org

From: Micha=A9=A9 Miros=A9=A9aw <mirq-linux@rere.qmqm.pl>
Date: Thu, 14 Jul 2011 02:10:29 +0200 (CEST)

> Packets to devices without NETIF_F_SCTP_CSUM (including NETIF_F_NO_CSUM)
> should be properly checksummed because the packets can be diverted or
> rerouted after construction. This still leaves packets diverted from
> NETIF_F_SCTP_CSUM-enabled devices with broken checksums. Fixing this
> needs implementing software offload fallback in networking core.
>=20
> For users of sctp_checksum_disable, skb->ip_summed should be left as
> CHECKSUM_NONE and not CHECKSUM_UNNECESSARY as per include/linux/skbuff.h.
>=20
> Signed-off-by: Micha=A9=A9 Miros=A9=A9aw <mirq-linux@rere.qmqm.pl>

This is not the way to fix this.

We need to add the proper software fallback when the SKB device
changes to one with SCTP/NO_CSUM to one that does not.
