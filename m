From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 17 Apr 2008 20:29:12 +0000
Subject: Re: [PATCH] SCTP: Initialize partial_bytes_acked to 0, when all of
Message-Id: <4807B318.2000307@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4805A2CA.7030808@cn.fujitsu.com>
In-Reply-To: <4805A2CA.7030808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, lksctp-dev <lksctp-developers@lists.sourceforge.net>, linux-sctp@vger.kernel.org

Gui Jianfeng wrote:
> Vlad,
> According to RFC4960 7.2.2, 
> When all of the data transmitted by the sender has
> been acknowledged by the recerver, partial_bytes_acked is initialized to 0.
> 
> This patch conforms to rfc requirement. 
> Without this fix, cwnd might be error incremented.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  net/sctp/outqueue.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index c071446..cf79485 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -1544,6 +1544,9 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  						  bytes_acked);
>  
>  			transport->flight_size -= bytes_acked;
> +			if (transport->flight_size = 0) {
> +				transport->partial_bytes_acked = 0;
> +			}
>  			q->outstanding_bytes -= bytes_acked;
>  		} else {
>  			/* RFC 2960 6.1, sctpimpguide-06 2.15.2

Loose the braces, otherwise looks good.

-vlad

