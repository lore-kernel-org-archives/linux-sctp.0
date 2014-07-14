From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 14 Jul 2014 09:12:33 +0000
Subject: RE: [PATCH v2 net-next 1/3] net: sctp: Open out the check for Nagle
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D172719BD@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1726EEB9@AcuExch.aculab.com>
 <53C04280.8020809@gmail.com>
In-Reply-To: <53C04280.8020809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Cc: "'davem@davemloft.net'" <davem@davemloft.net>

From: Vlad Yasevich
...
> > +	if (inflight != 0)
> > +		/* Nothing unacked */
> > +		return SCTP_XMIT_OK;
> 
> This doesn't look right.  First, the comment doesn't match the condition.
> Second, when we have stuff in-flight we might be affected be Nagle.  Thus,
> I think the condition should be:
>        if (!inflight)
> 
> Then the commend and logic holds.

Gah, I accidentally inverted the condition :-(
I changed it to a an explicit comparison because 'inflight' is actually
the number of bytes that are unacked.

I'll repost the series later in the week.

	David



