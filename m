From: syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>
Date: Sat, 30 Nov 2019 14:50:01 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
Message-Id: <000000000000039751059891760e@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <001a114372a6074e6505642b7f72@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, dvyukov@google.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, mvohra@vmware.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, u9012063@gmail.com, vyasevich@gmail.com, websitedesignservices4u@gmail.com, yoshfuji@linux-ipv6.org

syzbot has bisected this bug to:

commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
Author: William Tu <u9012063@gmail.com>
Date:   Tue Aug 22 16:40:28 2017 +0000

     gre: introduce native tunnel support for ERSPAN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158a2f86e00000
start commit:   f9f1e414 Merge tag 'for-linus-4.16-rc1-tag' of git://git.k..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=178a2f86e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=138a2f86e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x4a80ee1ac29767b
dashboard link: https://syzkaller.appspot.com/bug?extid=B2bf2652983d23734c5c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147bfebd800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d8d543800000

Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
