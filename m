From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 02 Sep 2009 14:41:43 +0000
Subject: Re: [PATCH 1/2] sctp: fix to reset packet information after packet
Message-Id: <4A9E8427.8020900@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A9DFD1D.8050009@cn.fujitsu.com>
In-Reply-To: <4A9DFD1D.8050009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> The packet information does not reset after packet transmit, this
> may cause some problems such as following DATA chunk be sent without
> AUTH chunk, even if the authentication of DATA chunk has been
> requested by the peer.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/output.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index b94c211..fbbfbce 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -599,6 +599,11 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>  
>  out:
>  	packet->size = packet->overhead;
> +	packet->has_cookie_echo = 0;
> +	packet->has_sack = 0;
> +	packet->has_data = 0;
> +	packet->ipfragok = 0;
> +	packet->auth = NULL;

I'll stick this into sctp_packet_reset().  OK?

-vlad

>  	return err;
>  no_route:
>  	kfree_skb(nskb);

