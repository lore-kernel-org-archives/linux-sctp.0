From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 22 Jul 2020 19:02:50 +0000
Subject: Re: KASAN: slab-out-of-bounds Write in sctp_setsockopt
Message-Id: <20200722190250.GE3307@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000003b813605ab0bd243@google.com>
In-Reply-To: <0000000000003b813605ab0bd243@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com, hch@lst.de

On Wed, Jul 22, 2020 at 11:22:23AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4f1b4da5 Merge branch 'net-atlantic-various-features'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?xb3a040900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x+7b67c0c1819c87
> dashboard link: https://syzkaller.appspot.com/bug?extid4699d000d8b874d8dc
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?xc93358900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?xab61f0900000

The syz repo has:
setsockopt$inet_sctp6_SCTP_MAX_BURST(r0, 0x84, 0x10, &(0x7f0000000100)=@assoc_value, 0x8)
                      ^^^^^^^^^^^^^^           ^^^^

#define SCTP_DELAYED_ACK_TIME   16
#define SCTP_DELAYED_ACK SCTP_DELAYED_ACK_TIME
#define SCTP_DELAYED_SACK SCTP_DELAYED_ACK_TIME
#define SCTP_MAX_BURST  20              /* Set/Get max burst */

C repro has:
  syscall(__NR_setsockopt, r[0], 0x84, 0x10, 0x20000100ul, 8ul);
                                       ^^^^

So I'm wondering, what was the real intention of the call?


Anyhow, the issue is real, introduced by ebb25defdc17 ("sctp: pass a
kernel pointer to sctp_setsockopt_delayed_ack"). It used to use a
local storage bigger than the data provided by the user and used
one struct to read another's content on top of it. Quite masked.
I'll cook a fix.

  Marcelo
