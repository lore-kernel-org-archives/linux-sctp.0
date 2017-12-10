From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 10 Dec 2017 04:38:56 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (2)
Message-Id: <CADvbK_cAeiW-Tt0OnTBrzHObKOaNjRZnB1Uu+GSRJhhFpHTU2w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1149c712d56ccc055cc48e37@google.com> <001a1140f5788a1817055fcfcb1f@google.com>
 <CADvbK_c5Z7rE-AABGOFKXYA5v7_XLg=V1HOGzBO1X-O13aJ8Gg@mail.gmail.com> <CAM_iQpWffARgEqPTCnz=g0RDUUepJUQmfNF5A8DGa28sjcKo-w@mail.gmail.com>
In-Reply-To: <CAM_iQpWffARgEqPTCnz=g0RDUUepJUQmfNF5A8DGa28sjcKo-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: syzbot <bot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, kuznet <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, yoshfuji <yoshfuji@linux-ipv6.org>

On Sun, Dec 10, 2017 at 3:36 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Dec 8, 2017 at 12:45 AM, Xin Long <lucien.xin@gmail.com> wrote:
>> This isn't a sctp problem, but mld's, seems when lo's mtu became 0,
>> it allocs a skb without enough space in add_grec():
>
> Shouldn't we just set its min_mtu to ETH_MIN_MTU?
No idea why there's no min_mtu limitation for lo dev.
