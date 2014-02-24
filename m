From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 24 Feb 2014 12:02:27 +0000
Subject: Re: [PATCH net-next] loopback: sctp: add NETIF_F_SCTP_CSUM to device features
Message-Id: <530B34D3.2050307@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1393074113-9922-1-git-send-email-dborkman@redhat.com> <063D6719AE5E284EB5DD2968C1650D6D0F6C96DE@AcuExch.aculab.com> <530B1F93.4010308@redhat.com> <063D6719AE5E284EB5DD2968C1650D6D0F6C9802@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6C9802@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

On 02/24/2014 11:42 AM, David Laight wrote:
...
> I'm sure it shouldn't be that expensive, you are implying that it spent
> about 70% of the time doing crc32.

In this scenario, the following perf log I get that shows where cycles
are being spent on my machine:

  65.95%       netperf  [kernel.kallsyms]  [k] __crc32c_le
   3.79%       netperf  [kernel.kallsyms]  [k] memcpy
   2.38%       netperf  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
   0.62%       netperf  [sctp]             [k] sctp_datamsg_from_user
   0.62%       netperf  [sctp]             [k] sctp_sendmsg
   0.55%       netperf  [kernel.kallsyms]  [k] __slab_free
   0.52%       netperf  [sctp]             [k] sctp_outq_flush
   0.50%       netperf  [kernel.kallsyms]  [k] kfree
   0.49%       netperf  [kernel.kallsyms]  [k] cmpxchg_double_slab.isra.52
   0.48%       netperf  [kernel.kallsyms]  [k] kmem_cache_alloc
   0.43%       netperf  [kernel.kallsyms]  [k] __slab_alloc
   0.42%       netperf  [kernel.kallsyms]  [k] __copy_skb_header
   0.41%       netperf  [kernel.kallsyms]  [k] __alloc_skb

> The loop should be dominated by the per-byte lookup in a 256 word table.
> With 4k data the table will soon be in the data cache.
> Unless it is (stupidly) generating the table on each call, or trying
> to use a crc32 instruction, faulting, and emulating it, I wouldn't
> really have expected more than a few % improvement.
