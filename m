From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 25 Oct 2013 23:43:20 +0000
Subject: Re: [PATCH 3/4] sctp: fix some comments in associola.c
Message-Id: <526B0218.2070809@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382665805-13952-1-git-send-email-wangweidong1@huawei.com> <1382665805-13952-4-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1382665805-13952-4-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>, davem@davemloft.net, nhorman@tuxdriver.com
Cc: dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 10/24/2013 09:50 PM, Wang Weidong wrote:
> fix some spellings
>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/associola.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index cef5099..c9b91cb 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -602,7 +602,7 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
>
>   		/* Start a T3 timer here in case it wasn't running so
>   		 * that these migrated packets have a chance to get
> -		 * retrnasmitted.
> +		 * retransmitted.
>   		 */
>   		if (!timer_pending(&active->T3_rtx_timer))
>   			if (!mod_timer(&active->T3_rtx_timer,
> @@ -665,7 +665,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
>   	/* Set the path max_retrans.  */
>   	peer->pathmaxrxt = asoc->pathmaxrxt;
>
> -	/* And the partial failure retrnas threshold */
> +	/* And the partial failure retrans threshold */
>   	peer->pf_retrans = asoc->pf_retrans;
>
>   	/* Initialize the peer's SACK delay timeout based on the
>

