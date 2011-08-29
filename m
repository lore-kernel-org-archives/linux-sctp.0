From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 29 Aug 2011 21:43:28 +0000
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
Message-Id: <1314654209.2563.7.camel@edumazet-laptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1314650069.git.joe@perches.com>
	 <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
In-Reply-To: <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Joe Perches <joe@perches.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Le lundi 29 août 2011 à 14:17 -0700, Joe Perches a écrit :
> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/sctp/protocol.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 91784f4..0801444 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1326,7 +1326,6 @@ SCTP_STATIC __init int sctp_init(void)
>  			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, order);
>  	} while (!sctp_assoc_hashtable && --order > 0);
>  	if (!sctp_assoc_hashtable) {
> -		pr_err("Failed association hash alloc\n");
>  		status = -ENOMEM;
>  		goto err_ahash_alloc;
>  	}
> @@ -1340,7 +1339,6 @@ SCTP_STATIC __init int sctp_init(void)
>  	sctp_ep_hashtable = (struct sctp_hashbucket *)
>  		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
>  	if (!sctp_ep_hashtable) {
> -		pr_err("Failed endpoint_hash alloc\n");
>  		status = -ENOMEM;
>  		goto err_ehash_alloc;
>  	}
> @@ -1359,7 +1357,6 @@ SCTP_STATIC __init int sctp_init(void)
>  			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, order);
>  	} while (!sctp_port_hashtable && --order > 0);
>  	if (!sctp_port_hashtable) {
> -		pr_err("Failed bind hash alloc\n");
>  		status = -ENOMEM;
>  		goto err_bhash_alloc;
>  	}


It would be nice if you could avoid all these patches, that you dont
even read.

As I already told you in the past, __GFP_NOWARN dont print generic OOM
messages.

Its not because I told Wang Shaoyan not adding a useless "pr_err("Out of
memory\n");" in last gianfar patch, that you have to remove all
messages, with one hundred or more patches.

If I remember well, you even disagreed at that time.

Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
message, is it ?



