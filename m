From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 17 Apr 2013 15:31:25 +0000
Subject: Re: [PATCH net-next 4/9] net: sctp: sctp_outq: consolidate chars into bitfield
Message-Id: <20130417153125.GE5149@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
 <1366146438-8815-5-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-5-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Tue, Apr 16, 2013 at 11:07:13PM +0200, Daniel Borkmann wrote:
> sctp_outq structure members fast_rtx, cork and empty are all
> of type char. Consolidate them into a single __u8 bitfield since
> they either carry 0 or 1. Have the rest 5 bits for future flags.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  include/net/sctp/structs.h | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 73fd5de..3de5985 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1051,14 +1051,9 @@ struct sctp_outq {
>  	/* How many unackd bytes do we have in-flight?	*/
>  	__u32 outstanding_bytes;
>  
> -	/* Are we doing fast-rtx on this queue */
> -	char fast_rtx;
> -
> -	/* Corked? */
> -	char cork;
> -
> -	/* Is this structure empty?  */
> -	char empty;
> +	__u8 fast_rtx:1,	/* Are we doing fast-rtx on this queue */
> +	     cork:1,		/* Corked? */
> +	     empty:1;		/* Is this structure empty?  */
>  };
>  
>  void sctp_outq_init(struct sctp_association *, struct sctp_outq *);
> -- 
> 1.7.11.7
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
