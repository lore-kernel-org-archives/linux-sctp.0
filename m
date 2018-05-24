From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 24 May 2018 19:54:51 +0000
Subject: Re: [PATCH net-next] vrf: add CRC32c offload to device features
Message-Id: <20180524195451.GL26212@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
In-Reply-To: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Davide Caratti <dcaratti@redhat.com>
Cc: David Ahern <dsa@cumulusnetworks.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Thu, May 24, 2018 at 05:49:35PM +0200, Davide Caratti wrote:
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

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  drivers/net/vrf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 90b5f3900c22..f93547f257fb 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -1254,7 +1254,7 @@ static void vrf_setup(struct net_device *dev)
> =20
>  	/* enable offload features */
>  	dev->features   |=3D NETIF_F_GSO_SOFTWARE;
> -	dev->features   |=3D NETIF_F_RXCSUM | NETIF_F_HW_CSUM;
> +	dev->features   |=3D NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CR=
C;
>  	dev->features   |=3D NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
> =20
>  	dev->hw_features =3D dev->features;
> --=20
> 2.17.0
>=20
