From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 08 Mar 2013 14:27:20 +0000
Subject: Re: [PATCH] sctp: don't break the loop while meeting the active_path so as to find the matched trans
Message-Id: <20130308142720.GA9873@hmsreliant.think-freely.org>
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
> 

This works, but what might be better would be if we did a move to front
heuristic in sctp_assoc_set_primary.  E.g. when we set the active_path, move the
requisite transport to the front of the transport_addr_list.  If we did that,
then we could just do one for loop in sctp_assoc_lookup_tsn and wind up
implicitly check the active path first without having to check it seprately and
skip it in the second for loop.  

Neil

