From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 20 Mar 2019 10:42:36 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <CACT4Y+Z2FL=t8cHceXMGvG2QfChKdJYprVvBonu9X+jJaL0HMQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000db3d130584506672@google.com> <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
 <CACT4Y+Zj=35t2djhKoq+e1SH3Zu3389Pns7xX6MiMWZ=PFpShA@mail.gmail.com>
 <426293c3-bf63-88ad-06fb-83927ab0d7c0@I-love.SAKURA.ne.jp> <CACT4Y+Zh8eA50egLquE4LPffTCmF+30QR0pKTpuz_FpzsXVmZg@mail.gmail.com>
In-Reply-To: <CACT4Y+Zh8eA50egLquE4LPffTCmF+30QR0pKTpuz_FpzsXVmZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Qian Cai <cai@lca.pw>, David Miller <davem@davemloft.net>, guro@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <jbacik@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>, Vladislav Yasevich <vyasevich@gmail.com>, Matthew Wilcox <willy@infradead.org>, Xin Long <lucien.xin@gmail.com>

On Wed, Mar 20, 2019 at 11:38 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Mar 20, 2019 at 11:24 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >
> > On 2019/03/20 18:59, Dmitry Vyukov wrote:
> > >> From bisection log:
> > >>
> > >>         testing release v4.17
> > >>         testing commit 29dcea88779c856c7dc92040a0c01233263101d4 with gcc (GCC) 8.1.0
> > >>         run #0: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         run #1: crashed: kernel panic: corrupted stack end in worker_thread
> > >>         run #2: crashed: kernel panic: Out of memory and no killable processes...
> > >>         run #3: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         run #4: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         run #5: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         run #6: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         run #7: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         run #8: crashed: kernel panic: Out of memory and no killable processes...
> > >>         run #9: crashed: kernel panic: corrupted stack end in wb_workfn
> > >>         testing release v4.16
> > >>         testing commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda with gcc (GCC) 8.1.0
> > >>         run #0: OK
> > >>         run #1: OK
> > >>         run #2: OK
> > >>         run #3: OK
> > >>         run #4: OK
> > >>         run #5: crashed: kernel panic: Out of memory and no killable processes...
> > >>         run #6: OK
> > >>         run #7: crashed: kernel panic: Out of memory and no killable processes...
> > >>         run #8: OK
> > >>         run #9: OK
> > >>         testing release v4.15
> > >>         testing commit d8a5b80568a9cb66810e75b182018e9edb68e8ff with gcc (GCC) 8.1.0
> > >>         all runs: OK
> > >>         # git bisect start v4.16 v4.15
> > >>
> > >> Why bisect started between 4.16 4.15 instead of 4.17 4.16?
> > >
> > > Because 4.16 was still crashing and 4.15 was not crashing. 4.15..4.16
> > > looks like the right range, no?
> >
> > No, syzbot should bisect between 4.16 and 4.17 regarding this bug, for
> > "Stack corruption" can't manifest as "Out of memory and no killable processes".
> >
> > "kernel panic: Out of memory and no killable processes..." is completely
> > unrelated to "kernel panic: corrupted stack end in wb_workfn".
>
>
> Do you think this predicate is possible to code? Looking at the
> examples we have, distinguishing different bugs does not look feasible
> to me. If the predicate is not accurate, you just trade one set of
> false positives to another set of false positives and then you at the
> beginning of an infinite slippery slope refining it.
> Also, if we see a different bug (assuming we can distinguish them),
> does it mean that the original bug is not present? Or it's also
> present, but we just hit the other one first? This also does not look
> feasible to answer. And if you give a wrong answer, bisection goes the
> wrong way and we are where we started. Just with more complex code and
> things being even harder to explain to other people.
> I mean, yes, I agree, kernel bug bisection won't be perfect. But do
> you see anything actionable here?

I see the larger long term bisection quality improvement (for syzbot
and for everybody else) in doing some actual testing for each kernel
commit before it's being merged into any kernel tree, so that we have
less of these a single program triggers 3 different bugs, stray
unrelated bugs, broken release boots, etc. I don't see how reliable
bisection is possible without that.
