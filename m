From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Date: Wed, 20 Mar 2019 09:56:50 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <d9e4e36d-1e7a-caaf-f96e-b05592405b5f@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000db3d130584506672@google.com>
In-Reply-To: <000000000000db3d130584506672@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>, akpm@linux-foundation.org, cai@lca.pw, davem@davemloft.net, dvyukov@google.com, guro@fb.com, hannes@cmpxchg.org, jbacik@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, mgorman@techsingularity.net, mhocko@suse.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, shakeelb@google.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk, vyasevich@gmail.com, willy@infradead.org
Cc: Xin Long <lucien.xin@gmail.com>



On 3/17/19 11:49 PM, syzbot wrote:
> syzbot has bisected this bug to:
>=20
> commit c981f254cc82f50f8cb864ce6432097b23195b9c
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:=C2=A0=C2=A0 Sun Jan 7 18:19:09 2018 +0000
>=20
> =C2=A0=C2=A0=C2=A0 sctp: use vmemdup_user() rather than badly open-coding=
 memdup_user()
>=20
> bisection log:=C2=A0 https://syzkaller.appspot.com/x/bisect.txt?x=137bcec=
f200000
> start commit:=C2=A0=C2=A0 c981f254 sctp: use vmemdup_user() rather than b=
adly open-c..
> git tree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 upstream
> final crash:=C2=A0=C2=A0=C2=A0 https://syzkaller.appspot.com/x/report.txt=
?x=10fbcecf200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=177bcecf200000
> kernel config:=C2=A0 https://syzkaller.appspot.com/x/.config?x^7dc7906095=
52d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=EC1b7575afef85a0e=
5ca
> syz repro:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://syzkaller.appspot.com/x/=
repro.syz?x=16a9a84b400000
> C reproducer:=C2=A0=C2=A0 https://syzkaller.appspot.com/x/repro.c?x=17199=
bb3400000
>=20
> Reported-by: syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com
> Fixes: c981f254 ("sctp: use vmemdup_user() rather than badly open-coding =
memdup_user()")

From bisection log:

	testing release v4.17
	testing commit 29dcea88779c856c7dc92040a0c01233263101d4 with gcc (GCC) 8.1=
.0
	run #0: crashed: kernel panic: corrupted stack end in wb_workfn
	run #1: crashed: kernel panic: corrupted stack end in worker_thread
	run #2: crashed: kernel panic: Out of memory and no killable processes...
	run #3: crashed: kernel panic: corrupted stack end in wb_workfn
	run #4: crashed: kernel panic: corrupted stack end in wb_workfn
	run #5: crashed: kernel panic: corrupted stack end in wb_workfn
	run #6: crashed: kernel panic: corrupted stack end in wb_workfn
	run #7: crashed: kernel panic: corrupted stack end in wb_workfn
	run #8: crashed: kernel panic: Out of memory and no killable processes...
	run #9: crashed: kernel panic: corrupted stack end in wb_workfn
	testing release v4.16
	testing commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda with gcc (GCC) 8.1=
.0
	run #0: OK
	run #1: OK
	run #2: OK
	run #3: OK
	run #4: OK
	run #5: crashed: kernel panic: Out of memory and no killable processes...
	run #6: OK
	run #7: crashed: kernel panic: Out of memory and no killable processes...
	run #8: OK
	run #9: OK
	testing release v4.15
	testing commit d8a5b80568a9cb66810e75b182018e9edb68e8ff with gcc (GCC) 8.1=
.0
	all runs: OK
	# git bisect start v4.16 v4.15

Why bisect started between 4.16 4.15 instead of 4.17 4.16?


	testing commit c14376de3a1befa70d9811ca2872d47367b48767 with gcc (GCC) 8.1=
.0
	run #0: crashed: kernel panic: Out of memory and no killable processes...
	run #1: crashed: kernel panic: Out of memory and no killable processes...
	run #2: crashed: kernel panic: Out of memory and no killable processes...
	run #3: crashed: kernel panic: Out of memory and no killable processes...
	run #4: OK
	run #5: OK
	run #6: crashed: WARNING: ODEBUG bug in netdev_freemem
	run #7: crashed: no output from test machine
	run #8: OK
	run #9: OK
	# git bisect bad c14376de3a1befa70d9811ca2872d47367b48767

Why c14376de3a1befa70d9811ca2872d47367b48767 is bad? There was no stack cor=
ruption.
It looks like the syzbot were bisecting a different bug - "kernel panic: Ou=
t of memory and no killable processes..."
And bisection for that bug seems to be correct. kvmalloc() in vmemdup_user(=
) may eat up all memory unlike kmalloc which is limited by KMALLOC_MAX_SIZE=
 (4MB usually).
