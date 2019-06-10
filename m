From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 10 Jun 2019 16:54:22 +0000
Subject: Re: [PATCH] Free cookie before we memdup a new one
Message-Id: <CADvbK_czxOqGPDCZmvZgP6A7aSKC-W4U2WaAwL89uBpi4EEVog@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
In-Reply-To: <20190610163456.7778-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>

On Tue, Jun 11, 2019 at 12:35 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
>
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
Hi, Neil,

I think we should also do the same thing to the other 2 kmemdups in
sctp_process_param():
asoc->peer.peer_random
asoc->peer.peer_hmacs


>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: Xin Long <lucien.xin@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org
> ---
>  net/sctp/sm_make_chunk.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index f17908f5c4f3..21f7faf032e5 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2583,6 +2583,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>         case SCTP_PARAM_STATE_COOKIE:
>                 asoc->peer.cookie_len >                         ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> +               if (asoc->peer.cookie)
> +                       kfree(asoc->peer.cookie);
>                 asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>                 if (!asoc->peer.cookie)
>                         retval = 0;
> --
> 2.20.1
>
