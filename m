From: Olof Johansson <olof@lixom.net>
Date: Fri, 07 Sep 2018 06:20:15 +0000
Subject: Re: [PATCH] net/sock: move memory_allocated over to percpu_counter variables
Message-Id: <CAOesGMgRrb4D2S_qWwgo00iNxbCL9EEGfhD5Ji-2HMWuZeq0Yw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180906192034.8467-1-olof@lixom.net> <CANn89i+akEWrHELBkZJQOxok-ZfYy+FNPUWdPEfB6c4YyWLqJA@mail.gmail.com>
 <20180907033257.2nlgiqm2t4jiwhzc@gondor.apana.org.au>
In-Reply-To: <20180907033257.2nlgiqm2t4jiwhzc@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, linux-decnet-user@lists.sourceforge.net, kernel-team <kernel-team@fb.com>

Hi,

On Thu, Sep 6, 2018 at 8:32 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Sep 06, 2018 at 12:33:58PM -0700, Eric Dumazet wrote:
>> On Thu, Sep 6, 2018 at 12:21 PM Olof Johansson <olof@lixom.net> wrote:
>> >
>> > Today these are all global shared variables per protocol, and in
>> > particular tcp_memory_allocated can get hot on a system with
>> > large number of CPUs and a substantial number of connections.
>> >
>> > Moving it over to a per-cpu variable makes it significantly cheaper,
>> > and the added overhead when summing up the percpu copies is still smaller
>> > than the cost of having a hot cacheline bouncing around.
>>
>> I am curious. We never noticed contention on this variable, at least for TCP.
>
> Yes these variables are heavily amortised so I'm surprised that
> they would cause much contention.
>
>> Please share some numbers with us.
>
> Indeed.

Certainly, just had to collect them again.

This is on a dual xeon box, with ~150-200k TCP connections. I see
about .7% CPU spent in __sk_mem_{reduce,raise}_allocated in the
inlined atomic ops, most of those in reduce.

Call path for reduce is practically all from tcp_write_timer on softirq:

                __sk_mem_reduce_allocated
                tcp_write_timer
                call_timer_fn
                run_timer_softirq
                __do_softirq
                irq_exit
                smp_apic_timer_interrupt
                apic_timer_interrupt
                cpuidle_enter_state

With this patch, I see about .18+.11+.07 = .36% in percpu-related
functions called from the same __sk_mem functions.

Now, that's a halving of cycles samples on that specific setup. The
real difference though, is on another platform where atomics are more
expensive. There, this makes a significant difference. Unfortunately,
I can't share specifics but I think this change stands on its own on
the dual xeon setup as well, maybe with slightly less strong wording
on just how hot the variable/line happens to be.


-Olof
