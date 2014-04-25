From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 25 Apr 2014 13:39:38 +0000
Subject: Re: [PATCH net] net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Retra
Message-Id: <535A659A.1050805@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1398432520-19863-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1398432520-19863-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Karl Heiss <kheiss@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com

On 04/25/2014 09:28 AM, Karl Heiss wrote:
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

Hi Karl

Please mark your patch versions.

I send a comment for the prior version you sent, but I'll say it here as
well.  It would be better that you make it explicit that transition
from INACTIVE to PF is not allowed by using transport state.

-vlad

> Signed-off-by: Karl Heiss <kheiss@gmail.com>
> ---
>  net/sctp/sm_sideeffect.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 5d6883f..07f26fe 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -502,7 +502,8 @@ static void sctp_do_8_2_transport_strike(sctp_cmd_seq_t *commands,
>  	if ((transport->state != SCTP_PF) &&
>  	   (transport->state != SCTP_UNCONFIRMED) &&
>  	   (asoc->pf_retrans < transport->pathmaxrxt) &&
> -	   (transport->error_count > asoc->pf_retrans)) {
> +	   (transport->error_count > asoc->pf_retrans) &&
> +	   (transport->error_count <= transport->pathmaxrxt)) {
>  
>  		sctp_assoc_control_transport(asoc, transport,
>  					     SCTP_TRANSPORT_PF,
> 

