From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 03 Sep 2019 01:31:26 +0000
Subject: Re: [PATCH net] sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
Message-Id: <20190903013126.GA3499@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
In-Reply-To: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Mon, Sep 02, 2019 at 11:24:21PM +0800, Xin Long wrote:
> Transport should use its own pf_retrans to do the error_count
> check, instead of asoc's. Otherwise, it's meaningless to make
> pf_retrans per transport.
> 
> Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/sm_sideeffect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 1cf5bb5..e52b212 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -547,7 +547,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
>  	if (net->sctp.pf_enable &&
>  	   (transport->state = SCTP_ACTIVE) &&
>  	   (transport->error_count < transport->pathmaxrxt) &&
> -	   (transport->error_count > asoc->pf_retrans)) {
> +	   (transport->error_count > transport->pf_retrans)) {
>  
>  		sctp_assoc_control_transport(asoc, transport,
>  					     SCTP_TRANSPORT_PF,
> -- 
> 2.1.0
> 
