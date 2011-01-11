From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 11 Jan 2011 01:18:02 +0000
Subject: Re: [PATCH 1/2] sctp: Remove variables that are only written to
Message-Id: <4D2BAFCA.6030501@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1294657090-2789-2-git-send-email-holger@freyther.de>
In-Reply-To: <1294657090-2789-2-git-send-email-holger@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Holger Hans Peter Freyther wrote, at 01/10/2011 06:58 PM:
> From: Holger Hans Peter Freyther <zecke@selfish.org>
> 
> The following variables only get a simple assignment but
> are never read from. Remove these variables.
> 
> Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
> ---
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 471e048..e052243 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -986,14 +986,11 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct sk_buff *skb,
>  	union sctp_addr addr;
>  	union sctp_addr *paddr = &addr;
>  	struct sctphdr *sh = sctp_hdr(skb);
> -	sctp_chunkhdr_t *ch;
>  	union sctp_params params;
>  	sctp_init_chunk_t *init;
>  	struct sctp_transport *transport;
>  	struct sctp_af *af;
>  
> -	ch = (sctp_chunkhdr_t *) skb->data;
> -
>  	/*
>  	 * This code will NOT touch anything inside the chunk--it is
>  	 * strictly READ-ONLY.

This part has been submmited in a patch.

See:http://git.kernel.org/?p=linux/kernel/git/vxy/lksctp-dev.git;a=commitdiff;hJ5161a90560703ca1a720aca3081e6f5a43395c;hpz86dbe071e6d9d7d3446c140275c483ec8db639

-- 
Best Regards
-----
Shan Wei
