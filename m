From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Dec 2019 15:28:10 +0000
Subject: Re: general protection fault in sctp_stream_free (2)
Message-Id: <20191220152810.GI4444@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000001b6443059a1a815d@google.com>
In-Reply-To: <0000000000001b6443059a1a815d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Thu, Dec 19, 2019 at 07:45:09PM -0800, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    6fa9a115 Merge branch 'stmmac-fixes'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c4fe99e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x!6dca5e1758db87
> dashboard link: https://syzkaller.appspot.com/bug?extid=9A1bc632e78a1a984=
88b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178ada71e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f23a6e00000
>=20
> The bug was bisected to:
>=20
> commit 951c6db954a1adefab492f6da805decacabbd1a7
> Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date:   Tue Dec 17 01:01:16 2019 +0000
>=20
>     sctp: fix memleak on err handling of stream initialization

Ouch... this wasn't a good fix.
When called from sctp_stream_init(), it is doing the right thing.
But when called from sctp_send_add_streams(), it can't free the
genradix. Ditto from sctp_process_strreset_addstrm_in().
