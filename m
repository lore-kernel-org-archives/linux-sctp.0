From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 19 Mar 2019 18:03:03 +0000
Subject: Re: kernel panic: corrupted stack end in wb_workfn
Message-Id: <CADvbK_f6cDsJzXa3fzj3EFq+-hRD9EYXqbhkXq8gHqMEpqp8bA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000b05d0c057e492e33@google.com> <000000000000db3d130584506672@google.com>
In-Reply-To: <000000000000db3d130584506672@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, aryabinin@virtuozzo.com, cai@lca.pw, davem <davem@davemloft.net>, Dmitry Vyukov <dvyukov@google.com>, guro@fb.com, hannes@cmpxchg.org, jbacik@fb.com, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, mgorman@techsingularity.net, mhocko@suse.com, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, shakeelb@google.com, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, viro@zeniv.linux.org.uk, Vlad Yasevich <vyasevich@gmail.com>, willy@infradead.org

On Mon, Mar 18, 2019 at 4:49 AM syzbot
<syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit c981f254cc82f50f8cb864ce6432097b23195b9c
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun Jan 7 18:19:09 2018 +0000
>
>      sctp: use vmemdup_user() rather than badly open-coding memdup_user()
'addrs_size' is passed from users, we actually used GFP_USER to
put some more restrictions on it in this commit:

commit cacc06215271104b40773c99547c506095db6ad4
Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Mon Nov 30 14:32:54 2015 -0200

    sctp: use GFP_USER for user-controlled kmalloc

However, vmemdup_user() will 'ignore' this flag when going to vmalloc_*(),
So we probably should fix it by using memdup_user() to avoid that
open-coding part instead:

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ea95cd4..e5bcade 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -999,7 +999,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
        if (unlikely(addrs_size <=3D 0))
                return -EINVAL;

-       kaddrs =3D vmemdup_user(addrs, addrs_size);
+       kaddrs =3D memdup_user(addrs, addrs_size);

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137bcecf2000=
00
> start commit:   c981f254 sctp: use vmemdup_user() rather than badly open-=
c..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10fbcecf2000=
00
> console output: https://syzkaller.appspot.com/x/log.txt?x=177bcecf200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x^7dc790609552d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=EC1b7575afef85a0e=
5ca
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a9a84b400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17199bb3400000
>
> Reported-by: syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com
> Fixes: c981f254 ("sctp: use vmemdup_user() rather than badly open-coding
> memdup_user()")
