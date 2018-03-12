From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Mar 2018 13:38:53 +0000
Subject: Re: [PATCH net-next] sctp: fix error return code in sctp_sendmsg_new_asoc()
Message-Id: <CADvbK_fFdFJ4uREOP2bAYShB_TkP5Xi3d0v1_YodazNYyMjAdw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Mon, Mar 12, 2018 at 8:16 PM, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> Return error code -EINVAL in the address len check error handling
> case since 'err' can be overwrite to 0 by 'err = sctp_verify_addr()'
> in the for loop.
>
> Fixes: 2c0dbaa0c43d ("sctp: add support for SCTP_DSTADDRV4/6 Information for sendmsg")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  net/sctp/socket.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 7d3476a..5e7bfc2 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1761,16 +1761,20 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
>                 memset(daddr, 0, sizeof(*daddr));
>                 dlen = cmsg->cmsg_len - sizeof(struct cmsghdr);
>                 if (cmsg->cmsg_type = SCTP_DSTADDRV4) {
> -                       if (dlen < sizeof(struct in_addr))
> +                       if (dlen < sizeof(struct in_addr)) {
> +                               err = -EINVAL;
>                                 goto free;
> +                       }
>
>                         dlen = sizeof(struct in_addr);
>                         daddr->v4.sin_family = AF_INET;
>                         daddr->v4.sin_port = htons(asoc->peer.port);
>                         memcpy(&daddr->v4.sin_addr, CMSG_DATA(cmsg), dlen);
>                 } else {
> -                       if (dlen < sizeof(struct in6_addr))
> +                       if (dlen < sizeof(struct in6_addr)) {
> +                               err = -EINVAL;
>                                 goto free;
> +                       }
>
>                         dlen = sizeof(struct in6_addr);
>                         daddr->v6.sin6_family = AF_INET6;
>
Unfortunately, this can't be fixed right now, because of
https://lkml.org/lkml/2018/3/7/1175
Pls hold it until net-next merges linus tree.

Btw, the 'err' initialization can also be removed in your patch.

Thanks.
