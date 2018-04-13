From: Dan Streetman <ddstreet@ieee.org>
Date: Fri, 13 Apr 2018 12:43:40 +0000
Subject: Re: net: hang in unregister_netdevice: waiting for lo to become free
Message-Id: <CALZtONBFdVsa_dqKTpzAp2wVPPfP4N=P7HT_e5e0vy7oAoxVew@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+ZyUxeUqEB7q1EHcs4j93mtk9UOBuYhJtcnnc8AfApoLw@mail.gmail.com>
 <CAM_iQpVo0iSXKSR=Qc+7syn77BnhE2R72M2u5YfJF=fBkJHjsw@mail.gmail.com>
 <7fd7e3b3-77b1-0936-b169-d08b946bedc7@iogearbox.net> <991243e2-e7c2-f2b2-72b9-d37b0d569b3b@gmail.com>
 <efa5811c-0a01-a4af-ade2-71ef5dbc4eaf@gmail.com> <CADvbK_dgEa5g0ynY4F8pX6LuuBwW4e42rK_TFuRhY1=2G5zinw@mail.gmail.com>
 <CADvbK_fKDbUnAkdLrgm6rgj895Gb06AK7HaT0s9VD=zdF+vf6Q@mail.gmail.com>
 <CACT4Y+aV_v6zNS6Ac1u1cB2GZ7QhjNxBeg0FNabUhrndt5CqZw@mail.gmail.com>
 <5973966e-fcd9-7ee5-a9c4-b79d22c1b9dd@nokia.com> <CACT4Y+beZ2+O=XdjKCpAkXOTBDgHYfn1JW8kn-TGRrph_RmV7Q@mail.gmail.com>
 <20180220162622.GA32068@hmswarspite.think-freely.org> <7d98027d-e810-a079-49c5-0bf8beef390e@nokia.com>
 <CACT4Y+Z2kdjsYUs-H9aSTcNW-FSKqm1__fg3eOq16H-E=X8oZg@mail.gmail.com>
In-Reply-To: <CACT4Y+Z2kdjsYUs-H9aSTcNW-FSKqm1__fg3eOq16H-E=X8oZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, David Ahern <dsahern@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Cong Wang <xiyou.wangcong@gmail.com>, David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, syzkaller <syzkaller@googlegroups.com>, Dan Streetman <ddstreet@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org

On Thu, Apr 12, 2018 at 8:15 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Wed, Feb 21, 2018 at 3:53 PM, Tommi Rantala
> <tommi.t.rantala@nokia.com> wrote:
>> On 20.02.2018 18:26, Neil Horman wrote:
>>>
>>> On Tue, Feb 20, 2018 at 09:14:41AM +0100, Dmitry Vyukov wrote:
>>>>
>>>> On Tue, Feb 20, 2018 at 8:56 AM, Tommi Rantala
>>>> <tommi.t.rantala@nokia.com> wrote:
>>>>>
>>>>> On 19.02.2018 20:59, Dmitry Vyukov wrote:
>>>>>>
>>>>>> Is this meant to be fixed already? I am still seeing this on the
>>>>>> latest upstream tree.
>>>>>>
>>>>>
>>>>> These two commits are in v4.16-rc1:
>>>>>
>>>>> commit 4a31a6b19f9ddf498c81f5c9b089742b7472a6f8
>>>>> Author: Tommi Rantala <tommi.t.rantala@nokia.com>
>>>>> Date:   Mon Feb 5 21:48:14 2018 +0200
>>>>>
>>>>>      sctp: fix dst refcnt leak in sctp_v4_get_dst
>>>>> ...
>>>>>      Fixes: 410f03831 ("sctp: add routing output fallback")
>>>>>      Fixes: 0ca50d12f ("sctp: fix src address selection if using
>>>>> secondary
>>>>> addresses")
>>>>>
>>>>>
>>>>> commit 957d761cf91cdbb175ad7d8f5472336a4d54dbf2
>>>>> Author: Alexey Kodanev <alexey.kodanev@oracle.com>
>>>>> Date:   Mon Feb 5 15:10:35 2018 +0300
>>>>>
>>>>>      sctp: fix dst refcnt leak in sctp_v6_get_dst()
>>>>> ...
>>>>>      Fixes: dbc2b5e9a09e ("sctp: fix src address selection if using
>>>>> secondary
>>>>> addresses for ipv6")
>>>>>
>>>>>
>>>>> I guess we missed something if it's still reproducible.
>>>>>
>>>>> I can check it later this week, unless someone else beat me to it.
>>>>
>>>>
>>>> Hi Tommi,
>>>>
>>>> Hmmm, I can't claim that it's exactly the same bug. Perhaps it's
>>>> another one then. But I am still seeing these:
>>>>
>>>> [   58.799130] unregister_netdevice: waiting for lo to become free.
>>>> Usage count = 4
>>>> [   60.847138] unregister_netdevice: waiting for lo to become free.
>>>> Usage count = 4
>>>> [   62.895093] unregister_netdevice: waiting for lo to become free.
>>>> Usage count = 4
>>>> [   64.943103] unregister_netdevice: waiting for lo to become free.
>>>> Usage count = 4
>>>>
>>>> on upstream tree pulled ~12 hours ago.
>>>>
>>> Can you write a systemtap script to probe dev_hold, and dev_put, printing
>>> out a
>>> backtrace if the device name matches "lo".  That should tell us
>>> definitively if
>>> the problem is in the same location or not
>>
>>
>> Hi Dmitry, I tested with the reproducer and the kernel .config file that you
>> sent in the first email in this thread:
>>
>> With 4.16-rc2 unable to reproduce.
>>
>> With 4.15-rc9 bug reproducible, and I get "unregister_netdevice: waiting for
>> lo to become free. Usage count = 3"
>>
>> With 4.15-rc9 and Alexey's "sctp: fix dst refcnt leak in sctp_v6_get_dst()"
>> cherry-picked on top, unable to reproduce.
>>
>>
>> Is syzkaller doing something else now to trigger the bug...?
>> Can you still trigger the bug with the same reproducer?
>
> Hi Neil, Tommi,
>
> Reviving this old thread about "unregister_netdevice: waiting for lo
> to become free. Usage count = 3" hangs.
> I still did not have time to deep dive into what happens there (too
> many bugs coming from syzbot). But this still actively happens and I
> suspect accounts to a significant portion of various hang reports,
> which are quite unpleasant.
>
> One idea that could make it all simpler:
>
> Is this wait loop in netdev_wait_allrefs() supposed to wait for any
> prolonged periods of time under any non-buggy conditions? E.g. more
> than 1-2 minutes?
> If it only supposed to wait briefly for things that already supposed
> to be shutting down, and we add a WARNING there after some timeout,
> then syzbot will report all info how/when it happens, hopefully
> extracting reproducers, and all the nice things.
> But this WARNING should not have any false positives under any
> realistic conditions (e.g. waiting for arrival of remote packets with
> large timeouts).
>
> Looking at some task hung reports, it seems that this code holds some
> mutexes, takes workqueue thread and prevents any progress with
> destruction of other devices (and net namespace creation/destruction),
> so I guess it should not wait for any indefinite periods of time?

I'm working on this currently:
https://bugs.launchpad.net/ubuntu/zesty/+source/linux/+bug/1711407

I added a summary of what I've found to be the cause (or at least, one
possible cause) of this:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1711407/comments/72

I'm working on a patch to work around the main side-effect of this,
which is hanging while holding the global net mutex.  Hangs will still
happen (e.g. if a dst leaks) but should not affect anything else,
other than a leak of the dst and its net namespace.

Fixing the dst leaks is important too, of course, but a dst leak (or
other cause) shouldn't break the entire system.
