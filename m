From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 02 Jul 2018 11:45:12 +0000
Subject: Re: [PATCH net] sctp: fix the issue that pathmtu may be set lower than MINSEGMENT
Message-Id: <20180702114512.GA15612@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <0928f7dda7db59c8aa01e97a87792d9e643e70ab.1530514276.git.lucien.xin@gmail.com>
In-Reply-To: <0928f7dda7db59c8aa01e97a87792d9e643e70ab.1530514276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzkaller@googlegroups.com

On Mon, Jul 02, 2018 at 02:51:16PM +0800, Xin Long wrote:
> After commit b6c5734db070 ("sctp: fix the handling of ICMP Frag Needed
> for too small MTUs"), sctp_transport_update_pmtu would refetch pathmtu
> from the dst and set it to transport's pathmtu without any check.
> 
> The new pathmtu may be lower than MINSEGMENT if the dst is obsolete and
> updated by .get_dst() in sctp_transport_update_pmtu.
> 
> Syzbot reported a warning in sctp_mtu_payload caused by this.
> 
> This fix uses the refetched pathmtu only when it's greater than the
> frag_needed pmtu.
> 
> Fixes: b6c5734db070 ("sctp: fix the handling of ICMP Frag Needed for too small MTUs")
> Reported-by: syzbot+f0d9d7cba052f9344b03@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/transport.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index 445b7ef..ddfb687 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -282,7 +282,10 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
>  
>  	if (dst) {
>  		/* Re-fetch, as under layers may have a higher minimum size */
> -		pmtu = SCTP_TRUNC4(dst_mtu(dst));
> +		u32 mtu = SCTP_TRUNC4(dst_mtu(dst));
> +
> +		if (pmtu < mtu)
> +			pmtu = mtu;
nit, but why not u32 mtu = min(pmtu, SCTP_TRUNC4(dst_mtu(dst))) here ?

Neil

>  		change = t->pathmtu != pmtu;
>  	}
>  	t->pathmtu = pmtu;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
