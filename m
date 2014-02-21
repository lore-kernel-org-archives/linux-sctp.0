From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 21 Feb 2014 20:45:48 +0000
Subject: Re: [PATCH net v2] net: sctp: rework multihoming retransmission path selection to rfc4960
Message-Id: <5307BAFC.8040809@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1392925866-11084-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1392925866-11084-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>

On 02/20/2014 02:51 PM, Daniel Borkmann wrote:
>
> This patch mostly reverts 4141ddc02a92, but also rewrites
> this function to introduce more clarity and strictness into
> the code. A strict priority of transport states is enforced
> in this patch, hence selection is active > unkown > partial
> failover > inactive.
>
> Fixes: 4141ddc02a92 ("sctp: retran_path update bug fix")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Acked-by: Vlad Yasevich <yasevich@gmail.com>

-vlad
