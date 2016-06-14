From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 14 Jun 2016 03:04:05 +0000
Subject: Re: [PATCH -next] sctp: fix error return code in sctp_init()
Message-Id: <CADvbK_eOtTS9NSRoKmJYXSYHtCRMFMkKqkeCREVY09qtE=Y4og@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1465830506-22752-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1465830506-22752-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyj_lk@163.com
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>

On Mon, Jun 13, 2016 at 11:08 PM,  <weiyj_lk@163.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  net/sctp/protocol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 40022ee..3b56ae5 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1479,7 +1479,8 @@ static __init int sctp_init(void)
>                 INIT_HLIST_HEAD(&sctp_port_hashtable[i].chain);
>         }
>
> -       if (sctp_transport_hashtable_init())
> +       status = sctp_transport_hashtable_init();
> +       if (status)
>                 goto err_thash_alloc;
>
>         pr_info("Hash tables configured (bind %d/%d)\n", sctp_port_hashsize,
>
>
Acked-by: Xin Long <lucien.xin@gmail.com>
