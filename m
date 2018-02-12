From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 12 Feb 2018 14:01:58 +0000
Subject: Re: [PATCH net] sctp: add SCTP_CID_I_DATA and SCTP_CID_I_FWD_TSN conversion in sctp_cname
Message-Id: <20180212140158.GB21383@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <2ca12376b0b3b73833878279f20183bf03128626.1518431391.git.lucien.xin@gmail.com>
In-Reply-To: <2ca12376b0b3b73833878279f20183bf03128626.1518431391.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Feb 12, 2018 at 06:29:51PM +0800, Xin Long wrote:
> After the support for SCTP_CID_I_DATA and SCTP_CID_I_FWD_TSN chunks,
> the corresp conversion in sctp_cname should also be added. Otherwise,
> in some places, pr_debug will print them as "unknown chunk".
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/debug.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/sctp/debug.c b/net/sctp/debug.c
> index 291c97b..8f6c2e8 100644
> --- a/net/sctp/debug.c
> +++ b/net/sctp/debug.c
> @@ -81,6 +81,12 @@ const char *sctp_cname(const union sctp_subtype cid)
>  	case SCTP_CID_RECONF:
>  		return "RECONF";
>  
> +	case SCTP_CID_I_DATA:
> +		return "I_DATA";
> +
> +	case SCTP_CID_I_FWD_TSN:
> +		return "I_FWD_TSN";
> +
>  	default:
>  		break;
>  	}
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
