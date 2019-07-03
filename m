From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 03 Jul 2019 12:26:23 +0000
Subject: Re: [PATCH net] sctp: count data bundling sack chunk for outctrlchunks
Message-Id: <20190703122623.GC2747@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
In-Reply-To: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, Jul 03, 2019 at 06:20:20PM +0800, Xin Long wrote:
> Now all ctrl chunks are counted for asoc stats.octrlchunks and net
> SCTP_MIB_OUTCTRLCHUNKS either after queuing up or bundling, other
> than the chunk maked and bundled in sctp_packet_bundle_sack, which
> caused 'outctrlchunks' not consistent with 'inctrlchunks' in peer.
> 
> This issue exists since very beginning, here to fix it by increasing
> both net SCTP_MIB_OUTCTRLCHUNKS and asoc stats.octrlchunks when sack
> chunk is maked and bundled in sctp_packet_bundle_sack.
> 
> Reported-by: Ja Ram Jeon <jajeon@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/output.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index e0c2747..dbda7e7 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -282,6 +282,9 @@ static enum sctp_xmit sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  					sctp_chunk_free(sack);
>  					goto out;
>  				}
> +				SCTP_INC_STATS(sock_net(asoc->base.sk),
> +					       SCTP_MIB_OUTCTRLCHUNKS);
> +				asoc->stats.octrlchunks++;
>  				asoc->peer.sack_needed = 0;
>  				if (del_timer(timer))
>  					sctp_association_put(asoc);
> -- 
> 2.1.0
> 
