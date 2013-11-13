From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 13 Nov 2013 02:37:45 +0000
Subject: Re: [PATCH 1/1] net: sctp: bug fixing when sctp path recovers
Message-Id: <5282E5F9.5000506@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1384306486-31345-1-git-send-email-changxiangzhong@gmail.com>
In-Reply-To: <1384306486-31345-1-git-send-email-changxiangzhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chang Xiangzhong <changxiangzhong@gmail.com>, nhorman@tuxdriver.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dreibh@simula.no

On 11/12/2013 08:34 PM, Chang Xiangzhong wrote:
> Look for the __two__ most recently used path/transport and set to active_path
> and retran_path respectively
>
> Signed-off-by: changxiangzhong@gmail.com
> ---
>   net/sctp/associola.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index ab67efc..070011a 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -913,11 +913,15 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>   		if (!first || t->last_time_heard > first->last_time_heard) {
>   			second = first;
>   			first = t;
> +			continue;
>   		}
>   		if (!second || t->last_time_heard > second->last_time_heard)
>   			second = t;

You might as well remove this bit and then you don't need a continue.

>   	}
>
> +	if (!second)
> +		second = first;
> +

This needs to move down 1 more block.  Set the second transport after we
check to see if the primary is back up and we need to go back to using it.

-vlad

>   	/* RFC 2960 6.4 Multi-Homed SCTP Endpoints
>   	 *
>   	 * By default, an endpoint should always transmit to the
>

