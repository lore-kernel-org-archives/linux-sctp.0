From: David Miller <davem@davemloft.net>
Date: Wed, 30 Dec 2015 20:40:14 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <20151230.154014.1155079588447705262.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
	<20151230.125204.1385006803109278855.davem@davemloft.net>
	<1451502223.8255.45.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1451502223.8255.45.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eric.dumazet@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 14:03:43 -0500

> You sure can disagree with me, but calling my opinion 'incredily
> stupid' is not wise.

I think fundamentally giving facilities less rather than more coverage
is not a smart approach at all.

If the code is that bad that people are discouraged from even using
it, then it should be moved to drivers/staging or removed.  Otherwise
it must work and we must be able to make use of it.

> I understand we would love to do that, but what is the hurry for
> SCTP, that needed rhashtable so desperately that it could not be
> done before 2016 ?

There is no rush, but quite frankly finding people to do serious
work on SCTP is no easy task so I'm hesitant to "defer" someone's
work in this area... :-)
