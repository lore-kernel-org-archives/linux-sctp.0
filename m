From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 Dec 2015 15:38:38 +0000
Subject: Re: [V2 PATCH 1/1] net: sctp: dynamically enable or disable pf state
Message-Id: <20151214153838.GA5352@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1450074139-3923-1-git-send-email-zyjzyj2000@gmail.com>
In-Reply-To: <1450074139-3923-1-git-send-email-zyjzyj2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zyjzyj2000@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, alexandre.dietsch@windriver.com, stefan.costandache@windriver.com

On Mon, Dec 14, 2015 at 02:22:19PM +0800, zyjzyj2000@gmail.com wrote:
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
> 
> As we all know, the value of pf_retrans >= max_retrans_path can
> disable pf state. The variables of pf_retrans and max_retrans_path
> can be changed by the user space application.
> 
> Sometimes the user expects to disable pf state while the 2
> variables are changed to enable pf state. So it is necessary to
> introduce a new variable to disable pf state.
> 
> According to the suggestions from Vlad Yasevich, extra1 and extra2
> are removed. The initialization of pf_enable is added.
> 
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> ---
>  include/net/netns/sctp.h |    7 +++++++
>  net/sctp/protocol.c      |    3 +++
>  net/sctp/sm_sideeffect.c |    5 ++++-
>  net/sctp/sysctl.c        |    7 +++++++
>  4 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
> index 8ba379f..c501d67 100644
> --- a/include/net/netns/sctp.h
> +++ b/include/net/netns/sctp.h
> @@ -89,6 +89,13 @@ struct netns_sctp {
>  	int pf_retrans;
>  
>  	/*
> +	 * Disable Potentially-Failed feature, the feature is enabled by default
> +	 * pf_enable	-  0  : disable pf
> +	 *		- >0  : enable pf
> +	 */
> +	int pf_enable;
> +
> +	/*
>  	 * Policy for preforming sctp/socket accounting
>  	 * 0   - do socket level accounting, all assocs share sk_sndbuf
>  	 * 1   - do sctp accounting, each asoc may use sk_sndbuf bytes

Please add this documentation to Documentation/networking/ip-sysctl.txt
too, mentioning the RFC/draft it's about. 
https://datatracker.ietf.org/doc/draft-ietf-tsvwg-sctp-failover/

And update the text on pf_retrans mentioning this new variable as well.

  Marcelo

