From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 13 Mar 2013 13:52:48 +0000
Subject: Re: [PATCH] sctp: don't break the loop while meeting the active_path so as to find the matched trans
Message-Id: <514084B0.4050906@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
In-Reply-To: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xufeng Zhang <xufeng.zhang@windriver.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/08/2013 02:39 AM, Xufeng Zhang wrote:
> sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
> was sent on, if not found in the active_path transport, then go search
> all the other transports in the peer's transport_addr_list, however, we
> should continue to the next entry rather than break the loop when meet
> the active_path transport.
>
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
> ---
>   net/sctp/associola.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 43cd0dd..d2709e2 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1079,7 +1079,7 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
>   			transports) {
>
>   		if (transport = active)
> -			break;
> +			continue;
>   		list_for_each_entry(chunk, &transport->transmitted,
>   				transmitted_list) {
>   			if (key = chunk->subh.data_hdr->tsn) {
>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
