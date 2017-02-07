From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Tue, 07 Feb 2017 09:05:52 +0000
Subject: Re: [PATCHv4 net-next 5/7] net: add confirm_neigh method to dst_ops
Message-Id: <20170207090552.GM30338@gauss.secunet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1486415657-14714-1-git-send-email-ja@ssi.bg>
 <1486415657-14714-6-git-send-email-ja@ssi.bg>
In-Reply-To: <1486415657-14714-6-git-send-email-ja-FgGsKACvmQM@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julian Anastasov <ja-FgGsKACvmQM@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, Feb 06, 2017 at 11:14:15PM +0200, Julian Anastasov wrote:
> Add confirm_neigh method to dst_ops and use it from IPv4 and IPv6
> to lookup and confirm the neighbour. Its usage via the new helper
> dst_confirm_neigh() should be restricted to MSG_PROBE users for
> performance reasons.
> 
> For XFRM prefer the last tunnel address, if present. With help
> from Steffen Klassert.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
