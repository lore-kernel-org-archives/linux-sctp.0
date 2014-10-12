From: Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 12 Oct 2014 00:36:18 +0000
Subject: Re: [PATCH net-next] Removed unused function sctp_addr_is_valid()
Message-Id: <20141012003618.GA14547@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1413037764-12165-1-git-send-email-sebastien.barre@uclouvain.be>
In-Reply-To: <1413037764-12165-1-git-send-email-sebastien.barre@uclouvain.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Sat, Oct 11, 2014 at 04:29:24PM +0200, S=E9bastien Barr=E9 wrote:
> sctp_addr_is_valid() only appeared in its definition.
>=20
> Signed-off-by: S=E9bastien Barr=E9 <sebastien.barre@uclouvain.be>
>=20
> ---
>  include/net/sctp/structs.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 4ff3f67..806e3b5 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1116,7 +1116,6 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *b=
p, __u8 *raw, int len,
>  sctp_scope_t sctp_scope(const union sctp_addr *);
>  int sctp_in_scope(struct net *net, const union sctp_addr *addr, const sc=
tp_scope_t scope);
>  int sctp_is_any(struct sock *sk, const union sctp_addr *addr);
> -int sctp_addr_is_valid(const union sctp_addr *addr);
>  int sctp_is_ep_boundall(struct sock *sk);
> =20
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> =20
> --=20
> tg: (64b1f00..) net-next/removed-unused-sctp-function (depends on: net-ne=
xt/master)
>=20
