From: David Miller <davem@davemloft.net>
Date: Mon, 23 Jan 2017 16:17:48 +0000
Subject: Re: [PATCHv3 net-next 3/4] sctp: add support for generating stream reconf add incoming/outgoing stre
Message-Id: <20170123.111748.1837314786827029115.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170123123628.GX3781@localhost.localdomain>
        <20170123.110047.447365739282173577.davem@davemloft.net>
        <20170123161458.GZ3781@localhost.localdomain>
In-Reply-To: <20170123161458.GZ3781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: David.Laight@ACULAB.COM, lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: marcelo.leitner@gmail.com
Date: Mon, 23 Jan 2017 14:14:58 -0200

> On Mon, Jan 23, 2017 at 11:00:47AM -0500, David Miller wrote:
>> I will not accept __packed being used unless it is absolutely, provably,
>> the only way to solve a particular problem.  And when that does happen,
>> I am going to require a huge comment explaining in detail why this is
>> the case, and why no other approach or solution solved the problem.
> 
> Would this be a candidate for checkpatch.pl?

If this helps developers, sure.
