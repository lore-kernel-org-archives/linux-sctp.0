From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 28 May 2015 08:58:35 +0000
Subject: RE: [PATCH] sctp: Fix mangled IPv4 addresses on a IPv6 listening socket
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1CB4177C@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20150526233017.GB22391@obsidianresearch.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CB408FE@AcuExch.aculab.com>
 <55658F9D.6030404@iogearbox.net>
 <063D6719AE5E284EB5DD2968C1650D6D1CB409AD@AcuExch.aculab.com>
 <20150527153226.GA9909@obsidianresearch.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CB40D32@AcuExch.aculab.com>
 <20150527163157.GA15041@obsidianresearch.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CB40E15@AcuExch.aculab.com>
 <20150527170440.GA15308@obsidianresearch.com>
In-Reply-To: <20150527170440.GA15308@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>
Cc: 'Daniel Borkmann' <daniel@iogearbox.net>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: Jason Gunthorpe
> Sent: 27 May 2015 18:05
> On Wed, May 27, 2015 at 04:41:18PM +0000, David Laight wrote:
> 
> > The code will be sleeping in kernel_accept() and later calls
> > kernel_getpeername().
> > The code is used for both TCP and SCTP and this part is common (using
> > the TCP semantics).
> 
> getpeername uses a different flow, it calls into inet6_getname which
> will always return the AF_INET6 version.

Ok, that explains why I hadn't seen the problem.
It also means I don't have to worry about it.

	David

