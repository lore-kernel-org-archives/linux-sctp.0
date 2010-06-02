From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 02 Jun 2010 17:30:57 +0000
Subject: Re: [PATCH 21/21] net/sctp/protocol.c: Remove unnecessary kmalloc
Message-Id: <4C069551.8020106@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1275360951.git.joe@perches.com> <789ef255b7c046dd11fad6ca8c057354b6306c7f.1275360951.git.joe@perches.com>
In-Reply-To: <789ef255b7c046dd11fad6ca8c057354b6306c7f.1275360951.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

ACK

-vlad

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/sctp/protocol.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 1827498..fef38be 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1216,8 +1216,7 @@ SCTP_STATIC __init int sctp_init(void)
>  
>  	/* Allocate and initialize the endpoint hash table.  */
>  	sctp_ep_hashsize = 64;
> -	sctp_ep_hashtable = (struct sctp_hashbucket *)
> -		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
> +	sctp_ep_hashtable = kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
>  	if (!sctp_ep_hashtable) {
>  		printk(KERN_ERR "SCTP: Failed endpoint_hash alloc.\n");
>  		status = -ENOMEM;
