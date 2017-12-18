From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 18 Dec 2017 14:37:47 +0000
Subject: Re: [PATCH net] sctp: add SCTP_CID_RECONF conversion in sctp_cname
Message-Id: <20171218143747.GB24106@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <ae9172b7dc432d6092ab2bc061a0cf322a3939b5.1513577597.git.lucien.xin@gmail.com>
In-Reply-To: <ae9172b7dc432d6092ab2bc061a0cf322a3939b5.1513577597.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Dec 18, 2017 at 02:13:17PM +0800, Xin Long wrote:
> Whenever a new type of chunk is added, the corresp conversion in
> sctp_cname should be added. Otherwise, in some places, pr_debug
> will print it as "unknown chunk".
> 
> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/debug.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sctp/debug.c b/net/sctp/debug.c
> index 3f619fd..291c97b 100644
> --- a/net/sctp/debug.c
> +++ b/net/sctp/debug.c
> @@ -78,6 +78,9 @@ const char *sctp_cname(const union sctp_subtype cid)
>  	case SCTP_CID_AUTH:
>  		return "AUTH";
>  
> +	case SCTP_CID_RECONF:
> +		return "RECONF";
> +
>  	default:
>  		break;
>  	}
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
