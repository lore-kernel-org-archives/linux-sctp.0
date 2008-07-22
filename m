From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 22 Jul 2008 18:05:32 +0000
Subject: Re: [2.6 patch] make sctp_outq_flush() static
Message-Id: <20080722180532.GD6887@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080722172045.GT14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080722172045.GT14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, "David S. Miller" <davem@davemloft.net>, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Tue, Jul 22, 2008 at 08:20:45PM +0300, Adrian Bunk wrote:
> sctp_outq_flush() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
> 
>  include/net/sctp/structs.h |    1 -
>  net/sctp/outqueue.c        |    4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> 9fc45261b127e54b1c5982b629956db9351e3b1f 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 70eb64a..535a18f 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1161,7 +1161,6 @@ void sctp_outq_init(struct sctp_association *, struct sctp_outq *);
>  void sctp_outq_teardown(struct sctp_outq *);
>  void sctp_outq_free(struct sctp_outq*);
>  int sctp_outq_tail(struct sctp_outq *, struct sctp_chunk *chunk);
> -int sctp_outq_flush(struct sctp_outq *, int);
>  int sctp_outq_sack(struct sctp_outq *, struct sctp_sackhdr *);
>  int sctp_outq_is_empty(const struct sctp_outq *);
>  void sctp_outq_restart(struct sctp_outq *);
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 70ead8d..4328ad5 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -71,6 +71,8 @@ static void sctp_mark_missing(struct sctp_outq *q,
>  
>  static void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 sack_ctsn);
>  
> +static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout);
> +
>  /* Add data to the front of the queue. */
>  static inline void sctp_outq_head_data(struct sctp_outq *q,
>  					struct sctp_chunk *ch)
> @@ -712,7 +714,7 @@ int sctp_outq_uncork(struct sctp_outq *q)
>   * locking concerns must be made.  Today we use the sock lock to protect
>   * this function.
>   */
> -int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
> +static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  {
>  	struct sctp_packet *packet;
>  	struct sctp_packet singleton;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
