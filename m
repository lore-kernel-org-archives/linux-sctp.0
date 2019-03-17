From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 17 Mar 2019 13:17:56 +0000
Subject: Re: general protection fault in sctp_assoc_rwnd_increase
Message-Id: <CADvbK_fjUBj1PYRshztyUxmiN2b27AFGJHHOgGDpggaQqtVBUA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000089bb100583e5fe7a@google.com> <000000000000757009058436b23f@google.com>
In-Reply-To: <000000000000757009058436b23f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Sat, Mar 16, 2019 at 10:09 PM syzbot
<syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 89664c623617b1d34447a927ac7871ddf3db29d3
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Sun Mar 3 09:54:53 2019 +0000
>
>      sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b177772000=
00
> start commit:   89664c62 sctp: sctp_sock_migrate() returns error if sctp_=
b..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=147177772000=
00
> console output: https://syzkaller.appspot.com/x/log.txt?x=10717777200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=B613f0327d980b6b
> dashboard link: https://syzkaller.appspot.com/bug?extid=85e0b422ff140b036=
72a
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12613b13200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f1884d200000
>
> Reported-by: syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com
> Fixes: 89664c62 ("sctp: sctp_sock_migrate() returns error if
> sctp_bind_addr_dup() fails")

sctp_copy_descendant() coplied sctp_sock->pd_lobby. we should fix it with:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 06c6f4a..e0857dd 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9175,7 +9175,7 @@ static inline void sctp_copy_descendant(struct
sock *sk_to,
 {
  int ancestor_size =3D sizeof(struct inet_sock) +
      sizeof(struct sctp_sock) -
-     offsetof(struct sctp_sock, auto_asconf_list);
+     offsetof(struct sctp_sock, pd_lobby);

  if (sk_from->sk_family =3D PF_INET6)
  ancestor_size +=3D sizeof(struct ipv6_pinfo);
