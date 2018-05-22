From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 22 May 2018 00:43:20 +0000
Subject: Re: INFO: rcu detected stall in is_bpf_text_address
Message-Id: <20180522004320.GI26212@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000006d7517056c911740@google.com>
 <4b65142a-cf3b-05d7-d66b-018ff8da7ccc@gmail.com>
 <CADvbK_e7LXc7minSmaPw6iZvjWo215wG-pPAS0gr58+-VxUO7Q@mail.gmail.com>
In-Reply-To: <CADvbK_e7LXc7minSmaPw6iZvjWo215wG-pPAS0gr58+-VxUO7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, syzbot <syzbot+3dcd59a1f907245f891f@syzkaller.appspotmail.com>, ast@kernel.org, Daniel Borkmann <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>, network dev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, linux-sctp@vger.kernel.org

On Sun, May 20, 2018 at 04:26:03PM +0800, Xin Long wrote:
> On Sat, May 19, 2018 at 11:57 PM, Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> > SCTP experts, please take a look.
> >
> > On 05/19/2018 08:55 AM, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following crash on:
> >>
> >> HEAD commit:    73fcb1a370c7 Merge branch 'akpm' (patches from Andrew)
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=1462ec0f8000=
00
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=F3b4e30da84e=
c1ed
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dcd59a1f90724=
5f891f
> >> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=1079cf8f80=
0000
> Thank you.
> The Reproducer is more than helpful.
>=20
> setsockopt$inet_sctp6_SCTP_RTOINFO(r0, 0x84, 0x0,
> &(0x7f0000000140)=3D{0x0, 0x6, 0x7, 0x4}, 0x10)
>=20
> It set rto_min=3D6 and rto_max=3D7, these are too small values.
> t3_rtx timer works fine with it. But hb_timer will get stuck there, as
> in its timer handler it starts this timer again with this value, then
> it goes to the timer handler again...

Nice, thanks Xin.

>=20
> HB has to repeat this and the hb timer's expire may also have to use
> 'trans->rto >> 1 ...' stuff. But we can limit the RTO's min value, like
> HZ/20, which is 'Try again later.' number used when sock lock is
> owned by others in all timer handlers.

I think a good fix for this is to not allow the application to go
below net.sctp.rto_min, and neither above net.sctp.rto_max.

Then they can even be close to each other, won't be an issue, as long
as rto_min is something sensible. Which then brings it to the second
step of a fix: to restrict rto_min to be >=3D HZ/5 (copying from TCP
here).

