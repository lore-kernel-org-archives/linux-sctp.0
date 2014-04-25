From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 25 Apr 2014 13:35:26 +0000
Subject: Re: [PATCH net] net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Retra
Message-Id: <535A649E.4090309@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1398367008-27452-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1398367008-27452-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Karl Heiss <kheiss@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

On 04/24/2014 03:16 PM, Karl Heiss wrote:
> Don't transition to the PF state on every strike after 'Path.Max.Retrans'. This
> also prevents sending SCTP_ADDR_UNREACHABLE to the user as the state bounces
> between SCTP_INACTIVE and SCTP_PF for each subsequent strike.
> 

Good catch.  We should never move to PF from INACTIVE.  I'd rather you
make it explicit by checking state rather then error counts.

Thanks
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

