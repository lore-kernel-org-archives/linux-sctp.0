From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 20 Mar 2019 09:59:09 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <CACT4Y+Zj=35t2djhKoq+e1SH3Zu3389Pns7xX6MiMWZ=PFpShA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000db3d130584506672@google.com> <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
In-Reply-To: <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Qian Cai <cai@lca.pw>, David Miller <davem@davemloft.net>, guro@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <jbacik@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>, Vladislav Yasevich <vyasevich@gmail.com>, Matthew Wilcox <willy@infradead.org>, Xin Long <lucien.xin@gmail.com>

On Wed, Mar 20, 2019 at 10:56 AM Andrey Ryabinin
<aryabinin@virtuozzo.com> wrote:
>
> On 3/17/19 11:49 PM, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit c981f254cc82f50f8cb864ce6432097b23195b9c
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Sun Jan 7 18:19:09 2018 +0000
> >
> >     sctp: use vmemdup_user() rather than badly open-coding memdup_user()
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137bcecf20=
0000
> > start commit:   c981f254 sctp: use vmemdup_user() rather than badly ope=
n-c..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=10fbcecf20=
0000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=177bcecf200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x^7dc790609552d7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=EC1b7575afef85a=
0e5ca
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a9a84b400=
000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17199bb3400000
> >
> > Reported-by: syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com
> > Fixes: c981f254 ("sctp: use vmemdup_user() rather than badly open-codin=
g memdup_user()")
>
> From bisection log:
>
>         testing release v4.17
>         testing commit 29dcea88779c856c7dc92040a0c01233263101d4 with gcc =
(GCC) 8.1.0
>         run #0: crashed: kernel panic: corrupted stack end in wb_workfn
>         run #1: crashed: kernel panic: corrupted stack end in worker_thre=
ad
>         run #2: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #3: crashed: kernel panic: corrupted stack end in wb_workfn
>         run #4: crashed: kernel panic: corrupted stack end in wb_workfn
>         run #5: crashed: kernel panic: corrupted stack end in wb_workfn
>         run #6: crashed: kernel panic: corrupted stack end in wb_workfn
>         run #7: crashed: kernel panic: corrupted stack end in wb_workfn
>         run #8: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #9: crashed: kernel panic: corrupted stack end in wb_workfn
>         testing release v4.16
>         testing commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda with gcc =
(GCC) 8.1.0
>         run #0: OK
>         run #1: OK
>         run #2: OK
>         run #3: OK
>         run #4: OK
>         run #5: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #6: OK
>         run #7: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #8: OK
>         run #9: OK
>         testing release v4.15
>         testing commit d8a5b80568a9cb66810e75b182018e9edb68e8ff with gcc =
(GCC) 8.1.0
>         all runs: OK
>         # git bisect start v4.16 v4.15
>
> Why bisect started between 4.16 4.15 instead of 4.17 4.16?

Because 4.16 was still crashing and 4.15 was not crashing. 4.15..4.16
looks like the right range, no?


>         testing commit c14376de3a1befa70d9811ca2872d47367b48767 with gcc =
(GCC) 8.1.0
>         run #0: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #1: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #2: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #3: crashed: kernel panic: Out of memory and no killable proc=
esses...
>         run #4: OK
>         run #5: OK
>         run #6: crashed: WARNING: ODEBUG bug in netdev_freemem
>         run #7: crashed: no output from test machine
>         run #8: OK
>         run #9: OK
>         # git bisect bad c14376de3a1befa70d9811ca2872d47367b48767
>
> Why c14376de3a1befa70d9811ca2872d47367b48767 is bad? There was no stack c=
orruption.
> It looks like the syzbot were bisecting a different bug - "kernel panic: =
Out of memory and no killable processes..."
> And bisection for that bug seems to be correct. kvmalloc() in vmemdup_use=
r() may eat up all memory unlike kmalloc which is limited by KMALLOC_MAX_SI=
ZE (4MB usually).

Please see https://github.com/google/syzkaller/blob/master/docs/syzbot.md#b=
isection
for answer.
