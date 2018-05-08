From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 08 May 2018 12:06:43 +0000
Subject: Re: INFO: rcu detected stall in sctp_generate_heartbeat_event
Message-Id: <20180508120643.GM4977@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000062c1c056bacd39f@google.com>
In-Reply-To: <000000000000062c1c056bacd39f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+e4a5bbd54260c93014f9@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Tue, May 08, 2018 at 12:35:02AM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    90278871d4b0 Merge git://git.kernel.org/pub/scm/linux/ker=
n..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=119a7237800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=AEa320d3af5ef99d
> dashboard link: https://syzkaller.appspot.com/bug?extid=E4a5bbd54260c9301=
4f9
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.

A reproducer will be welcomed. With just these traces, I don't think
we have enough information.

  Marcelo
