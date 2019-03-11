From: syzbot <syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com>
Date: Mon, 11 Mar 2019 13:19:00 +0000
Subject: Re: general protection fault in sctp_sched_rr_dequeue
Message-Id: <0000000000006f91c90583d16a9d@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <000000000000cc734405836318dc@google.com>
References: <000000000000cc734405836318dc@google.com>
In-Reply-To: <000000000000cc734405836318dc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

syzbot has bisected this bug to:

commit 7efba10d6bd22030fb5931e50bf97496f932f00e
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jan 28 07:08:46 2019 +0000

     sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC for =20
SCTP_STREAM_SCHEDULER sockopt

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14eec757200000
start commit:   7efba10d sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16eec757200000
console output: https://syzkaller.appspot.com/x/log.txt?x=12eec757200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=872be05707464aaa
dashboard link: https://syzkaller.appspot.com/bug?extidL9934f20522c0efd657
userspace arch: amd64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cd9b03200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127de8e7200000

Reported-by: syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com
Fixes: 7efba10d ("sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC for =20
SCTP_STREAM_SCHEDULER sockopt")
