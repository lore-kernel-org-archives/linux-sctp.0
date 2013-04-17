From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 17 Apr 2013 12:57:30 +0000
Subject: Re: [PATCH net-next 3/9] net: sctp: sctp_outq: remove 'malloced' from its struct
Message-Id: <20130417125729.GC5149@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
 <1366146438-8815-4-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-4-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Tue, Apr 16, 2013 at 11:07:12PM +0200, Daniel Borkmann wrote:
> sctp_outq is embedded into sctp_association, and thus never
> kmalloced in any way. Also, malloced is always 0, thus kfree()
> is never called. Therefore, remove that dead piece of code.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  include/net/sctp/structs.h | 3 ---
>  net/sctp/outqueue.c        | 6 ------
>  2 files changed, 9 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 125a19c..73fd5de 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1059,9 +1059,6 @@ struct sctp_outq {
>  
>  	/* Is this structure empty?  */
>  	char empty;
> -
> -	/* Are we kfree()able? */
> -	char malloced;
>  };
>  
>  void sctp_outq_init(struct sctp_association *, struct sctp_outq *);
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 01dca75..d4c137e 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -217,8 +217,6 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
>  	q->outstanding_bytes = 0;
>  	q->empty = 1;
>  	q->cork  = 0;
> -
> -	q->malloced = 0;
>  	q->out_qlen = 0;
>  }
>  
> @@ -295,10 +293,6 @@ void sctp_outq_free(struct sctp_outq *q)
>  {
>  	/* Throw away leftover chunks. */
>  	__sctp_outq_teardown(q);
> -
> -	/* If we were kmalloc()'d, free the memory.  */
> -	if (q->malloced)
> -		kfree(q);
>  }
>  
>  /* Put a new chunk in an sctp_outq.  */
> -- 
> 1.7.11.7
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
