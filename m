From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 21 Mar 2019 09:45:45 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <CACT4Y+aGyPpkrwvzZQUHXgipWo26T2U4OW0CxoJpp6yK+MgX=Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000db3d130584506672@google.com> <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
 <CACT4Y+Zj=35t2djhKoq+e1SH3Zu3389Pns7xX6MiMWZ=PFpShA@mail.gmail.com>
 <426293c3-bf63-88ad-06fb-83927ab0d7c0@I-love.SAKURA.ne.jp>
 <CACT4Y+Zh8eA50egLquE4LPffTCmF+30QR0pKTpuz_FpzsXVmZg@mail.gmail.com>
 <315c8ff3-fd03-f2ca-c546-ca7dc5c14669@virtuozzo.com> <CACT4Y+axojyHxk5K34YuLUyj+NJ05+FC3n8ozseHC91B1qn5ZQ@mail.gmail.com>
In-Reply-To: <CACT4Y+axojyHxk5K34YuLUyj+NJ05+FC3n8ozseHC91B1qn5ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Qian Cai <cai@lca.pw>, David Miller <davem@davemloft.net>, guro@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <jbacik@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>, Vladislav Yasevich <vyasevich@gmail.com>, Matthew Wilcox <willy@infradead.org>, Xin Long <lucien.xin@gmail.com>

On Wed, Mar 20, 2019 at 2:57 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Mar 20, 2019 at 2:33 PM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> >
> >
> >
> > On 3/20/19 1:38 PM, Dmitry Vyukov wrote:
> > > On Wed, Mar 20, 2019 at 11:24 AM Tetsuo Handa
> > > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > >>
> > >> On 2019/03/20 18:59, Dmitry Vyukov wrote:
> > >>>> From bisection log:
> > >>>>
> > >>>>         testing release v4.17
> > >>>>         testing commit 29dcea88779c856c7dc92040a0c01233263101d4 with gcc (GCC) 8.1.0
> > >>>>         run #0: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         run #1: crashed: kernel panic: corrupted stack end in worker_thread
> > >>>>         run #2: crashed: kernel panic: Out of memory and no killable processes...
> > >>>>         run #3: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         run #4: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         run #5: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         run #6: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         run #7: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         run #8: crashed: kernel panic: Out of memory and no killable processes...
> > >>>>         run #9: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>>>         testing release v4.16
> > >>>>         testing commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda with gcc (GCC) 8.1.0
> > >>>>         run #0: OK
> > >>>>         run #1: OK
> > >>>>         run #2: OK
> > >>>>         run #3: OK
> > >>>>         run #4: OK
> > >>>>         run #5: crashed: kernel panic: Out of memory and no killable processes...
> > >>>>         run #6: OK
> > >>>>         run #7: crashed: kernel panic: Out of memory and no killable processes...
> > >>>>         run #8: OK
> > >>>>         run #9: OK
> > >>>>         testing release v4.15
> > >>>>         testing commit d8a5b80568a9cb66810e75b182018e9edb68e8ff with gcc (GCC) 8.1.0
> > >>>>         all runs: OK
> > >>>>         # git bisect start v4.16 v4.15
> > >>>>
> > >>>> Why bisect started between 4.16 4.15 instead of 4.17 4.16?
> > >>>
> > >>> Because 4.16 was still crashing and 4.15 was not crashing. 4.15..4.16
> > >>> looks like the right range, no?
> > >>
> > >> No, syzbot should bisect between 4.16 and 4.17 regarding this bug, for
> > >> "Stack corruption" can't manifest as "Out of memory and no killable processes".
> > >>
> > >> "kernel panic: Out of memory and no killable processes..." is completely
> > >> unrelated to "kernel panic: corrupted stack end in wb_workfn".
> > >
> > >
> > > Do you think this predicate is possible to code?
> >
> > Something like bellow probably would work better than current behavior.
> >
> > For starters, is_duplicates() might just compare 'crash' title with 'target_crash' title and its duplicates titles.
>
> Lots of bugs (half?) manifest differently. On top of this, titles
> change as we go back in history. On top of this, if we see a different
> bug, it does not mean that the original bug is also not there.
> This will sure solve some subset of cases better then the current
> logic. But I feel that that subset is smaller then what the current
> logic solves.

Counter-examples come up in basically every other bisection.
For example:

bisecting cause commit starting from ccda4af0f4b92f7b4c308d3acc262f4a7e3affad
building syzkaller on 5f5f6d14e80b8bd6b42db961118e902387716bcb
testing commit ccda4af0f4b92f7b4c308d3acc262f4a7e3affad with gcc (GCC) 8.1.0
all runs: crashed: KASAN: null-ptr-deref Read in refcount_sub_and_test_checked
testing release v4.19
testing commit 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d with gcc (GCC) 8.1.0
all runs: crashed: KASAN: null-ptr-deref Read in refcount_sub_and_test_checked
testing release v4.18
testing commit 94710cac0ef4ee177a63b5227664b38c95bbf703 with gcc (GCC) 8.1.0
all runs: crashed: KASAN: null-ptr-deref Read in refcount_sub_and_test
testing release v4.17
testing commit 29dcea88779c856c7dc92040a0c01233263101d4 with gcc (GCC) 8.1.0
all runs: crashed: KASAN: null-ptr-deref Read in refcount_sub_and_test

That's a different crash title, unless somebody explicitly code this case.

Or, what crash is this?

testing commit 52358cb5a310990ea5069f986bdab3620e01181f with gcc (GCC) 8.1.0
run #1: crashed: general protection fault in cpuacct_charge
run #2: crashed: WARNING: suspicious RCU usage in corrupted
run #3: crashed: general protection fault in cpuacct_charge
run #4: crashed: BUG: unable to handle kernel paging request in ipt_do_table
run #5: crashed: KASAN: stack-out-of-bounds Read in cpuacct_charge
run #6: crashed: WARNING: suspicious RCU usage
run #7: crashed: no output from test machine
run #8: crashed: no output from test machine


Or, that "INFO: trying to register non-static key in can_notifier"
does not do any testing, but is "WARNING in dma_buf_vunmap" still
there or not?

testing commit 6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c with gcc (GCC) 8.1.0
all runs: crashed: WARNING in dma_buf_vunmap
testing release v4.11
testing commit a351e9b9fc24e982ec2f0e76379a49826036da12 with gcc (GCC) 7.3.0
all runs: OK
# git bisect start v4.12 v4.11
Bisecting: 7831 revisions left to test after this (roughly 13 steps)
[2bd80401743568ced7d303b008ae5298ce77e695] Merge tag 'gpio-v4.12-1' of
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
testing commit 2bd80401743568ced7d303b008ae5298ce77e695 with gcc (GCC) 7.3.0
all runs: crashed: INFO: trying to register non-static key in can_notifier
# git bisect bad 2bd80401743568ced7d303b008ae5298ce77e695
Bisecting: 3853 revisions left to test after this (roughly 12 steps)
[8d65b08debc7e62b2c6032d7fe7389d895b92cbc] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
testing commit 8d65b08debc7e62b2c6032d7fe7389d895b92cbc with gcc (GCC) 7.3.0
all runs: crashed: INFO: trying to register non-static key in can_notifier
# git bisect bad 8d65b08debc7e62b2c6032d7fe7389d895b92cbc
Bisecting: 2022 revisions left to test after this (roughly 11 steps)
[cec381919818a9a0cb85600b3c82404bdd38cf36] Merge tag
'mac80211-next-for-davem-2017-04-28' of
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
testing commit cec381919818a9a0cb85600b3c82404bdd38cf36 with gcc (GCC) 5.5.0
all runs: crashed: INFO: trying to register non-static key in can_notifier






> > syzbot has some knowledge about duplicates with different crash titles when people use "syz dup" command.
>
> This is very limited set of info. And in the end I think we've seen
> all bug types being duped on all other bugs types pair-wise, and at
> the same time we've seen all bug types being not dups to all other bug
> types. So I don't see where this gets us.
> And again as we go back in history all these titles change.
>
> > Also it might be worth to experiment with using neural networks to identify duplicates.
> >
> >
> > target_crash = 'kernel panic: corrupted stack end in wb_workfn'
> > test commit:
> >         bad = false;
> >         skip = true;
> >         foreach run:
> >                 run_started, crashed, crash := run_repro();
> >
> >                 //kernel built, booted, reproducer launched successfully
> >                 if (run_started)
> >                         skip = false;
> >                 if (crashed && is_duplicates(crash, target_crash))
> >                         bad = true;
> >
> >         if (skip)
> >                 git bisect skip;
> >         else if (bad)
> >                 git bisect bad;
> >         else
> >                 git bisect good;
