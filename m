From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 01 Dec 2015 10:46:11 +0000
Subject: RE: [PATCH] sctp: use GFP_USER for user-controlled kmalloc
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1CBDF85D@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+a_V5WQZNEnYkuA3Xc5qCWmLV3oScNeNiATZm-wW5eg3Q@mail.gmail.comc>
 <db23659cdf84bc80aff45e906cbfb67581e7a125.1448901154.git.marcelo.leitner@gmail.com>
In-Reply-To: <db23659cdf84bc80aff45e906cbfb67581e7a125.1448901154.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>, "dvyukov@google.com" <dvyukov@google.com>, "kcc@google.com" <kcc@google.com>, "glider@google.com" <glider@google.com>, "sasha.levin@oracle.com" <sasha.levin@oracle.com>, "edumazet@google.com" <edumazet@google.com>

From: Marcelo Ricardo Leitner
> Sent: 30 November 2015 16:33
> Dmitry Vyukov reported that the user could trigger a kernel warning by
> using a large len value for getsockopt SCTP_GET_LOCAL_ADDRS, as that
> value directly affects the value used as a kmalloc() parameter.
> 
> This patch thus switches the allocation flags from all user-controllable
> kmalloc size to GFP_USER to put some more restrictions on it and also
> disables the warn, as they are not necessary.

ISTM that the code should put some 'sanity limit' on that
size before allocating the kernel buffer.

	David

