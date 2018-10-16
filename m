From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 16 Oct 2018 11:28:17 +0000
Subject: Re: KASAN: use-after-free Read in sctp_id2assoc
Message-Id: <20181015112330.GA31030@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000007e767d05776336da@google.com>
 <20181005145855.GB6761@localhost.localdomain>
 <CACT4Y+YVRWSF+VyoBB1vwDevt0gwZYz69bSAivmZDG6r4J-kaA@mail.gmail.com>
 <20181010181325.GD6761@localhost.localdomain>
 <CACT4Y+YYpjjvW-UCkHEXWZA50F==7JC1cnMvoAZHKmOqq=9vAw@mail.gmail.com>
 <20181010184011.GE6761@localhost.localdomain>
In-Reply-To: <20181010184011.GE6761@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+c7dd55d7aec49d48e49a@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>

On Wed, Oct 10, 2018 at 03:40:11PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Oct 10, 2018 at 08:28:22PM +0200, Dmitry Vyukov wrote:
> > On Wed, Oct 10, 2018 at 8:13 PM, Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > > On Wed, Oct 10, 2018 at 05:28:12PM +0200, Dmitry Vyukov wrote:
> > >> On Fri, Oct 5, 2018 at 4:58 PM, Marcelo Ricardo Leitner
> > >> <marcelo.leitner@gmail.com> wrote:
> > >> > On Thu, Oct 04, 2018 at 01:48:03AM -0700, syzbot wrote:
> > >> >> Hello,
> > >> >>
> > >> >> syzbot found the following crash on:
> > >> >>
> > >> >> HEAD commit:    4e6d47206c32 tls: Add support for inplace records=
 encryption
> > >> >> git tree:       net-next
> > >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=13834b8=
1400000
> > >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=E569aa5=
632ebd436
> > >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=C7dd55d7a=
ec49d48e49a
> > >> >> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > >> >>
> > >> >> Unfortunately, I don't have any reproducer for this crash yet.
> > >> >>
> > >> >> IMPORTANT: if you fix the bug, please add the following tag to th=
e commit:
> > >> >> Reported-by: syzbot+c7dd55d7aec49d48e49a@syzkaller.appspotmail.com
> > >> >>
> > >> >> netlink: 'syz-executor1': attribute type 1 has an invalid length.
> > >> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >> >> BUG: KASAN: use-after-free in sctp_id2assoc+0x3a7/0x3e0
> > >> >> net/sctp/socket.c:276
> > >> >> Read of size 8 at addr ffff880195b3eb20 by task syz-executor2/154=
54
> > >> >>
> > >> >> CPU: 1 PID: 15454 Comm: syz-executor2 Not tainted 4.19.0-rc5+ #242
> > >> >> Hardware name: Google Google Compute Engine/Google Compute Engine=
, BIOS
> > >> >> Google 01/01/2011
> > >> >> Call Trace:
> > >> >>  __dump_stack lib/dump_stack.c:77 [inline]
> > >> >>  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
> > >> >>  print_address_description.cold.8+0x9/0x1ff mm/kasan/report.c:256
> > >> >>  kasan_report_error mm/kasan/report.c:354 [inline]
> > >> >>  kasan_report.cold.9+0x242/0x309 mm/kasan/report.c:412
> > >> >>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> > >> >>  sctp_id2assoc+0x3a7/0x3e0 net/sctp/socket.c:276
> > >> >
> > >> > I'm not seeing yet how this could happen.
> > >> > All sockopts here are serialized by sock_lock.
> > >> > do_peeloff here would create another socket, but the issue was
> > >> > triggered before that.
> > >> > The same function that freed this memory, also removes the entry f=
rom
> > >> > idr mapping, so this entry shouldn't be there anymore.
> > >> >
> > >> > I have only two theories so far:
> > >> > - an issue with IDR/RCU.
> > >> > - something else happened that just the call stacks are not reveal=
ing.
> > >>
> > >> The "asoc->base.sk !=3D sk" check after idr_find suggests that we do=
n't
> > >> actually know what sock it belongs to. And if we don't know then
> > >
> > > Right. The check is more because the IDR is global and not per socket
> > > (and we don't want sockets accessing asocs from other sockets), and n=
ot
> > > that the asoc may move to another socket in between, but it also
> > > protects from such cases, yes.
> > >
> > >> locking this sock can't help keeping another sock association alive.
> > >> Am I missing something obvious here? Should we take assoc ref while =
we
> > >
> > > Not sure. Maybe I am.  Thanks for looking into this, btw.
> > >
> > >> are still holding sctp_assocs_id_lock?
> > >
> > > Shouldn't be needed.
> > >
> > > Solely by the call stacks:
> > > - we tried to establish a new asoc from a sctp_connect() call,
> > >   blocking one.
> > > - it slept waiting for the connect
> > > - (something closed the asoc in between the sleeps, because it freed
> > >   the asoc right when waking up on sctp_wait_for_connect())
> > > - it freed the asoc after sleeping on it on sctp_wait_for_connect [A]
> > > - another thread tried to peeloff that asoc [B]
> > >
> > > For [B] to access the asoc in question, it had to take the same sock
> > > lock [A] had taken, and then the idr should not return an asoc in
> > > sctp_i2asoc(). Note that we can't peeloff an asoc twice, thus why
> > > the certainty here.
> > >
> > > If [B] actually kicked in before the sleep resumed, that should have
> > > been fine because it took the same sock lock [A] would have to
> > > re-take. In this case an asoc would have been returned by
> > > sctp_id2asoc(), the asoc would have been moved to a new socket, but
> > > all while holding the original socket sock lock.
> >=20
> > But why A and B use the same lock?
> >=20
> > sctp_assocs_id is global, so it contains asocs from all sockets, right?
> > assoc id comes straight from userspaces.
> > So isn't it possible that B uses completely different sock but passes
> > assoc id from the A sock? Then B should find assoc in sctp_assocs_id,
> > and at the point of "asoc->base.sk !=3D sk" check the assoc can be
> > already freed.
>=20
> That explains it. Somehow I was thinking the issue was for reading
> ->dead instead.  Now it's pretty clear. Then this should be the patch
> we want. Can you please give it a spin? (only compile tested)
>=20
> While holding the spinlock, an entry cannot be removed from the idr
> and thus it cannot be freed. So even if the app uses an id from
> another socket, it will still be there.
>=20
> ---8<---
>=20
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index f73e9d38d5ba..a7722f43aa69 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -271,11 +271,10 @@ struct sctp_association *sctp_id2assoc(struct sock =
*sk, sctp_assoc_t id)
> =20
>  	spin_lock_bh(&sctp_assocs_id_lock);
>  	asoc =3D (struct sctp_association *)idr_find(&sctp_assocs_id, (int)id);
> +	if (asoc && (asoc->base.sk !=3D sk || asoc->base.dead))
> +		asoc =3D NULL;
>  	spin_unlock_bh(&sctp_assocs_id_lock);
> =20
> -	if (!asoc || (asoc->base.sk !=3D sk) || asoc->base.dead)
> -		return NULL;
> -
>  	return asoc;
>  }
> =20
>=20
Marcello, can you post this with a proper changelog commit please?  Based o=
n the
bug report, and description of the problem, I think we can all agree this i=
s a
sane fix


Thanks
Neil
