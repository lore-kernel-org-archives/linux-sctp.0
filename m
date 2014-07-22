From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 22 Jul 2014 16:46:33 +0000
Subject: RE: [PATCH net-next v3 3/3] net: sctp: Add support for MSG_MORE on SCTP
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1727B4AA@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1727AF02@AcuExch.aculab.com>
 <53CE65B5.3090903@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1727B2A0@AcuExch.aculab.com>
 <53CE7B2A.90104@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1727B3E7@AcuExch.aculab.com>
 <53CE9379.4030500@gmail.com>
In-Reply-To: <53CE9379.4030500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, Linux Networking Development Mailing List <netdev@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>

From: Vlad Yasevich ...
> > I'm not sure what would be needed to be done to cause queued send data to be
> > sent when SCTP_F_TX_MSG_MORE is cleared by close() or set/clear SCTP_NODELAY.
> > It is probably a simple call to the correct function.
> 
> OK. I'll try to come up with some code for this.

Thanks.

	David



