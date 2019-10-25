From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 25 Oct 2019 03:21:56 +0000
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Message-Id: <20191025032156.GA4326@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, David Laight <david.laight@aculab.com>

Hi,

Sorry for the long delay on this review.

On Mon, Oct 14, 2019 at 02:14:44PM +0800, Xin Long wrote:
> SCTP Quick failover draft section 5.1, point 5 has been removed
> from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
> Layer Protocol (ULP) about this state transition", as said in
> section 3.2, point 8.
> 
> So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
> in section 7.1, "which is reported if the affected address
> becomes PF". Also remove transport cwnd's update when moving
> from PF back to ACTIVE , which is no longer in rfc7829 either.
> 
> v1->v2:
>   - no change
> v2->v3:
>   - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/sctp.h |  2 ++
>  net/sctp/associola.c      | 17 ++++-------------
>  2 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index 6bce7f9..f4ab7bb 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -410,6 +410,8 @@ enum sctp_spc_state {
>  	SCTP_ADDR_ADDED,
>  	SCTP_ADDR_MADE_PRIM,
>  	SCTP_ADDR_CONFIRMED,
> +	SCTP_ADDR_POTENTIALLY_FAILED,
> +#define SCTP_ADDR_PF	SCTP_ADDR_POTENTIALLY_FAILED
>  };
>  
>  
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 1ba893b..4f9efba 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,

While at here, dealing with spc_state, please seize the moment and
initialize it to the enum instead:

@@ -787,7 +787,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
                                  sctp_sn_error_t error)
 {
        bool ulp_notify = true;
-       int spc_state = 0;
+       int spc_state = SCTP_ADDR_AVAILABLE;


>  			spc_state = SCTP_ADDR_CONFIRMED;
>  		else
>  			spc_state = SCTP_ADDR_AVAILABLE;

This else could be removed (equals to initial value).

> -		/* Don't inform ULP about transition from PF to
> -		 * active state and set cwnd to 1 MTU, see SCTP
> -		 * Quick failover draft section 5.1, point 5
> -		 */
> -		if (transport->state = SCTP_PF) {
> -			ulp_notify = false;
> -			transport->cwnd = asoc->pathmtu;
> -		}
>  		transport->state = SCTP_ACTIVE;
>  		break;
>  
> @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>  		 * to inactive state.  Also, release the cached route since
>  		 * there may be a better route next time.
>  		 */
> -		if (transport->state != SCTP_UNCONFIRMED)
> +		if (transport->state != SCTP_UNCONFIRMED) {
>  			transport->state = SCTP_INACTIVE;
> -		else {
> +			spc_state = SCTP_ADDR_UNREACHABLE;
> +		} else {
>  			sctp_transport_dst_release(transport);
>  			ulp_notify = false;
>  		}
> -
> -		spc_state = SCTP_ADDR_UNREACHABLE;
>  		break;
>  
>  	case SCTP_TRANSPORT_PF:
>  		transport->state = SCTP_PF;
> -		ulp_notify = false;
> +		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
>  		break;
>  
>  	default:
> -- 
> 2.1.0
> 
