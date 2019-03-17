From: syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>
Date: Sun, 17 Mar 2019 20:49:01 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <000000000000db3d130584506672@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <000000000000b05d0c057e492e33@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, cai@lca.pw, davem@davemloft.net, dvyukov@google.com, guro@fb.com, hannes@cmpxchg.org, jbacik@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, mgorman@techsingularity.net, mhocko@suse.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, shakeelb@google.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk, vyasevich@gmail.com, willy@infradead.org

syzbot has bisected this bug to:

commit c981f254cc82f50f8cb864ce6432097b23195b9c
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Jan 7 18:19:09 2018 +0000

     sctp: use vmemdup_user() rather than badly open-coding memdup_user()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137bcecf200000
start commit:   c981f254 sctp: use vmemdup_user() rather than badly open-c..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10fbcecf200000
console output: https://syzkaller.appspot.com/x/log.txt?x=177bcecf200000
kernel config:  https://syzkaller.appspot.com/x/.config?x^7dc790609552d7
dashboard link: https://syzkaller.appspot.com/bug?extid=EC1b7575afef85a0e5ca
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a9a84b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17199bb3400000

Reported-by: syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com
Fixes: c981f254 ("sctp: use vmemdup_user() rather than badly open-coding =20
memdup_user()")
