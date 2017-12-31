From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun, 31 Dec 2017 09:17:32 +0000
Subject: Re: general protection fault in skb_segment
Message-Id: <CAF=yD-LRz1pWKRhtbOSbBwa7ZMVLPoDtkKRXumzT4xEK3fUh3g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1137452496ffc305617e5fe0@google.com> <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
 <20171231005220.GD22042@localhost.localdomain> <20171231022524.GE22042@localhost.localdomain>
 <CADvbK_d0_486KX-wtfQa=0aVGv0mtaFs4JeMTbv6n+aMWqU3hg@mail.gmail.com>
In-Reply-To: <CADvbK_d0_486KX-wtfQa=0aVGv0mtaFs4JeMTbv6n+aMWqU3hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzbot <syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

>> and with the reproducer, got:
>> [   54.255469] Bogus gso_type: 7
>> [   54.258801] Bogus gso_size: 63464
>> [   54.262532] ------------[ cut here ]------------
>> [   54.267703] syz0: caps=(0x00000800000058c1, 0x0000000000000000) len2 data_len=0 gso_sizec464 gso_type=7 ip_summed0
>> [   54.279777] WARNING: CPU: 1 PID: 13005 at /root/linux/net/core/dev.c:2600 skb_warn_bad_offload+0xd6/0xec
> I couldn't reproduce this call trace on net-next, maybe it's been fixed by:
> commit 8d74e9f88d65af8bb2e095aff506aa6eac755ada
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Tue Dec 12 11:39:04 2017 -0500
>
>     net: avoid skb_warn_bad_offload on IS_ERR

Yes, I forgot to mention that that has been fixed in net-next.

It does not address the crash, but does suppress the gratuitous
warning once we make segmentation return with error for bad
packets like these.
