From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 May 2018 12:04:34 +0000
Subject: Re: [PATCH net] sctp: use the old asoc when making the cookie-ack chunk in dupcook_d
Message-Id: <20180502120434.GG4977@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <b4d64902d4a8e0774c44752056e35a32d69966a9.1525239586.git.lucien.xin@gmail.com>
In-Reply-To: <b4d64902d4a8e0774c44752056e35a32d69966a9.1525239586.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, May 02, 2018 at 01:39:46PM +0800, Xin Long wrote:
> When processing a duplicate cookie-echo chunk, for case 'D', sctp will
> not process the param from this chunk. It means old asoc has nothing
> to be updated, and the new temp asoc doesn't have the complete info.
>
> So there's no reason to use the new asoc when creating the cookie-ack
> chunk. Otherwise, like when auth is enabled for cookie-ack, the chunk
> can not be set with auth, and it will definitely be dropped by peer.
>
> This issue is there since very beginning, and we fix it by using the
> old asoc instead.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/sm_statefuns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 98acfed..28c070e 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -2056,7 +2056,7 @@ static enum sctp_disposition sctp_sf_do_dupcook_d(
>  		}
>  	}
>
> -	repl = sctp_make_cookie_ack(new_asoc, chunk);
> +	repl = sctp_make_cookie_ack(asoc, chunk);
>  	if (!repl)
>  		goto nomem;
>
> --
> 2.1.0
>
