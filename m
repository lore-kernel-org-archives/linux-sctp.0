From: syzbot <syzbot+3950016bd95c2ca0377b@syzkaller.appspotmail.com>
Date: Fri, 20 Mar 2020 00:48:02 +0000
Subject: Re: general protection fault in sctp_ulpevent_nofity_peer_addr_change
Message-Id: <00000000000041ca9305a13ea3e0@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <00000000000074219d05a139e082@google.com>
References: <00000000000074219d05a139e082@google.com>
In-Reply-To: <00000000000074219d05a139e082@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, b.zolnierkie@samsung.com, davem@davemloft.net, dri-devel@lists.freedesktop.org, kuba@kernel.org, linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lkundrak@v3.sk, marcelo.leitner@gmail.com, mareklindner@neomailbox.ch, netdev@vger.kernel.org, nhorman@tuxdriver.com, sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

syzbot has bisected this bug to:

commit da2648390ce3d409218b6bbbf2386d8ddeec2265
Author: Lubomir Rintel <lkundrak@v3.sk>
Date:   Thu Dec 20 18:13:09 2018 +0000

    pxa168fb: trivial typo fix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1361e139e00000
start commit:   5076190d mm: slub: be more careful about the double cmpxch..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10e1e139e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1761e139e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9F894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid950016bd95c2ca0377b
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1162bbe3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c93b45e00000

Reported-by: syzbot+3950016bd95c2ca0377b@syzkaller.appspotmail.com
Fixes: da2648390ce3 ("pxa168fb: trivial typo fix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
