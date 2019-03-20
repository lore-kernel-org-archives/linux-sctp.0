From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 20 Mar 2019 13:59:19 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <CACT4Y+b-VNeKwgP9-x2YZJ08v0f=2C2SujVkgEmcQ+B-ZmmCLQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000db3d130584506672@google.com> <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
 <CACT4Y+Zj=35t2djhKoq+e1SH3Zu3389Pns7xX6MiMWZ=PFpShA@mail.gmail.com>
 <426293c3-bf63-88ad-06fb-83927ab0d7c0@I-love.SAKURA.ne.jp>
 <CACT4Y+Zh8eA50egLquE4LPffTCmF+30QR0pKTpuz_FpzsXVmZg@mail.gmail.com>
 <CACT4Y+Z2FL=t8cHceXMGvG2QfChKdJYprVvBonu9X+jJaL0HMQ@mail.gmail.com> <a06830e7-e396-6dd5-d9d5-2a7b1df9efc1@i-love.sakura.ne.jp>
In-Reply-To: <a06830e7-e396-6dd5-d9d5-2a7b1df9efc1@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Qian Cai <cai@lca.pw>, David Miller <davem@davemloft.net>, guro@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <jbacik@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>, Vladislav Yasevich <vyasevich@gmail.com>, Matthew Wilcox <willy@infradead.org>, Xin Long <lucien.xin@gmail.com>

On Wed, Mar 20, 2019 at 11:59 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2019/03/20 19:42, Dmitry Vyukov wrote:
> >> I mean, yes, I agree, kernel bug bisection won't be perfect. But do
> >> you see anything actionable here?
>
> Allow users to manually tell bisection range when
> automatic bisection found a wrong commit.
>
> Also, allow users to specify reproducer program
> when automatic bisection found a wrong commit.
>
> Yes, this is anti automation. But since automation can't become perfect,
> I'm suggesting manual adjustment. Even if we involve manual adjustment,
> the syzbot's plenty CPU resources for building/testing kernels is highly
> appreciated (compared to doing manual bisection by building/testing kernels
> on personal PC environments).

FTR: provided an extended answer here:
https://groups.google.com/d/msg/syzkaller-bugs/1BSkmb_fawo/DOcDxv_KAgAJ


> > I see the larger long term bisection quality improvement (for syzbot
> > and for everybody else) in doing some actual testing for each kernel
> > commit before it's being merged into any kernel tree, so that we have
> > less of these a single program triggers 3 different bugs, stray
> > unrelated bugs, broken release boots, etc. I don't see how reliable
> > bisection is possible without that.
> >
>
> syzbot currently cannot test kernels with custom patches (unless "#syz test:" requests).
> Are you saying that syzbot will become be able to test kernels with custom patches?

I mean if we start improving kernel quality over time so that we have
less of these a single program triggers 3 different bugs, stray
unrelated bugs, broken release boots, etc, it will improve bisection
quality for everybody (beside being hugely useful in itself).
