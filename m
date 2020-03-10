From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 Mar 2020 16:01:18 +0000
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-Id: <202003100900.1E2E399@keescook>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000088452f05a07621d2@google.com>
 <000000000000cc985b05a07ce36f@google.com>
In-Reply-To: <000000000000cc985b05a07ce36f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc: ardb@kernel.org, davem@davemloft.net, guohanjun@huawei.com, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, mingo@kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com, will@kernel.org

On Tue, Mar 10, 2020 at 02:39:01AM -0700, syzbot wrote:
> syzbot has bisected this bug to:
>=20
> commit fb041bb7c0a918b95c6889fc965cdc4a75b4c0ca
> Author: Will Deacon <will@kernel.org>
> Date:   Thu Nov 21 11:59:00 2019 +0000
>=20
>     locking/refcount: Consolidate implementations of refcount_t

I suspect this is just bisecting to here because it made the refcount
checks more strict?

-Kees

>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117e9e91e000=
00
> start commit:   2c523b34 Linux 5.6-rc5
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=137e9e91e000=
00
> console output: https://syzkaller.appspot.com/x/log.txt?x=157e9e91e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=A5295e161cd85b82
> dashboard link: https://syzkaller.appspot.com/bug?extid=CEa71eec5d6de256d=
54d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164b5181e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166dd70de00000
>=20
> Reported-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Fixes: fb041bb7c0a9 ("locking/refcount: Consolidate implementations of re=
fcount_t")
>=20
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion

--=20
Kees Cook
