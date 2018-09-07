From: Eric Dumazet <edumazet@google.com>
Date: Fri, 07 Sep 2018 07:21:46 +0000
Subject: Re: [PATCH] net/sock: move memory_allocated over to percpu_counter variables
Message-Id: <CANn89iKgZkfwQ8nAGEfOzubOh69y285TNKB5Q518Wf_phbq2Yg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180906192034.8467-1-olof@lixom.net> <CANn89i+akEWrHELBkZJQOxok-ZfYy+FNPUWdPEfB6c4YyWLqJA@mail.gmail.com>
 <20180907033257.2nlgiqm2t4jiwhzc@gondor.apana.org.au> <CAOesGMgRrb4D2S_qWwgo00iNxbCL9EEGfhD5Ji-2HMWuZeq0Yw@mail.gmail.com>
 <CANn89iKJcgMWb2Kmk6L9k=NkfBUKZ6BwriWr3O+N5Y0u5dy=9g@mail.gmail.com>
In-Reply-To: <CANn89iKJcgMWb2Kmk6L9k=NkfBUKZ6BwriWr3O+N5Y0u5dy=9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olof Johansson <olof@lixom.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, linux-decnet-user@lists.sourceforge.net, kernel-team <kernel-team@fb.com>, Yuchung Cheng <ycheng@google.com>, Neal Cardwell <ncardwell@google.com>

On Fri, Sep 7, 2018 at 12:03 AM Eric Dumazet <edumazet@google.com> wrote:

> Problem is : we have platforms with more than 100 cpus, and
> sk_memory_allocated() cost will be too expensive,
> especially if the host is under memory pressure, since all cpus will
> touch their private counter.
>
> per cpu variables do not really scale, they were ok 10 years ago when
> no more than 16 cpus were the norm.
>
> I would prefer change TCP to not aggressively call
> __sk_mem_reduce_allocated() from tcp_write_timer()
>
> Ideally only tcp_retransmit_timer() should attempt to reduce forward
> allocations, after recurring timeout.
>
> Note that after 20c64d5cd5a2bdcdc8982a06cb05e5e1bd851a3d ("net: avoid
> sk_forward_alloc overflows")
> we have better control over sockets having huge forward allocations.
>
> Something like :

Or something less risky :

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 7fdf222a0bdfe9775970082f6b5dcdcc82b2ae1a..0aee80b6966cb2898e46350c761f9eb431ff1206
100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -604,7 +604,8 @@ void tcp_write_timer_handler(struct sock *sk)
        }

 out:
-       sk_mem_reclaim(sk);
+       if (tcp_under_memory_pressure(sk))
+               sk_mem_reclaim(sk);
 }

 static void tcp_write_timer(struct timer_list *t)
