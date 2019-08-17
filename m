From: syzbot <syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com>
Date: Sat, 17 Aug 2019 15:28:00 +0000
Subject: Re: kernel BUG at include/linux/skbuff.h:LINE! (2)
Message-Id: <000000000000860647059051c0b8@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <0000000000008182a50590404a02@google.com>
References: <0000000000008182a50590404a02@google.com>
In-Reply-To: <0000000000008182a50590404a02@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: andriy.shevchenko@linux.intel.com, davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com, idosch@mellanox.com, kimbrownkd@gmail.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, vyasevich@gmail.com, wanghai26@huawei.com, yuehaibing@huawei.com

syzbot has bisected this bug to:

commit bc389fd101e57b36aacfaec2df8fe479eabb44ea
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jul 2 21:12:30 2019 +0000

     Merge branch 'macsec-fix-some-bugs-in-the-receive-path'

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=125c5c4c600000
start commit:   459c5fb4 Merge branch 'mscc-PTP-support'
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=115c5c4c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=165c5c4c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=D4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=EB349eeee854e389c36d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111849e2600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1442c25a600000

Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
Fixes: bc389fd101e5 ("Merge =20
branch 'macsec-fix-some-bugs-in-the-receive-path'")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
