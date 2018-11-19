From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 19 Nov 2018 17:50:14 +0000
Subject: Re: [PATCH net] Revert "sctp: remove sctp_transport_pmtu_check"
Message-Id: <20181119175014.GC7622@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <722a49900dadb13e3a97a63d54561418db28e1cc.1542528887.git.lucien.xin@gmail.com>
In-Reply-To: <722a49900dadb13e3a97a63d54561418db28e1cc.1542528887.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Sun, Nov 18, 2018 at 04:14:47PM +0800, Xin Long wrote:
> This reverts commit 22d7be267eaa8114dcc28d66c1c347f667d7878a.
> 
> The dst's mtu in transport can be updated by a non sctp place like
> in xfrm where the MTU information didn't get synced between asoc,
> transport and dst, so it is still needed to do the pmtu check
> in sctp_packet_config.
> ---
>  include/net/sctp/sctp.h | 12 ++++++++++++
>  net/sctp/output.c       |  3 +++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 8c2caa3..ab9242e 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -608,4 +608,16 @@ static inline __u32 sctp_dst_mtu(const struct dst_entry *dst)
>  				 SCTP_DEFAULT_MINSEGMENT));
>  }
>  
> +static inline bool sctp_transport_pmtu_check(struct sctp_transport *t)
> +{
> +	__u32 pmtu = sctp_dst_mtu(t->dst);
> +
> +	if (t->pathmtu = pmtu)
> +		return true;
> +
> +	t->pathmtu = pmtu;
> +
> +	return false;
> +}
> +
>  #endif /* __net_sctp_h__ */
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 67939ad..0860122 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -118,6 +118,9 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
>  		sctp_transport_route(tp, NULL, sp);
>  		if (asoc->param_flags & SPP_PMTUD_ENABLE)
>  			sctp_assoc_sync_pmtu(asoc);
> +	} else if (!sctp_transport_pmtu_check(tp)) {
> +		if (asoc->param_flags & SPP_PMTUD_ENABLE)
> +			sctp_assoc_sync_pmtu(asoc);
>  	}
>  
>  	if (asoc->pmtu_pending) {
> -- 
> 2.1.0
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
