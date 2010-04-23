From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 23 Apr 2010 14:28:45 +0000
Subject: Re: [patch] sctp: cleanup: remove unneeded null check
Message-Id: <4BD1AE9D.6090807@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100423115906.GE29093@bicker>
In-Reply-To: <20100423115906.GE29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <error27@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>, Chris Dischino <cdischino@sonusnet.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org



Dan Carpenter wrote:
> "chunk" can never be null here.  We dereferenced it earlier in the
> function and also at the start of the function we passed it to 
> sctp_pack_cookie() which dereferences it.
> 
> This code has been around since the dawn of git history so if "chunk"
> were ever null someone would have complained about it.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 17cb400..52352fc 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -470,8 +470,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
>  	 *
>  	 * [INIT ACK back to where the INIT came from.]
>  	 */
> -	if (chunk)
> -		retval->transport = chunk->transport;
> +	retval->transport = chunk->transport;
>  

Actually, this code can be completely removed as we already make this assignment
earlier:

        /* Per the advice in RFC 2960 6.4, send this reply to
         * the source of the INIT packet.
         */
        retval->transport = chunk->transport;
        retval->subh.init_hdr                 sctp_addto_chunk(retval, sizeof(initack), &initack);

-vlad

>  nomem_chunk:
>  	kfree(cookie);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


