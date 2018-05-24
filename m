From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 24 May 2018 09:02:59 +0000
Subject: Re: INFO: rcu detected stall in corrupted
Message-Id: <CADvbK_dMq0c9wBHoNbLgXj3ee-Ua1EQiqPgvYxX6pumCpO=ygw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000007eb20056cbb245f@google.com> <20180521.140924.2255125685012645769.davem@davemloft.net>
 <f8d0d282-1e75-d86a-8872-e32b57a6ec14@gmail.com> <20180523231340.GN5488@localhost.localdomain>
In-Reply-To: <20180523231340.GN5488@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>, syzbot+f116bc1994efe725d51b@syzkaller.appspotmail.com, kuznet <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, network dev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, yoshfuji <yoshfuji@linux-ipv6.org>, dsahern@kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>, linux-sctp@vger.kernel.org

On Thu, May 24, 2018 at 7:13 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Mon, May 21, 2018 at 11:13:46AM -0700, Eric Dumazet wrote:
>>
>>
>> On 05/21/2018 11:09 AM, David Miller wrote:
>> > From: syzbot <syzbot+f116bc1994efe725d51b@syzkaller.appspotmail.com>
>> > Date: Mon, 21 May 2018 11:05:02 -0700
>> >
>> >>  find_match+0x244/0x13a0 net/ipv6/route.c:691
>> >>  find_rr_leaf net/ipv6/route.c:729 [inline]
>> >>  rt6_select net/ipv6/route.c:779 [inline]
>> >
>> > Hmmm, endless loop in find_rr_leaf or similar?
>> >
>>
>>
>> I do not think so, this really looks like SCTP specific
>> , we now have dozens of traces all sharing :
>>
>>  sctp_transport_route+0xad/0x450 net/sctp/transport.c:293
>>  sctp_packet_config+0xb89/0xfd0 net/sctp/output.c:123
>>  sctp_outq_flush+0x79c/0x4370 net/sctp/outqueue.c:894
>>  sctp_outq_uncork+0x6a/0x80 net/sctp/outqueue.c:776
>>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
>>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>>  sctp_do_sm+0x596/0x7160 net/sctp/sm_sideeffect.c:1191
>>  sctp_generate_heartbeat_event+0x218/0x450 net/sctp/sm_sideeffect.c:406
>>  call_timer_fn+0x230/0x940 kernel/time/timer.c:1326
>>
>>
>> Some kind of infinite loop.
>>
>> When the hrtimer fires, it can point to any code that sits below but does not necessarily have a bug.
>
> Agreed. Xin Long identified the root cause. syzkaller is setting too
> aggressive parameters to SCTP RTO, leading to issues with the
> heartbeat timer.
Right, I will prepare a fix soon with your suggestion rto_min value "HZ/5"
Thanks.
