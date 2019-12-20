From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Dec 2019 16:17:56 +0000
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
Message-Id: <20191220161756.GE5058@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191220044703.88-1-qdkevin.kou@gmail.com>
In-Reply-To: <20191220044703.88-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kevin Kou <qdkevin.kou@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
> The function sctp_sf_eat_sack_6_2 now performs
> the Verification Tag validation, Chunk length validation, Bogu check,
> and also the detection of out-of-order SACK based on the RFC2960
> Section 6.2 at the beginning, and finally performs the further
> processing of SACK. The trace_sctp_probe now triggered before
> the above necessary validation and check.
> 
> This patch is to do the trace_sctp_probe after the necessary check
> and validation to SACK.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 42558fa..b4a54df 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	struct sctp_sackhdr *sackh;
>  	__u32 ctsn;
>  
> -	trace_sctp_probe(ep, asoc, chunk);
>  
>  	if (!sctp_vtag_verify(chunk, asoc))
>  		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> @@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	if (!TSN_lt(ctsn, asoc->next_tsn))
>  		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
>  
> +	trace_sctp_probe(ep, asoc, chunk);
> +

Moving it here will be after the check against ctsn_ack_point, which
could cause duplicated SACKs to be missed from the log.

Yes, from the sender-side CC we don't care about it (yet), but it
helps to spot probably avoidable retransmissions.

I think this is cleaning up the noise too much. I can agree with
moving it to after the chunk sanity tests, though.

>  	/* Return this SACK for further processing.  */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>  
> -- 
> 1.8.3.1
> 
