From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 15:53:00 +0000
Subject: Re: [PATCH net] sctp: clear the new asoc's stream outcnt in sctp_stream_update
Message-Id: <20180426155300.GB3814@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a1180e29789ab0aa339ae8b456a100520ffcdc5.1524727304.git.lucien.xin@gmail.com>
In-Reply-To: <7a1180e29789ab0aa339ae8b456a100520ffcdc5.1524727304.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Thu, Apr 26, 2018 at 03:21:44PM +0800, Xin Long wrote:
> When processing a duplicate cookie-echo chunk, sctp moves the new
> temp asoc's stream out/in into the old asoc, and later frees this
> new temp asoc.
>
> But now after this move, the new temp asoc's stream->outcnt is not
> cleared while stream->out is set to NULL, which would cause a same
> crash as the one fixed in Commit 79d0895140e9 ("sctp: fix error
> path in sctp_stream_init") when freeing this asoc later.
>
> This fix is to clear this outcnt in sctp_stream_update.
>
> Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/stream.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index f799043..f1f1d1b 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -240,6 +240,8 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new)
>
>  	new->out = NULL;
>  	new->in  = NULL;
> +	new->outcnt = 0;
> +	new->incnt  = 0;
>  }
>
>  static int sctp_send_reconf(struct sctp_association *asoc,
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
