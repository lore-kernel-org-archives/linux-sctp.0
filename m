From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 03 Dec 2019 08:42:14 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
Message-Id: <CACT4Y+ZpZVYgA-oiE_YYC49LRA2=iTQLxOaKTA3TEYBt8KjFbw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a114372a6074e6505642b7f72@google.com> <000000000000039751059891760e@google.com>
 <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com> <20191202183912.GC377783@localhost.localdomain>
In-Reply-To: <20191202183912.GC377783@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, mvohra@vmware.com, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, William Tu <u9012063@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, websitedesignservices4u@gmail.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>

On Mon, Dec 2, 2019 at 7:39 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sat, Nov 30, 2019 at 04:37:56PM +0100, Dmitry Vyukov wrote:
> > On Sat, Nov 30, 2019 at 3:50 PM syzbot
> > <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has bisected this bug to:
> > >
> > > commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
> > > Author: William Tu <u9012063@gmail.com>
> > > Date:   Tue Aug 22 16:40:28 2017 +0000
> > >
> > >      gre: introduce native tunnel support for ERSPAN
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158a2f86=
e00000
> > > start commit:   f9f1e414 Merge tag 'for-linus-4.16-rc1-tag' of git://=
git.k..
> > > git tree:       upstream
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=178a2f86=
e00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=138a2f86e00=
000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x4a80ee1ac297=
67b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=B2bf2652983d2=
3734c5c
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147bfebd8=
00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d8d543800=
000
> > >
> > > Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
> > > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN=
")
> > >
> > > For information about bisection process see: https://goo.gl/tpsmEJ#bi=
section
> >
> > Humm... the repro contains syz_emit_ethernet, wonder if it's
> > remote-triggerable...
>
> The call trace is still from the tx path. Packet never left the system
> in this case.

My understanding is that this does not necessarily mean that the
remote side is not involved. There is enough state on the host for L4
protocols, so that the remote side can mess things and then the bad
thing will happen with local trigger. But that local trigger can be
just anything trivial that everybody does.
