From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 03 Jan 2018 06:45:49 +0000
Subject: Re: [PATCH net] sctp: fix error path in sctp_stream_init
Message-Id: <CADvbK_fxLc5Kg-gzyMXbFeQFbBgNye5=p_9c4j1=7eCnWPBzfA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <74b65f56d6912704f3ef79a46242cc2ca567e4e3.1514928664.git.marcelo.leitner@gmail.com>
In-Reply-To: <74b65f56d6912704f3ef79a46242cc2ca567e4e3.1514928664.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Wed, Jan 3, 2018 at 5:44 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> syzbot noticed a NULL pointer dereference panic in sctp_stream_free()
> which was caused by an incomplete error handling in sctp_stream_init().
> By not clearing stream->outcnt, it made a for() in sctp_stream_free()
> think that it had elements to free, but not, leading to the panic.
>
> As suggested by Xin Long, this patch also simplifies the error path by
> moving it to the only if() that uses it.
>
> See-also: https://www.spinics.net/lists/netdev/msg473756.html
> See-also: https://www.spinics.net/lists/netdev/msg465024.html
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/stream.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 76ea66be0bbee7d3f018676d52c8b95ba06dbcb1..524dfeb94c41ab1ac735746a8acf93af1c96ae48 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -156,9 +156,9 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>         sctp_stream_outq_migrate(stream, NULL, outcnt);
>         sched->sched_all(stream);
>
> -       i = sctp_stream_alloc_out(stream, outcnt, gfp);
> -       if (i)
> -               return i;
> +       ret = sctp_stream_alloc_out(stream, outcnt, gfp);
> +       if (ret)
> +               goto out;
>
>         stream->outcnt = outcnt;
>         for (i = 0; i < stream->outcnt; i++)
> @@ -170,19 +170,17 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>         if (!incnt)
>                 goto out;
>
> -       i = sctp_stream_alloc_in(stream, incnt, gfp);
> -       if (i) {
> -               ret = -ENOMEM;
> -               goto free;
> +       ret = sctp_stream_alloc_in(stream, incnt, gfp);
> +       if (ret) {
> +               sched->free(stream);
> +               kfree(stream->out);
> +               stream->out = NULL;
> +               stream->outcnt = 0;
> +               goto out;
>         }
>
>         stream->incnt = incnt;
> -       goto out;
>
> -free:
> -       sched->free(stream);
> -       kfree(stream->out);
> -       stream->out = NULL;
>  out:
>         return ret;
>  }
> --
> 2.14.3
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
