From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 03 Aug 2018 16:41:38 +0000
Subject: RE: [PATCH v2 1/2] net/sctp: Make wrappers for accessing in/out streams
Message-Id: <64cefdadefae4961a111d442b3ee8af2@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <20180803162102.19540-2-khorenko@virtuozzo.com>
In-Reply-To: <20180803162102.19540-2-khorenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Konstantin Khorenko' <khorenko@virtuozzo.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "oleg.babin@gmail.com" <oleg.babin@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

From: Konstantin Khorenko
> Sent: 03 August 2018 17:21
...
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -37,6 +37,18 @@
>  #include <net/sctp/sm.h>
>  #include <net/sctp/stream_sched.h>
> 
> +struct sctp_stream_out *sctp_stream_out(const struct sctp_stream *stream,
> +					__u16 sid)
> +{
> +	return ((struct sctp_stream_out *)(stream->out)) + sid;
> +}
> +
> +struct sctp_stream_in *sctp_stream_in(const struct sctp_stream *stream,
> +				      __u16 sid)
> +{
> +	return ((struct sctp_stream_in *)(stream->in)) + sid;
> +}
> +

Those look like they ought to be static inlines in the header file.
Otherwise you'll be making SCTP performance worse that it is already.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

