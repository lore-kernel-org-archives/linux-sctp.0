From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Tue, 18 Aug 2020 21:46:48 +0000
Subject: Re: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Message-Id: <20200818214648.GJ3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
In-Reply-To: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>

On Tue, Aug 18, 2020 at 02:36:58PM +0000, David Laight wrote:
> The number of streams offered by the remote system was being ignored.
> Any data sent on those streams would get discarded by the remote system.

That's quite brief and not accurate: it was only ignored if 'Xcnt <stream->Xcnt'.

Other than this and the Fixes tag, LGTM. Passes the tests here. I'll
ack the v2 then.

> 
> Fixes 2075e50caf5ea.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  net/sctp/stream.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> This needs backporting to 5.1 and all later kernels.

A 'net' tree tag in patch tags is welcomed.

> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index bda2536dd740..6dc95dcc0ff4 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -88,12 +88,13 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
>  	int ret;
>  
>  	if (outcnt <= stream->outcnt)
> -		return 0;
> +		goto out;
>  
>  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
>  	if (ret)
>  		return ret;
>  
> +out:
>  	stream->outcnt = outcnt;
>  	return 0;
>  }
> @@ -104,12 +105,13 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
>  	int ret;
>  
>  	if (incnt <= stream->incnt)
> -		return 0;
> +		goto out;
>  
>  	ret = genradix_prealloc(&stream->in, incnt, gfp);
>  	if (ret)
>  		return ret;
>  
> +out:
>  	stream->incnt = incnt;
>  	return 0;
>  }
> -- 
> 2.25.1
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
