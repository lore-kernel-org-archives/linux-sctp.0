From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Aug 2016 16:23:05 +0000
Subject: Re: [PATCH net] sctp: fix overrun in sctp_diag_dump_one()
Message-Id: <CADvbK_fn7jAo7ZeVwa58L54uZoE1sj34Ty473RutOUQ8sfVmQA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1471966852-6218-1-git-send-email-lrichard@redhat.com>
In-Reply-To: <1471966852-6218-1-git-send-email-lrichard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lance Richardson <lrichard@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

On Tue, Aug 23, 2016 at 11:40 PM, Lance Richardson <lrichard@redhat.com> wrote:
> The function sctp_diag_dump_one() currently performs a memcpy()
> of 64 bytes from a 16 byte field into another 16 byte field. Fix
> by using correct size, use sizeof to obtain correct size instead
> of using a hard-coded constant.
>
> Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
> Signed-off-by: Lance Richardson <lrichard@redhat.com>
> ---
>  net/sctp/sctp_diag.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
> index bb69153..f3508aa 100644
> --- a/net/sctp/sctp_diag.c
> +++ b/net/sctp/sctp_diag.c
> @@ -424,11 +424,13 @@ static int sctp_diag_dump_one(struct sk_buff *in_skb,
>                 paddr.v4.sin_family = AF_INET;
>         } else {
>                 laddr.v6.sin6_port = req->id.idiag_sport;
> -               memcpy(&laddr.v6.sin6_addr, req->id.idiag_src, 64);
> +               memcpy(&laddr.v6.sin6_addr, req->id.idiag_src,
> +                      sizeof(laddr.v6.sin6_addr));
>                 laddr.v6.sin6_family = AF_INET6;
>
>                 paddr.v6.sin6_port = req->id.idiag_dport;
> -               memcpy(&paddr.v6.sin6_addr, req->id.idiag_dst, 64);
> +               memcpy(&paddr.v6.sin6_addr, req->id.idiag_dst,
> +                      sizeof(paddr.v6.sin6_addr));
>                 paddr.v6.sin6_family = AF_INET6;
>         }
>
> --
> 2.5.5
>

Reviewed-by: Xin Long <lucien.xin@gmail.com>
