From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 11 May 2018 19:08:33 +0000
Subject: Re: INFO: rcu detected stall in kfree_skbmem
Message-Id: <683d1ead-d35b-27ee-0f0c-f7e815d989fc@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000a9b0e3056b14bfb2@google.com>
 <CACT4Y+Z_+=VLbELVW69B7WEVqvri1xBMM5RMnMQynec_XgaE=w@mail.gmail.com>
 <20180511184141.GW5105@localhost.localdomain>
In-Reply-To: <20180511184141.GW5105@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+fc78715ba3b3257caf6a@syzkaller.appspotmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, Andrei Vagin <avagin@virtuozzo.com>, David Miller <davem@davemloft.net>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>



On 05/11/2018 11:41 AM, Marcelo Ricardo Leitner wrote:

> But calling ip6_xmit with rcu_read_lock is expected. tcp stack also
> does it.
> Thus I think this is more of an issue with IPv6 stack. If a host has
> an extensive ip6tables ruleset, it probably generates this more
> easily.
> 
>>>  sctp_v6_xmit+0x4a5/0x6b0 net/sctp/ipv6.c:225
>>>  sctp_packet_transmit+0x26f6/0x3ba0 net/sctp/output.c:650
>>>  sctp_outq_flush+0x1373/0x4370 net/sctp/outqueue.c:1197
>>>  sctp_outq_uncork+0x6a/0x80 net/sctp/outqueue.c:776
>>>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
>>>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>>>  sctp_do_sm+0x596/0x7160 net/sctp/sm_sideeffect.c:1191
>>>  sctp_generate_heartbeat_event+0x218/0x450 net/sctp/sm_sideeffect.c:406
>>>  call_timer_fn+0x230/0x940 kernel/time/timer.c:1326
>>>  expire_timers kernel/time/timer.c:1363 [inline]
> 
> Having this call from a timer means it wasn't processing sctp stack
> for too long.
>

I feel the problem is that this part is looping, in some infinite loop.

I have seen this stack traces in other reports.

Maybe some kind of list corruption.

