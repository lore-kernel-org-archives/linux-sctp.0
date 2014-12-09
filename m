From: David Miller <davem@davemloft.net>
Date: Tue, 09 Dec 2014 18:24:55 +0000
Subject: Re: [PATCH net] net: sctp: use MAX_HEADER for headroom reserve in output path
Message-Id: <20141209.132455.111095755280708974.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1417605238-9936-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1417605238-9936-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, robert@swiecki.net

From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed,  3 Dec 2014 12:13:58 +0100

> To accomodate for enough headroom for tunnels, use MAX_HEADER instead
> of LL_MAX_HEADER. Robert reported that he has hit after roughly 40hrs
> of trinity an skb_under_panic() via SCTP output path (see reference).
> I couldn't reproduce it from here, but not using MAX_HEADER as elsewhere
> in other protocols might be one possible cause for this.
>=20
> In any case, it looks like accounting on chunks themself seems to look
> good as the skb already passed the SCTP output path and did not hit
> any skb_over_panic(). Given tunneling was enabled in his .config, the
> headroom would have been expanded by MAX_HEADER in this case.
>=20
> Reported-by: Robert =A6wi=EAcki <robert@swiecki.net>
> Reference: https://lkml.org/lkml/2014/12/1/507
> Fixes: 594ccc14dfe4d ("[SCTP] Replace incorrect use of dev_alloc_skb with=
 alloc_skb in sctp_packet_transmit().")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable, thanks.
