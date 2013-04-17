From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 17 Apr 2013 15:32:57 +0000
Subject: Re: [PATCH net-next 5/9] net: sctp: outqueue: simplify sctp_outq_uncork function
Message-Id: <20130417153257.GF5149@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
 <1366146438-8815-6-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-6-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Tue, Apr 16, 2013 at 11:07:14PM +0200, Daniel Borkmann wrote:
> Just a minor edit to simplify the function. No need for this
> error variable here.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  net/sctp/outqueue.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index d4c137e..32a4625 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -701,11 +701,10 @@ redo:
>  /* Cork the outqueue so queued chunks are really queued. */
>  int sctp_outq_uncork(struct sctp_outq *q)
>  {
> -	int error = 0;
>  	if (q->cork)
>  		q->cork = 0;
> -	error = sctp_outq_flush(q, 0);
> -	return error;
> +
> +	return sctp_outq_flush(q, 0);
>  }
>  
>  
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
