From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 May 2018 17:45:08 +0000
Subject: Re: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <CADvbK_fbKbH2wm6Xurr+ELVag-LvyQdL+peJd=wp7OL7_zMZTQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <dc48b7c6a6dd1d8f19215cea6713d5723779d564.1527270062.git.lucien.xin@gmail.com>
 <20180525191319.GB392@hmswarspite.think-freely.org> <71FD541D-25FE-4100-980B-C3A0CEAF6CD4@lurchi.franken.de>
 <CACT4Y+YozRSfcoUoKHOWy5wujhVdks38vcfNGhwNj-REWcd-hw@mail.gmail.com>
 <20180527010059.GA15798@neilslaptop.think-freely.org> <20180528194315.GB3788@localhost.localdomain>
 <20180529114111.GA24144@hmswarspite.think-freely.org> <559FFFDD-E508-4936-9544-CACE606AF40F@lurchi.franken.de>
 <20180529154514.GC3788@localhost.localdomain> <CADVnQymCNEtQFThsbQ0u7jirx24i45f5L7P-2dPf8omkshqwmg@mail.gmail.com>
 <20180529170604.GD3788@localhost.localdomain>
In-Reply-To: <20180529170604.GD3788@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>, Michael Tuexen <michael.tuexen@lurchi.franken.de>, Neil Horman <nhorman@tuxdriver.com>, Dmitry Vyukov <dvyukov@google.com>, Netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, David Ahern <dsa@cumulusnetworks.com>, Eric Dumazet <edumazet@google.com>, syzkaller <syzkaller@googlegroups.com>

On Wed, May 30, 2018 at 1:06 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Tue, May 29, 2018 at 12:03:46PM -0400, Neal Cardwell wrote:
>> On Tue, May 29, 2018 at 11:45 AM Marcelo Ricardo Leitner <
>> marcelo.leitner@gmail.com> wrote:
>> > - patch2 - fix rtx attack vector
>> >    - Add the floor value to rto_min to HZ/20 (which fits the values
>> >      that Michael shared on the other email)
>>
>> I would encourage allowing minimum RTO values down to 5ms, if the ACK
>> policy in the receiver makes this feasible. Our experience is that in
>> datacenter environments it can be advantageous to allow timer-based loss
>> recoveries using timeout values as low as 5ms, e.g.:
>
> Thanks Neal. On Xin's tests, the hearbeat timer becomes an issue at
> ~25ms already. Xin, can you share more details on the hw, which CPU
> was used?
It was on a KVM guest,  "-smp 2,cores=1,threads=1,sockets=2"
# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                2
On-line CPU(s) list:   0,1
Thread(s) per core:    1
Core(s) per socket:    1
Socket(s):             2
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 13
Model name:            QEMU Virtual CPU version 1.5.3
Stepping:              3
CPU MHz:               2397.222
BogoMIPS:              4794.44
Hypervisor vendor:     KVM
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              4096K
NUMA node0 CPU(s):     0,1
Flags:                 fpu de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good
nopl cpuid pni cx16 hypervisor lahf_lm abm pti

If we're counting on max_t to fix this CPU stuck. It should not that
matter if min rto < the value causing that stuck.

>
> Anyway, what about we add a floor to rto_max too, so that RTO can
> actually grow into something bigger that don't hog the CPU? Like:
> rto_min floor = 5ms
> rto_max floor = 50ms
>
>   Marcelo
