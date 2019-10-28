From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 28 Oct 2019 15:36:48 +0000
Subject: Re: KASAN: use-after-free Read in sctp_sock_dump
Message-Id: <20191028153648.GF4250@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000e68ee20595fa33be@google.com>
In-Reply-To: <000000000000e68ee20595fa33be@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+e5b57b8780297657b25b@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, roid@mellanox.com, saeedm@mellanox.com, syzkaller-bugs@googlegroups.com, vladbu@mellanox.com, vyasevich@gmail.com

On Mon, Oct 28, 2019 at 08:32:08AM -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    d6d5df1d Linux 5.4-rc5
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ef5a70e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x+cb64e504d04eff
> dashboard link: https://syzkaller.appspot.com/bug?extid=E5b57b8780297657b=
25b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cd8800e00000
>=20
> The bug was bisected to:
>=20
> commit 61086f391044fd587af9d70a9b8f6f800dd474ba
> Author: Vlad Buslov <vladbu@mellanox.com>
> Date:   Fri Aug 2 19:21:56 2019 +0000
>=20
>     net/mlx5e: Protect encap hash table with mutex
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135960af6000=
00

This is weird. This mlx5e commit has nothing to do with SCTP diag
dump.

  Marcelo
