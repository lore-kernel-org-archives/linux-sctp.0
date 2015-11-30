From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 30 Nov 2015 16:36:37 +0000
Subject: Re: user-controllable kmalloc size in sctp_getsockopt_local_addrs
Message-Id: <20151130163637.GA6091@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+a_V5WQZNEnYkuA3Xc5qCWmLV3oScNeNiATZm-wW5eg3Q@mail.gmail.com>
In-Reply-To: <CACT4Y+a_V5WQZNEnYkuA3Xc5qCWmLV3oScNeNiATZm-wW5eg3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>

On Sat, Nov 28, 2015 at 01:40:08PM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> The following program triggers WARNING in kmalloc:
> 

I messed up with the in-reply-to, put an extra c on it, but I just
posted a patch for this, subject:
[PATCH] sctp: use GFP_USER for user-controlled kmalloc

Thanks,
Marcelo

