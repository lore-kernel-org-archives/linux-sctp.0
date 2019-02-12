From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 12 Feb 2019 15:46:55 +0000
Subject: Re: [PATCH net] sctp: set stream ext to NULL after freeing it in sctp_stream_outq_migrate
Message-Id: <20190212154655.GA2151@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <0cb9e543c21495df48c3723044d6c9f64f238eca.1549968661.git.lucien.xin@gmail.com>
In-Reply-To: <0cb9e543c21495df48c3723044d6c9f64f238eca.1549968661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Tue, Feb 12, 2019 at 06:51:01PM +0800, Xin Long wrote:
> In sctp_stream_init(), after sctp_stream_outq_migrate() freed the
> surplus streams' ext, but sctp_stream_alloc_out() returns -ENOMEM,
> stream->outcnt will not be set to 'outcnt'.
> 
> With the bigger value on stream->outcnt, when closing the assoc and
> freeing its streams, the ext of those surplus streams will be freed
> again since those stream exts were not set to NULL after freeing in
> sctp_stream_outq_migrate(). Then the invalid-free issue reported by
> syzbot would be triggered.
> 
> We fix it by simply setting them to NULL after freeing.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reported-by: syzbot+58e480e7b28f2d890bfd@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/stream.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index f246331..2936ed1 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -144,8 +144,10 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>  		}
>  	}
>  
> -	for (i = outcnt; i < stream->outcnt; i++)
> +	for (i = outcnt; i < stream->outcnt; i++) {
>  		kfree(SCTP_SO(stream, i)->ext);
> +		SCTP_SO(stream, i)->ext = NULL;
> +	}
>  }
>  
>  static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
