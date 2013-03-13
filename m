From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 13 Mar 2013 13:33:56 +0000
Subject: Re: [PATCH] sctp: don't break the loop while meeting the active_path so as to find the matched trans
Message-Id: <20130313133356.GD17592@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
In-Reply-To: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xufeng Zhang <xufeng.zhang@windriver.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 03:39:37PM +0800, Xufeng Zhang wrote:
> sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
> was sent on, if not found in the active_path transport, then go search
> all the other transports in the peer's transport_addr_list, however, we
> should continue to the next entry rather than break the loop when meet
> the active_path transport.
> 
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
> ---
>  net/sctp/associola.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 43cd0dd..d2709e2 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1079,7 +1079,7 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
>  			transports) {
>  
>  		if (transport = active)
> -			break;
> +			continue;
>  		list_for_each_entry(chunk, &transport->transmitted,
>  				transmitted_list) {
>  			if (key = chunk->subh.data_hdr->tsn) {
> -- 
> 1.7.0.2
> 
Based on discussion with Vlad, it seems theres arguably some work to do on
access to the transport_addr_list before my solution is viable, so until I get
to that I'm acking this patch.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

