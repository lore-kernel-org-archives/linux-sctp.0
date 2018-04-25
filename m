From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 25 Apr 2018 11:47:57 +0000
Subject: Re: [PATCH net-next] sctp: fix identification of new acks for SFR-CACC
Message-Id: <20180425114757.GB17646@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4e837f7eaf67a1a964d1b3418aa3cf759f512535.1524603870.git.marcelo.leitner@gmail.com>
In-Reply-To: <4e837f7eaf67a1a964d1b3418aa3cf759f512535.1524603870.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

On Tue, Apr 24, 2018 at 06:17:35PM -0300, Marcelo Ricardo Leitner wrote:
> It's currently written as:
> 
> if (!tchunk->tsn_gap_acked) {   [1]
> 	tchunk->tsn_gap_acked = 1;
> 	...
> }
> 
> if (TSN_lte(tsn, sack_ctsn)) {
> 	if (!tchunk->tsn_gap_acked) {
> 		/* SFR-CACC processing */
> 		...
> 	}
> }
> 
> Which causes the SFR-CACC processing on ack reception to never process,
> as tchunk->tsn_gap_acked is always true by then. Block [1] was
> moved to that position by the commit marked below.
> 
> This patch fixes it by doing SFR-CACC processing earlier, before
> tsn_gap_acked is set to true.
> 
> Fixes: 31b02e154940 ("sctp: Failover transmitted list on transport delete")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> 
> Even though this is a -stable candidate, please apply it to net-next
> to avoid conflicts with subsequent patches in my queue. Thanks.
> 
>  net/sctp/outqueue.c | 48 +++++++++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 25 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index f211b3db6a3543073e113da121bb28518b0af491..dee7cbd5483149024f2f3195db2fe4d473b1a00a 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -1457,7 +1457,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  			 * the outstanding bytes for this chunk, so only
>  			 * count bytes associated with a transport.
>  			 */
> -			if (transport) {
> +			if (transport && !tchunk->tsn_gap_acked) {
>  				/* If this chunk is being used for RTT
>  				 * measurement, calculate the RTT and update
>  				 * the RTO using this value.
> @@ -1469,14 +1469,34 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  				 * first instance of the packet or a later
>  				 * instance).
>  				 */
> -				if (!tchunk->tsn_gap_acked &&
> -				    !sctp_chunk_retransmitted(tchunk) &&
> +				if (!sctp_chunk_retransmitted(tchunk) &&
>  				    tchunk->rtt_in_progress) {
>  					tchunk->rtt_in_progress = 0;
>  					rtt = jiffies - tchunk->sent_at;
>  					sctp_transport_update_rto(transport,
>  								  rtt);
>  				}
> +
> +				if (TSN_lte(tsn, sack_ctsn)) {
> +					/*
> +					 * SFR-CACC algorithm:
> +					 * 2) If the SACK contains gap acks
> +					 * and the flag CHANGEOVER_ACTIVE is
> +					 * set the receiver of the SACK MUST
> +					 * take the following action:
> +					 *
> +					 * B) For each TSN t being acked that
> +					 * has not been acked in any SACK so
> +					 * far, set cacc_saw_newack to 1 for
> +					 * the destination that the TSN was
> +					 * sent to.
> +					 */
> +					if (sack->num_gap_ack_blocks &&
> +					    q->asoc->peer.primary_path->cacc.
> +					    changeover_active)
> +						transport->cacc.cacc_saw_newack
> +							= 1;
> +				}
>  			}
> 
>  			/* If the chunk hasn't been marked as ACKED,
> @@ -1508,28 +1528,6 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  				restart_timer = 1;
>  				forward_progress = true;
> 
> -				if (!tchunk->tsn_gap_acked) {
> -					/*
> -					 * SFR-CACC algorithm:
> -					 * 2) If the SACK contains gap acks
> -					 * and the flag CHANGEOVER_ACTIVE is
> -					 * set the receiver of the SACK MUST
> -					 * take the following action:
> -					 *
> -					 * B) For each TSN t being acked that
> -					 * has not been acked in any SACK so
> -					 * far, set cacc_saw_newack to 1 for
> -					 * the destination that the TSN was
> -					 * sent to.
> -					 */
> -					if (transport &&
> -					    sack->num_gap_ack_blocks &&
> -					    q->asoc->peer.primary_path->cacc.
> -					    changeover_active)
> -						transport->cacc.cacc_saw_newack
> -							= 1;
> -				}
> -
>  				list_add_tail(&tchunk->transmitted_list,
>  					      &q->sacked);
>  			} else {
> --
> 2.14.3
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
