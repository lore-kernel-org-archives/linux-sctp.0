From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Date: Wed, 20 Mar 2019 13:34:11 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <315c8ff3-fd03-f2ca-c546-ca7dc5c14669@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000db3d130584506672@google.com>
 <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
 <CACT4Y+Zj=35t2djhKoq+e1SH3Zu3389Pns7xX6MiMWZ=PFpShA@mail.gmail.com>
 <426293c3-bf63-88ad-06fb-83927ab0d7c0@I-love.SAKURA.ne.jp>
 <CACT4Y+Zh8eA50egLquE4LPffTCmF+30QR0pKTpuz_FpzsXVmZg@mail.gmail.com>
In-Reply-To: <CACT4Y+Zh8eA50egLquE4LPffTCmF+30QR0pKTpuz_FpzsXVmZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Qian Cai <cai@lca.pw>, David Miller <davem@davemloft.net>, guro@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <jbacik@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>, Vladislav Yasevich <vyasevich@gmail.com>, Matthew Wilcox <willy@infradead.org>, Xin Long <lucien.xin@gmail.com>



On 3/20/19 1:38 PM, Dmitry Vyukov wrote:
> On Wed, Mar 20, 2019 at 11:24 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> On 2019/03/20 18:59, Dmitry Vyukov wrote:
>>>> From bisection log:
>>>>
>>>>         testing release v4.17
>>>>         testing commit 29dcea88779c856c7dc92040a0c01233263101d4 with gcc (GCC) 8.1.0
>>>>         run #0: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         run #1: crashed: kernel panic: corrupted stack end in worker_thread
>>>>         run #2: crashed: kernel panic: Out of memory and no killable processes...
>>>>         run #3: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         run #4: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         run #5: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         run #6: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         run #7: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         run #8: crashed: kernel panic: Out of memory and no killable processes...
>>>>         run #9: crashed: kernel panic: corrupted stack end in wb_workfn
>>>>         testing release v4.16
>>>>         testing commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda with gcc (GCC) 8.1.0
>>>>         run #0: OK
>>>>         run #1: OK
>>>>         run #2: OK
>>>>         run #3: OK
>>>>         run #4: OK
>>>>         run #5: crashed: kernel panic: Out of memory and no killable processes...
>>>>         run #6: OK
>>>>         run #7: crashed: kernel panic: Out of memory and no killable processes...
>>>>         run #8: OK
>>>>         run #9: OK
>>>>         testing release v4.15
>>>>         testing commit d8a5b80568a9cb66810e75b182018e9edb68e8ff with gcc (GCC) 8.1.0
>>>>         all runs: OK
>>>>         # git bisect start v4.16 v4.15
>>>>
>>>> Why bisect started between 4.16 4.15 instead of 4.17 4.16?
>>>
>>> Because 4.16 was still crashing and 4.15 was not crashing. 4.15..4.16
>>> looks like the right range, no?
>>
>> No, syzbot should bisect between 4.16 and 4.17 regarding this bug, for
>> "Stack corruption" can't manifest as "Out of memory and no killable processes".
>>
>> "kernel panic: Out of memory and no killable processes..." is completely
>> unrelated to "kernel panic: corrupted stack end in wb_workfn".
> 
> 
> Do you think this predicate is possible to code?

Something like bellow probably would work better than current behavior.

For starters, is_duplicates() might just compare 'crash' title with 'target_crash' title and its duplicates titles.
syzbot has some knowledge about duplicates with different crash titles when people use "syz dup" command.
Also it might be worth to experiment with using neural networks to identify duplicates.


target_crash = 'kernel panic: corrupted stack end in wb_workfn'
test commit:
	bad = false;
	skip = true;
	foreach run:
		run_started, crashed, crash := run_repro();

		//kernel built, booted, reproducer launched successfully
		if (run_started)
			skip = false;
		if (crashed && is_duplicates(crash, target_crash))
			bad = true;
	
	if (skip)
		git bisect skip;
	else if (bad)
		git bisect bad;
	else
		git bisect good;
