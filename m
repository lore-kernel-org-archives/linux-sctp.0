From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 02 Dec 2019 18:39:12 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
Message-Id: <20191202183912.GC377783@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a114372a6074e6505642b7f72@google.com>
 <000000000000039751059891760e@google.com>
 <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com>
In-Reply-To: <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, mvohra@vmware.com, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, William Tu <u9012063@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, websitedesignservices4u@gmail.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>

On Sat, Nov 30, 2019 at 04:37:56PM +0100, Dmitry Vyukov wrote:
> On Sat, Nov 30, 2019 at 3:50 PM syzbot
> <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this bug to:
> >
> > commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
> > Author: William Tu <u9012063@gmail.com>
> > Date:   Tue Aug 22 16:40:28 2017 +0000
> >
> >      gre: introduce native tunnel support for ERSPAN
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158a2f86e0=
0000
> > start commit:   f9f1e414 Merge tag 'for-linus-4.16-rc1-tag' of git://gi=
t.k..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=178a2f86e0=
0000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=138a2f86e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x4a80ee1ac29767b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=B2bf2652983d237=
34c5c
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147bfebd800=
000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d8d543800000
> >
> > Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
> > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bise=
ction
>=20
> Humm... the repro contains syz_emit_ethernet, wonder if it's
> remote-triggerable...

The call trace is still from the tx path. Packet never left the system
in this case.
