From: Olof Johansson <olof@lixom.net>
Date: Sat, 08 Sep 2018 17:02:42 +0000
Subject: Re: [PATCH] net/sock: move memory_allocated over to percpu_counter variables
Message-Id: <CAOesGMi31UA2d-Bj2jo53Wz_YV424-rD3qk9rS5_-Yng0VC=0w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180906192034.8467-1-olof@lixom.net> <CANn89i+akEWrHELBkZJQOxok-ZfYy+FNPUWdPEfB6c4YyWLqJA@mail.gmail.com>
 <20180907033257.2nlgiqm2t4jiwhzc@gondor.apana.org.au> <CAOesGMgRrb4D2S_qWwgo00iNxbCL9EEGfhD5Ji-2HMWuZeq0Yw@mail.gmail.com>
 <CANn89iKJcgMWb2Kmk6L9k=NkfBUKZ6BwriWr3O+N5Y0u5dy=9g@mail.gmail.com> <CANn89iKgZkfwQ8nAGEfOzubOh69y285TNKB5Q518Wf_phbq2Yg@mail.gmail.com>
In-Reply-To: <CANn89iKgZkfwQ8nAGEfOzubOh69y285TNKB5Q518Wf_phbq2Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, linux-decnet-user@lists.sourceforge.net, kernel-team <kernel-team@fb.com>, Yuchung Cheng <ycheng@google.com>, Neal Cardwell <ncardwell@google.com>

Hi,

On Fri, Sep 7, 2018 at 12:21 AM, Eric Dumazet <edumazet@google.com> wrote:
> On Fri, Sep 7, 2018 at 12:03 AM Eric Dumazet <edumazet@google.com> wrote:
>
>> Problem is : we have platforms with more than 100 cpus, and
>> sk_memory_allocated() cost will be too expensive,
>> especially if the host is under memory pressure, since all cpus will
>> touch their private counter.
>>
>> per cpu variables do not really scale, they were ok 10 years ago when
>> no more than 16 cpus were the norm.
>>
>> I would prefer change TCP to not aggressively call
>> __sk_mem_reduce_allocated() from tcp_write_timer()
>>
>> Ideally only tcp_retransmit_timer() should attempt to reduce forward
>> allocations, after recurring timeout.
>>
>> Note that after 20c64d5cd5a2bdcdc8982a06cb05e5e1bd851a3d ("net: avoid
>> sk_forward_alloc overflows")
>> we have better control over sockets having huge forward allocations.
>>
>> Something like :
>
> Or something less risky :

I gave both of these patches a run, and neither do as well on the
system that has slower atomics. :(

The percpu version:

     8.05%  workload         [kernel.vmlinux]
    [k] __do_softirq
     7.04%  swapper          [kernel.vmlinux]
    [k] cpuidle_enter_state
     5.54%  workload         [kernel.vmlinux]
    [k] _raw_spin_unlock_irqrestore
     1.66%  swapper          [kernel.vmlinux]
    [k] __do_softirq
     1.55%  workload         [kernel.vmlinux]
    [k] finish_task_switch
     1.24%  swapper          [kernel.vmlinux]
    [k] finish_task_switch
     1.07%  workload         [kernel.vmlinux]
    [k] net_rx_action

The first patch from you still has significant amount of time spent in
the atomics paths (non-inlined versions used):

     7.87%  workload         [kernel.vmlinux]
[k] __ll_sc_atomic64_sub
     7.48%  workload         [kernel.vmlinux]
[k] __do_softirq
     5.05%  workload         [kernel.vmlinux]
[k] _raw_spin_unlock_irqrestore
     2.42%  workload         [kernel.vmlinux]
[k] __ll_sc_atomic64_add_return
     1.49%  swapper          [kernel.vmlinux]
[k] cpuidle_enter_state
     1.31%  workload         [kernel.vmlinux]
[k] finish_task_switch
     1.09%  workload         [kernel.vmlinux]
[k] tcp_sendmsg_locked
     1.08%  workload         [kernel.vmlinux]
[k] __arch_copy_from_user
     1.02%  workload         [kernel.vmlinux]
[k] net_rx_action

I think a lot of the overhead from percpu approach can be alleviated
if we can use percpu_counter_read() instead of _sum() (i.e. no need to
iterate through the local per-cpu recent delta). I don't know the TCP
stack well enough to tell where it's OK to use a bit of slack in the
numbers though -- by default count will at most be off by 32*online
cpus. Might not be a significant number in reality.


-Olof
