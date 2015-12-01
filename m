From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 01 Dec 2015 14:16:44 +0000
Subject: Re: memory leak in do_ipv6_setsockopt
Message-Id: <1448979404.25582.23.camel@edumazet-glaptop2.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+bv56b+opCd=5SHmN47MAHEFyZA18kSsu-Fa+XODj20PA@mail.gmail.com>
	 <1448977016.25582.18.camel@edumazet-glaptop2.roam.corp.google.com>
	 <565DA9BE.3060006@iogearbox.net>
In-Reply-To: <565DA9BE.3060006@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dmitry Vyukov <dvyukov@google.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>

On Tue, 2015-12-01 at 15:07 +0100, Daniel Borkmann wrote:

> Yeah, we miss inet6_destroy_sock() in SCTP. :-(
> 
> Looks good to me.

OK, I will send a formal (and tested ;) ) patch.

Thanks.


