From: syzbot <syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com>
Date: Wed, 10 Apr 2019 11:33:00 +0000
Subject: Re: KASAN: use-after-free Read in __lock_sock
Message-Id: <000000000000940af705862b6e90@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <000000000000b98a67057ad7158a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, dvyukov@google.com, glider@google.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

syzbot has bisected this bug to:

commit 8f840e47f190cbe61a96945c13e9551048d42cef
Author: Xin Long <lucien.xin@gmail.com>
Date:   Thu Apr 14 07:35:33 2016 +0000

     sctp: add the sctp_diag.c file

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1719585b200000
start commit:   0072a0c1 Merge tag 'media/v4.20-4' of git://git.kernel.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1499585b200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1099585b200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=B9cc5a440391cbfd
dashboard link: https://syzkaller.appspot.com/bug?extid=9276d76e83e3bcde6c99
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b80cfb400000

Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
