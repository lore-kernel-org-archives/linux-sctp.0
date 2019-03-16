From: syzbot <syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com>
Date: Sat, 16 Mar 2019 14:09:00 +0000
Subject: Re: general protection fault in sctp_assoc_rwnd_increase
Message-Id: <000000000000757009058436b23f@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <00000000000089bb100583e5fe7a@google.com>
References: <00000000000089bb100583e5fe7a@google.com>
In-Reply-To: <00000000000089bb100583e5fe7a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, dvyukov@google.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

syzbot has bisected this bug to:

commit 89664c623617b1d34447a927ac7871ddf3db29d3
Author: Xin Long <lucien.xin@gmail.com>
Date:   Sun Mar 3 09:54:53 2019 +0000

     sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b17777200000
start commit:   89664c62 sctp: sctp_sock_migrate() returns error if sctp_b..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14717777200000
console output: https://syzkaller.appspot.com/x/log.txt?x=10717777200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=B613f0327d980b6b
dashboard link: https://syzkaller.appspot.com/bug?extid=85e0b422ff140b03672a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12613b13200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f1884d200000

Reported-by: syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com
Fixes: 89664c62 ("sctp: sctp_sock_migrate() returns error if =20
sctp_bind_addr_dup() fails")
