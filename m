From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 03 Dec 2019 11:56:16 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
Message-Id: <20191203115616.GA4707@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a114372a6074e6505642b7f72@google.com>
 <000000000000039751059891760e@google.com>
 <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com>
 <20191202183912.GC377783@localhost.localdomain>
 <CACT4Y+ZpZVYgA-oiE_YYC49LRA2=iTQLxOaKTA3TEYBt8KjFbw@mail.gmail.com>
In-Reply-To: <CACT4Y+ZpZVYgA-oiE_YYC49LRA2=iTQLxOaKTA3TEYBt8KjFbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, mvohra@vmware.com, netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, William Tu <u9012063@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, websitedesignservices4u@gmail.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>

On Tue, Dec 03, 2019 at 09:42:14AM +0100, Dmitry Vyukov wrote:
> On Mon, Dec 2, 2019 at 7:39 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Sat, Nov 30, 2019 at 04:37:56PM +0100, Dmitry Vyukov wrote:
> > > On Sat, Nov 30, 2019 at 3:50 PM syzbot
> > > <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com> wrote:
> > > >
> > > > syzbot has bisected this bug to:
> > > >
> > > > commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
> > > > Author: William Tu <u9012063@gmail.com>
> > > > Date:   Tue Aug 22 16:40:28 2017 +0000
> > > >
> > > >      gre: introduce native tunnel support for ERSPAN
> > > >
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158a2f=
86e00000
> > > > start commit:   f9f1e414 Merge tag 'for-linus-4.16-rc1-tag' of git:=
//git.k..
> > > > git tree:       upstream
> > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=178a2f=
86e00000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=138a2f86e=
00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x4a80ee1ac2=
9767b
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=B2bf2652983=
d23734c5c
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147bfeb=
d800000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d8d5438=
00000
> > > >
> > > > Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
> > > > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSP=
AN")
> > > >
> > > > For information about bisection process see: https://goo.gl/tpsmEJ#=
bisection
> > >
> > > Humm... the repro contains syz_emit_ethernet, wonder if it's
> > > remote-triggerable...
> >
> > The call trace is still from the tx path. Packet never left the system
> > in this case.
>=20
> My understanding is that this does not necessarily mean that the
> remote side is not involved. There is enough state on the host for L4
> protocols, so that the remote side can mess things and then the bad
> thing will happen with local trigger. But that local trigger can be
> just anything trivial that everybody does.
>=20
But thats not really helpful.  Unless you see an explicit path from the rec=
eive
side to ip6_append_data, Theres no real way for a received packet to reach =
this
code, so we can't really call it remotely triggerable.

My guess is, since this is coming from the rawv6_sendmsg path, that the raw
protocol is somehow not marshaling its data in a way that ip6_append_data
expects.

Neil
