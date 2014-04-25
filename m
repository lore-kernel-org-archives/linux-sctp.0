From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 25 Apr 2014 19:58:40 +0000
Subject: Re: [PATCH v4 net] net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Re
Message-Id: <535ABE70.6020200@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1398450390-23630-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1398450390-23630-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Karl Heiss <kheiss@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com

On 04/25/2014 02:26 PM, Karl Heiss wrote:
> Don't transition to the PF state on every strike after 'Path.Max.Retrans'.
> Per draft-ietf-tsvwg-sctp-failover-03 Section 5.1.6:
> 
>    Additional (PMR - PFMR) consecutive timeouts on a PF destination
>    confirm the path failure, upon which the destination transitions to the
>    Inactive state.  As described in [RFC4960], the sender (i) SHOULD notify
>    ULP about this state transition, and (ii) transmit heartbeats to the
>    Inactive destination at a lower frequency as described in Section 8.3 of
>    [RFC4960].
> 
> This also prevents sending SCTP_ADDR_UNREACHABLE to the user as the state
> bounces between SCTP_INACTIVE and SCTP_PF for each subsequent strike.
> 
> Signed-off-by: Karl Heiss <kheiss@gmail.com>

Hi Karl

Looks good.  Thanks.

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
> Changes in v2:
>   - Flesh out commit message
> 
> Changes in v3:
>   - Compare transport state instead of pathmaxrxt
> 
> Changes in v4:
>   - Simplify transport state comparison
> 
>  net/sctp/sm_sideeffect.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 5d6883f..f900f8e 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -496,11 +496,10 @@ static void sctp_do_8_2_transport_strike(sctp_cmd_seq_t *commands,
>  
>  	/* If the transport error count is greater than the pf_retrans
>  	 * threshold, and less than pathmaxrtx, and if the current state
> -	 * is not SCTP_UNCONFIRMED, then mark this transport as Partially
> -	 * Failed, see SCTP Quick Failover Draft, section 5.1
> +	 * is SCTP_ACTIVE, then mark this transport as Partially Failed, 
> +	 * see SCTP Quick Failover Draft, section 5.1
>  	 */
> -	if ((transport->state != SCTP_PF) &&
> -	   (transport->state != SCTP_UNCONFIRMED) &&
> +	if ((transport->state = SCTP_ACTIVE) &&
>  	   (asoc->pf_retrans < transport->pathmaxrxt) &&
>  	   (transport->error_count > asoc->pf_retrans)) {
>  
> 

