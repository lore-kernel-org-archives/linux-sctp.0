From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Wed, 27 May 2015 17:04:40 +0000
Subject: Re: [PATCH] sctp: Fix mangled IPv4 addresses on a IPv6 listening socket
Message-Id: <20150527170440.GA15308@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20150526233017.GB22391@obsidianresearch.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CB408FE@AcuExch.aculab.com>
 <55658F9D.6030404@iogearbox.net>
 <063D6719AE5E284EB5DD2968C1650D6D1CB409AD@AcuExch.aculab.com>
 <20150527153226.GA9909@obsidianresearch.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CB40D32@AcuExch.aculab.com>
 <20150527163157.GA15041@obsidianresearch.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CB40E15@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CB40E15@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Daniel Borkmann' <daniel@iogearbox.net>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Wed, May 27, 2015 at 04:41:18PM +0000, David Laight wrote:

> The code will be sleeping in kernel_accept() and later calls
> kernel_getpeername().
> The code is used for both TCP and SCTP and this part is common (using
> the TCP semantics).

getpeername uses a different flow, it calls into inet6_getname which
will always return the AF_INET6 version.

The call to sctp_v6_addr_to_user after is to support the v6->v4 coversion
when SCTP_I_WANT_MAPPED_V4_ADDR=0, it will never do the broken v4->v6
conversion.

Jason
