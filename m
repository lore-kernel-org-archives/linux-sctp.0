From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 11 Jan 2018 00:11:52 +0000
Subject: Re: sctp: memory leak in sctp_endpoint_init
Message-Id: <CAM_iQpWbfbM4L8P5m8xE6-ZhaqL1h8+SEcQg2=gWhsp4xO2ejA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+avNW05tiE7Qr4mx+X6dSVaTHL4MLuByF8viNyouMYiww@mail.gmail.com>
In-Reply-To: <CACT4Y+avNW05tiE7Qr4mx+X6dSVaTHL4MLuByF8viNyouMYiww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Vladislav Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>

On Tue, Jan 9, 2018 at 9:44 AM, 'Dmitry Vyukov' via syzkaller
<syzkaller@googlegroups.com> wrote:
> Hello,
>
> syzkaller has hit the following memory leak on 4.15-rc7.
> Reproducer is attached.
>
> unferenced object 0xffff88007bbaa720 (size 32):
>   comm "syz-executor4", pid 12479, jiffies 4295951917 (age 9.779s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000ce041e0c>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<00000000ce041e0c>] slab_post_alloc_hook mm/slab.h:440 [inline]
>     [<00000000ce041e0c>] slab_alloc_node mm/slub.c:2725 [inline]
>     [<00000000ce041e0c>] slab_alloc mm/slub.c:2733 [inline]
>     [<00000000ce041e0c>] kmem_cache_alloc_trace+0x126/0x290 mm/slub.c:2750
>     [<0000000052b69e97>] kmalloc include/linux/slab.h:499 [inline]
>     [<0000000052b69e97>] kzalloc include/linux/slab.h:688 [inline]
>     [<0000000052b69e97>] sctp_endpoint_init net/sctp/endpointola.c:66 [inline]
>     [<0000000052b69e97>] sctp_endpoint_new+0x16d/0xef0
> net/sctp/endpointola.c:195
>     [<00000000b78002d9>] sctp_init_sock+0xc18/0x13e0 net/sctp/socket.c:4490
>     [<00000000fe5de849>] inet6_create+0xba7/0x1290 net/ipv6/af_inet6.c:255
>     [<00000000bb006173>] __sock_create+0x521/0x920 net/socket.c:1265
>     [<00000000a8d6fbc0>] sock_create net/socket.c:1305 [inline]
>     [<00000000a8d6fbc0>] SYSC_socket net/socket.c:1335 [inline]
>     [<00000000a8d6fbc0>] SyS_socket+0x102/0x1f0 net/socket.c:1315

This could be probably fixed by the patch
"Fix a leak in socket(2) when we fail to allocate a file descriptor." too.
