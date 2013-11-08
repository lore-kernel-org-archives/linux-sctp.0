From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 08 Nov 2013 18:19:49 +0000
Subject: Re: [PATCH net-next 2/5] sctp: remove the else path
Message-Id: <527D3949.2000302@cogentembedded.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383879310-22792-1-git-send-email-wangweidong1@huawei.com> <1383879310-22792-3-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1383879310-22792-3-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>, vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: dingtianhong@huawei.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hello.

On 11/08/2013 05:55 AM, Wang Weidong wrote:

> Make the code more simplification.

> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>   net/sctp/associola.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)

> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 667f984..2d53d4c 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -954,15 +954,13 @@ int sctp_cmp_addr_exact(const union sctp_addr *ss1,
>    */
>   struct sctp_chunk *sctp_get_ecne_prepend(struct sctp_association *asoc)
>   {
> -	struct sctp_chunk *chunk;
> +	struct sctp_chunk *chunk = NULL;
>
>   	/* Send ECNE if needed.
>   	 * Not being able to allocate a chunk here is not deadly.
>   	 */
>   	if (asoc->need_ecne)
>   		chunk = sctp_make_ecne(asoc, asoc->last_ecne_tsn);
> -	else
> -		chunk = NULL;

    This is hardly better/simpler than it was.

WBR, Sergei

