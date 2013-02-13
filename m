From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 13 Feb 2013 21:02:26 +0000
Subject: Re: [PATCH net-next 1/2] net: sctp: minor: make jsctp_sf_eat_sack static
Message-Id: <20130213210226.GA12702@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360752304.git.dborkman@redhat.com>
 <7eef4b701794c1bb78819bc6e6c45bf99b49801d.1360752304.git.dborkman@redhat.com>
In-Reply-To: <7eef4b701794c1bb78819bc6e6c45bf99b49801d.1360752304.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Wed, Feb 13, 2013 at 12:03:49PM +0100, Daniel Borkmann wrote:
> The function jsctp_sf_eat_sack can be made static, no need to extend
> its visibility.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  net/sctp/probe.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sctp/probe.c b/net/sctp/probe.c
> index 5f7518d..4eaaaf6 100644
> --- a/net/sctp/probe.c
> +++ b/net/sctp/probe.c
> @@ -122,12 +122,12 @@ static const struct file_operations sctpprobe_fops = {
>  	.llseek = noop_llseek,
>  };
>  
> -sctp_disposition_t jsctp_sf_eat_sack(struct net *net,
> -				     const struct sctp_endpoint *ep,
> -				     const struct sctp_association *asoc,
> -				     const sctp_subtype_t type,
> -				     void *arg,
> -				     sctp_cmd_seq_t *commands)
> +static sctp_disposition_t jsctp_sf_eat_sack(struct net *net,
> +					    const struct sctp_endpoint *ep,
> +					    const struct sctp_association *asoc,
> +					    const sctp_subtype_t type,
> +					    void *arg,
> +					    sctp_cmd_seq_t *commands)
>  {
>  	struct sctp_transport *sp;
>  	static __u32 lcwnd = 0;
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

