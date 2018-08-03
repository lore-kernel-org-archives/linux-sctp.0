From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 03 Aug 2018 20:40:11 +0000
Subject: Re: [PATCH v2 1/2] net/sctp: Make wrappers for accessing in/out streams
Message-Id: <20180803204011.GH5482@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <20180803162102.19540-2-khorenko@virtuozzo.com>
In-Reply-To: <20180803162102.19540-2-khorenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Fri, Aug 03, 2018 at 07:21:01PM +0300, Konstantin Khorenko wrote:
> This patch introduces wrappers for accessing in/out streams indirectly.
> This will enable to replace physically contiguous memory arrays
> of streams with flexible arrays (or maybe any other appropriate
> mechanism) which do memory allocation on a per-page basis.
> 
> Signed-off-by: Oleg Babin <obabin@virtuozzo.com>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> 
> ---
> v2 changes:
>  sctp_stream_in() users are updated to provide stream as an argument,
>  sctp_stream_{in,out}_ptr() are now just sctp_stream_{in,out}().
> ---

...

>  
>  struct sctp_stream {
> -	struct sctp_stream_out *out;
> -	struct sctp_stream_in *in;
> +	struct flex_array *out;
> +	struct flex_array *in;

If this patch was meant to be a preparation, shouldn't this belong to
the next patch instead?

  Marcelo
