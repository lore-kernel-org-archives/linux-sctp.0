From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 11 May 2020 18:31:27 +0000
Subject: Re: WARNING in cgroup_finalize_control
Message-Id: <20200511183127.GI2688@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000e79ab005a56292f5@google.com>
In-Reply-To: <000000000000e79ab005a56292f5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com>
Cc: andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, christian@brauner.io, coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net, hannes@cmpxchg.org, john.fastabend@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu, kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lizefan@huawei.com, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, nhorman@tuxdriver.com, pablo@netfilter.org, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, tj@kernel.org, vyasevich@gmail.com, yhs@fb.com

On Mon, May 11, 2020 at 10:21:13AM -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    a811c1fa Merge git://git.kernel.org/pub/scm/linux/kernel/=
g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16ad1d70100000
> kernel config:  https://syzkaller.appspot.com/x/.config?xCbadbd0e7e1137e
> dashboard link: https://syzkaller.appspot.com/bug?extid=9C08aaa363ca5784c=
9e9
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-projec=
t/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d3c588100000
>=20
> The bug was bisected to:
>=20
> commit eab59075d3cd7f3535aa2dbbc19a198dfee58892
> Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date:   Wed Dec 28 11:26:31 2016 +0000
>=20
>     sctp: reduce indent level at sctp_sf_tabort_8_4_8

The reproducer is not touching any sctp code and the commit above
didn't have any functional change. Not sure how the bisect ended up on
it, but this isn't triggered by sctp.
