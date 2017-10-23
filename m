From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 23 Oct 2017 13:36:13 +0000
Subject: Re: [PATCH] sctp: full support for ipv6 ip_nonlocal_bind & IP_FREEBIND
Message-Id: <CADvbK_ca_DXkCVwZntr0JVmqg-c7VLyMnHV_4CdYLgtcbmMnVA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171021213659.GA2778@ubuntu-desk-vm>
In-Reply-To: <20171021213659.GA2778@ubuntu-desk-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sun, Oct 22, 2017 at 5:36 AM, Laszlo Toth <laszlth@gmail.com> wrote:
> Commit 9b9742022888 ("sctp: support ipv6 nonlocal bind")
> introduced support for the above options as v4 sctp did,
> so patched sctp_v6_available().
>
> In the v4 implementation it's enough, because
> sctp_inet_bind_verify() just returns with sctp_v4_available().
> However sctp_inet6_bind_verify() has an extra check before that
> for link-local scope_id, which won't respect the above options.
>
> Added the checks before calling ipv6_chk_addr(), but
> not before the validation of scope_id.
>
> before (w/ both options):
>  ./v6test fe80::10 sctp
>  bind failed, errno: 99 (Cannot assign requested address)
>  ./v6test fe80::10 tcp
>  bind success, errno: 0 (Success)
>
> after (w/ both options):
>  ./v6test fe80::10 sctp
>  bind success, errno: 0 (Success)
>
> Signed-off-by: Laszlo Toth <laszlth@gmail.com>
> ---
>  net/sctp/ipv6.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 51c4887..ca75d2a 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -883,7 +883,9 @@ static int sctp_inet6_bind_verify(struct sctp_sock *opt, union sctp_addr *addr)
>                         rcu_read_lock();
>                         dev = dev_get_by_index_rcu(net, addr->v6.sin6_scope_id);
>                         if (!dev ||
> -                           !ipv6_chk_addr(net, &addr->v6.sin6_addr, dev, 0)) {
> +                           !(opt->inet.freebind ||
> +                           net->ipv6.sysctl.ip_nonlocal_bind ||
> +                           ipv6_chk_addr(net, &addr->v6.sin6_addr, dev, 0))) {
pls fix your indent, like:
https://paste.fedoraproject.org/paste/ZhWmaJjepHfG~3DUp7YsBQ

>                                 rcu_read_unlock();
>                                 return 0;
>                         }
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
