From: David Miller <davem@davemloft.net>
Date: Mon, 12 Feb 2018 19:36:48 +0000
Subject: Re: [PATCH v2] net: make getname() functions return length rather than use int* parameter
Message-Id: <20180212.143648.1353355347147054805.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180212190020.21536-1-dvlasenk@redhat.com>
In-Reply-To: <20180212190020.21536-1-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dvlasenk@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-x25@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Mon, 12 Feb 2018 20:00:20 +0100

> Changes since v1:
> Added changes in these files:
>     drivers/infiniband/hw/usnic/usnic_transport.c
>     drivers/staging/lustre/lnet/lnet/lib-socket.c
>     drivers/target/iscsi/iscsi_target_login.c
>     drivers/vhost/net.c
>     fs/dlm/lowcomms.c
>     fs/ocfs2/cluster/tcp.c
>     security/tomoyo/network.c
> 
> 
> Before:
> All these functions either return a negative error indicator,
> or store length of sockaddr into "int *socklen" parameter
> and return zero on success.
> 
> "int *socklen" parameter is awkward. For example, if caller does not
> care, it still needs to provide on-stack storage for the value
> it does not need.
> 
> None of the many FOO_getname() functions of various protocols
> ever used old value of *socklen. They always just overwrite it.
> 
> This change drops this parameter, and makes all these functions, on success,
> return length of sockaddr. It's always >= 0 and can be differentiated
> from an error.
> 
> Tests in callers are changed from "if (err)" to "if (err < 0)", where needed.
> 
> rpc_sockname() lost "int buflen" parameter, since its only use was
> to be passed to kernel_getsockname() as &buflen and subsequently
> not used in any way.
> 
> Userspace API is not changed.
> 
>     text    data     bss      dec     hex filename
> 30108430 2633624  873672 33615726 200ef6e vmlinux.before.o
> 30108109 2633612  873672 33615393 200ee21 vmlinux.o
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Applied to net-next, thanks Denys.
