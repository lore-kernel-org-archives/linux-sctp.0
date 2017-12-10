From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 10 Dec 2017 04:51:10 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (2)
Message-Id: <1512881470.25033.38.camel@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1149c712d56ccc055cc48e37@google.com>
         <001a1140f5788a1817055fcfcb1f@google.com>
         <CADvbK_c5Z7rE-AABGOFKXYA5v7_XLg=V1HOGzBO1X-O13aJ8Gg@mail.gmail.com>
         <CADvbK_cnxEgU--FO+ATGL+fe2z59XVzRGzKxp1-vZxL8x8LmKA@mail.gmail.com>
         <1512838770.25033.33.camel@gmail.com>
         <CADvbK_dMfCf82LYZWeWp1EOzStwuTyjP7SzbUwa0vnT5sc38Qw@mail.gmail.com>
In-Reply-To: <CADvbK_dMfCf82LYZWeWp1EOzStwuTyjP7SzbUwa0vnT5sc38Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <bot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, kuznet <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, yoshfuji <yoshfuji@linux-ipv6.org>

On Sun, 2017-12-10 at 12:36 +0800, Xin Long wrote:
> The new patch works to me, just two questions:
> 1. should it use "idev->cnf.mtu6" here for mld ?

No idea why some parts of IPv6 would use a different view of device
mtu. Maybe others can comment.

> 
> 2.  'if (int < unsigned int)' is still not nice, though in 'if
> (AVAILABLE(skb) < sizeof())'
>      AVAILABLE(skb) seems always to return >= 0 after your patch.

Really if AVAILABLE(skb) was negative, a bug already happened.

