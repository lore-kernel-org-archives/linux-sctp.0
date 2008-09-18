From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 18 Sep 2008 23:01:23 +0000
Subject: Re: [Lksctp-developers] [PATCH 1/2] sctp: do not enable peer features
Message-Id: <48D2DDC3.3060406@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1221773464-28845-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1221773464-28845-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net

David

Can you also queue this one and Patch 2/2 to stable.  The problems
are there as well.

Thanks
-vlad

Vlad Yasevich wrote:
> Do not enable peer features like addip and auth, if they
> are administratively disabled localy.  If the peer resports
> that he supports something that we don't, neither end can
> use it so enabling it is pointless.  This solves a problem
> when talking to a peer that has auth and addip enabled while
> we do not.  Found by Andrei Pelinescu-Onciul <andrei@iptel.org>.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> ---
>  net/sctp/sm_make_chunk.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index e8ca4e5..fe94f42 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1886,11 +1886,13 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
>  			    /* if the peer reports AUTH, assume that he
>  			     * supports AUTH.
>  			     */
> -			    asoc->peer.auth_capable = 1;
> +			    if (sctp_auth_enable)
> +				    asoc->peer.auth_capable = 1;
>  			    break;
>  		    case SCTP_CID_ASCONF:
>  		    case SCTP_CID_ASCONF_ACK:
> -			    asoc->peer.asconf_capable = 1;
> +			    if (sctp_addip_enable)
> +				    asoc->peer.asconf_capable = 1;
>  			    break;
>  		    default:
>  			    break;
> @@ -2460,6 +2462,9 @@ do_addr_param:
>  		break;
>  
>  	case SCTP_PARAM_SET_PRIMARY:
> +		if (!sctp_addip_enable)
> +			goto fall_through;
> +
>  		addr_param = param.v + sizeof(sctp_addip_param_t);
>  
>  		af = sctp_get_af_specific(param_type2af(param.p->type));

