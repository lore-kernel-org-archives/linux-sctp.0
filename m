From: tingwei liu <tingw.liu@gmail.com>
Date: Thu, 08 May 2014 09:40:57 +0000
Subject: Re: [PATCH net-next] sctp: add a checking for sctp_sysctl_net_register
Message-Id: <CA+qZnSQHfvO9HysmrsgVs0TSMz6j-kvAYNsHA+z38PWN621u2g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <536B3859.2050908@huawei.com>
In-Reply-To: <536B3859.2050908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Daniel Borkmann <dborkman@redhat.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Tony <liutingwei@hisense.com>

On Thu, May 8, 2014 at 3:55 PM, Wang Weidong <wangweidong1@huawei.com> wrote:
> When register_net_sysctl failed, we should free the
> sysctl_table while the net_namespace is not init_net.
>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>  net/sctp/sysctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index 844d2b0..4c17694 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -450,6 +450,11 @@ int sctp_sysctl_net_register(struct net *net)
>         }
>
>         net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
> +       if (net->sctp.sysctl_header = NULL) {
> +               if (!net_eq(net, &init_net))
> +                       kfree(table);
> +               return -ENOMEM;
> +       }
>         return 0;
>  }
>
Hope to resolve the problem of sctp_sysctl_net_unregister() in one patch!
kfree(table) should check net namesapce.
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index c82fdc1..844d2b0 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -459,7 +459,8 @@ void sctp_sysctl_net_unregister(struct net *net)

        table = net->sctp.sysctl_header->ctl_table_arg;
        unregister_net_sysctl_table(net->sctp.sysctl_header);
-       kfree(table);
+       if (!net_eq(net, &init_net))
+               kfree(table);
 }

 static struct ctl_table_header *sctp_sysctl_header;

Thanks
Tingwei Liu
> --
> 1.7.12
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
