From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 16 Apr 2018 19:42:11 +0000
Subject: Re: net: hang in unregister_netdevice: waiting for lo to become free
Message-Id: <CALZtONDn_yQb_EeSgbwk0Trzp7TA2uXLc6tuxmmWd0uyqOq5aA@mail.gmail.com>
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
 <CALZtONBFdVsa_dqKTpzAp2wVPPfP4N=P7HT_e5e0vy7oAoxVew@mail.gmail.com>
 <CACT4Y+ao0Z_RT+D+sqb6ysnPVnUZ5DfrHstuFjEAt0mr+xt_4Q@mail.gmail.com> <CACT4Y+a2TyMWfs+ZQ=gJMbpXzGoYOWLEDBJAjVY4cJTkYecV2A@mail.gmail.com>
In-Reply-To: <CACT4Y+a2TyMWfs+ZQ=gJMbpXzGoYOWLEDBJAjVY4cJTkYecV2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, David Ahern <dsahern@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Cong Wang <xiyou.wangcong@gmail.com>, David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, syzkaller <syzkaller@googlegroups.com>, Dan Streetman <ddstreet@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org

On Mon, Apr 16, 2018 at 3:35 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Fri, Apr 13, 2018 at 5:54 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
>> On Fri, Apr 13, 2018 at 2:43 PM, Dan Streetman <ddstreet@ieee.org> wrote:
>>> On Thu, Apr 12, 2018 at 8:15 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
>>>> On Wed, Feb 21, 2018 at 3:53 PM, Tommi Rantala
>>>> <tommi.t.rantala@nokia.com> wrote:
>>>>> On 20.02.2018 18:26, Neil Horman wrote:
>>>>>>
>>>>>> On Tue, Feb 20, 2018 at 09:14:41AM +0100, Dmitry Vyukov wrote:
>>>>>>>
>>>>>>> On Tue, Feb 20, 2018 at 8:56 AM, Tommi Rantala
>>>>>>> <tommi.t.rantala@nokia.com> wrote:
>>>>>>>>
>>>>>>>> On 19.02.2018 20:59, Dmitry Vyukov wrote:
>>>>>>>>>
>>>>>>>>> Is this meant to be fixed already? I am still seeing this on the
>>>>>>>>> latest upstream tree.
>>>>>>>>>
>>>>>>>>
>>>>>>>> These two commits are in v4.16-rc1:
>>>>>>>>
>>>>>>>> commit 4a31a6b19f9ddf498c81f5c9b089742b7472a6f8
>>>>>>>> Author: Tommi Rantala <tommi.t.rantala@nokia.com>
>>>>>>>> Date:   Mon Feb 5 21:48:14 2018 +0200
>>>>>>>>
>>>>>>>>      sctp: fix dst refcnt leak in sctp_v4_get_dst
>>>>>>>> ...
>>>>>>>>      Fixes: 410f03831 ("sctp: add routing output fallback")
>>>>>>>>      Fixes: 0ca50d12f ("sctp: fix src address selection if using
>>>>>>>> secondary
>>>>>>>> addresses")
>>>>>>>>
>>>>>>>>
>>>>>>>> commit 957d761cf91cdbb175ad7d8f5472336a4d54dbf2
>>>>>>>> Author: Alexey Kodanev <alexey.kodanev@oracle.com>
>>>>>>>> Date:   Mon Feb 5 15:10:35 2018 +0300
>>>>>>>>
>>>>>>>>      sctp: fix dst refcnt leak in sctp_v6_get_dst()
>>>>>>>> ...
>>>>>>>>      Fixes: dbc2b5e9a09e ("sctp: fix src address selection if using
>>>>>>>> secondary
>>>>>>>> addresses for ipv6")
>>>>>>>>
>>>>>>>>
>>>>>>>> I guess we missed something if it's still reproducible.
>>>>>>>>
>>>>>>>> I can check it later this week, unless someone else beat me to it.
>>>>>>>
>>>>>>>
>>>>>>> Hi Tommi,
>>>>>>>
>>>>>>> Hmmm, I can't claim that it's exactly the same bug. Perhaps it's
>>>>>>> another one then. But I am still seeing these:
>>>>>>>
>>>>>>> [   58.799130] unregister_netdevice: waiting for lo to become free.
>>>>>>> Usage count = 4
>>>>>>> [   60.847138] unregister_netdevice: waiting for lo to become free.
>>>>>>> Usage count = 4
>>>>>>> [   62.895093] unregister_netdevice: waiting for lo to become free.
>>>>>>> Usage count = 4
>>>>>>> [   64.943103] unregister_netdevice: waiting for lo to become free.
>>>>>>> Usage count = 4
>>>>>>>
>>>>>>> on upstream tree pulled ~12 hours ago.
>>>>>>>
>>>>>> Can you write a systemtap script to probe dev_hold, and dev_put, printing
>>>>>> out a
>>>>>> backtrace if the device name matches "lo".  That should tell us
>>>>>> definitively if
>>>>>> the problem is in the same location or not
>>>>>
>>>>>
>>>>> Hi Dmitry, I tested with the reproducer and the kernel .config file that you
>>>>> sent in the first email in this thread:
>>>>>
>>>>> With 4.16-rc2 unable to reproduce.
>>>>>
>>>>> With 4.15-rc9 bug reproducible, and I get "unregister_netdevice: waiting for
>>>>> lo to become free. Usage count = 3"
>>>>>
>>>>> With 4.15-rc9 and Alexey's "sctp: fix dst refcnt leak in sctp_v6_get_dst()"
>>>>> cherry-picked on top, unable to reproduce.
>>>>>
>>>>>
>>>>> Is syzkaller doing something else now to trigger the bug...?
>>>>> Can you still trigger the bug with the same reproducer?
>>>>
>>>> Hi Neil, Tommi,
>>>>
>>>> Reviving this old thread about "unregister_netdevice: waiting for lo
>>>> to become free. Usage count = 3" hangs.
>>>> I still did not have time to deep dive into what happens there (too
>>>> many bugs coming from syzbot). But this still actively happens and I
>>>> suspect accounts to a significant portion of various hang reports,
>>>> which are quite unpleasant.
>>>>
>>>> One idea that could make it all simpler:
>>>>
>>>> Is this wait loop in netdev_wait_allrefs() supposed to wait for any
>>>> prolonged periods of time under any non-buggy conditions? E.g. more
>>>> than 1-2 minutes?
>>>> If it only supposed to wait briefly for things that already supposed
>>>> to be shutting down, and we add a WARNING there after some timeout,
>>>> then syzbot will report all info how/when it happens, hopefully
>>>> extracting reproducers, and all the nice things.
>>>> But this WARNING should not have any false positives under any
>>>> realistic conditions (e.g. waiting for arrival of remote packets with
>>>> large timeouts).
>>>>
>>>> Looking at some task hung reports, it seems that this code holds some
>>>> mutexes, takes workqueue thread and prevents any progress with
>>>> destruction of other devices (and net namespace creation/destruction),
>>>> so I guess it should not wait for any indefinite periods of time?
>>>
>>> I'm working on this currently:
>>> https://bugs.launchpad.net/ubuntu/zesty/+source/linux/+bug/1711407
>>>
>>> I added a summary of what I've found to be the cause (or at least, one
>>> possible cause) of this:
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1711407/comments/72
>>>
>>> I'm working on a patch to work around the main side-effect of this,
>>> which is hanging while holding the global net mutex.  Hangs will still
>>> happen (e.g. if a dst leaks) but should not affect anything else,
>>> other than a leak of the dst and its net namespace.
>>>
>>> Fixing the dst leaks is important too, of course, but a dst leak (or
>>> other cause) shouldn't break the entire system.
>>
>> Leaking some memory is definitely better than hanging the system.
>>
>> So I've made syzkaller to recognize "unregister_netdevice: waiting for
>> (.*) to become free" as a kernel bug:
>> https://github.com/google/syzkaller/commit/7a67784ca8bdc3b26cce2f0ec9a40d2dd9ec9396
>> Unfortunately it does not make it catch these bugs because creating a
>> net namespace per test is too damn slow, so namespaces are reused for
>> lots of tests and when/if it's eventually destroyed it's already too
>> late to find root cause.
>>
>> But I've run a one-off experiment with prompt net namespace
>> destruction and syzkaller was able to easily extract a C reproducer:
>> https://gist.githubusercontent.com/dvyukov/d571e8fff24e127ca48a8c4790d42bfa/raw/52050e93ba9afbb5126b9d7bb39b7e71a82af016/gistfile1.txt
>>
>> On upstream 16e205cf42da1f497b10a4a24f563e6c0d574eec with this config:
>> https://gist.githubusercontent.com/dvyukov/9663c57443adb21f2795b92ef0829d62/raw/bbea0652e23746096dd56855a28f6c681aebcdee/gistfile1.txt
>>
>> this gives me:
>>
>> [   83.183198] unregister_netdevice: waiting for lo to become free.
>> Usage count = 9
>> [   85.231202] unregister_netdevice: waiting for lo to become free.
>> Usage count = 9
>> ...
>> [  523.511205] unregister_netdevice: waiting for lo to become free.
>> Usage count = 9
>> ...
>>
>> This is generated from this syzkaller program:
>>
>> r0 = socket$inet6(0xa, 0x1, 0x84)
>> setsockopt$inet6_IPV6_XFRM_POLICY(r0, 0x29, 0x23,
>> &(0x7f0000000380)={{{@in6=@remote={0xfe, 0x80, [], 0xbb},
>> @in=@dev={0xac, 0x14, 0x14}, 0x0, 0x0, 0x0, 0x0, 0xa}, {}, {}, 0x0,
>> 0x0, 0x1}, {{@in=@local={0xac, 0x14, 0x14, 0xaa}, 0x0, 0x32}, 0x0,
>> @in=@local={0xac, 0x14, 0x14, 0xaa}, 0x3504}}, 0xe8)
>> bind$inet6(r0, &(0x7f0000000000)={0xa, 0x4e20}, 0x1c)
>> connect$inet(r0, &(0x7f0000000040)={0x2, 0x4e20, @dev={0xac, 0x14,
>> 0x14, 0xd}}, 0x10)
>> syz_emit_ethernet(0x3e, &(0x7f00000001c0)={@local={[0xaa, 0xaa, 0xaa,
>> 0xaa, 0xaa], 0xaa}, @dev={[0xaa, 0xaa, 0xaa, 0xaa, 0xaa]}, [],
>> {@ipv6={0x86dd, {0x0, 0x6, "50a09c", 0x8, 0xffffff11, 0x0,
>> @remote={0xfe, 0x80, [], 0xbb}, @local={0xfe, 0x80, [], 0xaa}, {[],
>> @udp={0x0, 0x4e20, 0x8}}}}}}, &(0x7f0000000040))
>>
>> So this seems to be related to IPv6 and/or xfrm and is potentially
>> caused by external packets (that syz_emit_ethernet call).
>
>
>
> Here is another repro which seems to be a different bug (note that it
> requires fault injection):
>
> https://gist.githubusercontent.com/dvyukov/1c56623016cc4c24a69d433c5114ad5b/raw/530478f571b195193101b912aa646948528baa8e/gistfile1.txt
>
> Dan, do you mind taking a look at them? Fixing these should eliminate
> root causes of these hangs/leaks.

Yep I will look at them, thanks for the reproducers.
