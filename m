From: Alexander Potapenko <glider@google.com>
Date: Wed, 16 May 2018 09:42:32 +0000
Subject: Re: KMSAN: uninit-value in __sctp_v6_cmp_addr
Message-Id: <CAG_fn=V_sXGGYpi+DAqE3BUJBTWUc59vLeLQxUmBgsiMDjMUGw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000004f4075056c410b96@google.com>
In-Reply-To: <0000000000004f4075056c410b96@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot+85490c30c260afff22f2@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Networking <netdev@vger.kernel.org>, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>

#syz fix: sctp: handle two v4 addrs comparison in sctp_inet6_cmp_addr
