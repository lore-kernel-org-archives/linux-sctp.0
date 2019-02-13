From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Wed, 13 Feb 2019 17:23:39 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190213172339.GJ13621@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <20190209.151217.175627323493244750.davem@davemloft.net>
 <20190210124616.GG13621@localhost.localdomain>
 <20190210201559.GE10665@localhost.localdomain>
 <71e3d64ae3d44e499f3fb9f876398ee4@AcuMS.aculab.com>
In-Reply-To: <71e3d64ae3d44e499f3fb9f876398ee4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: David Miller <davem@davemloft.net>, "julien@arista.com" <julien@arista.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>

On Wed, Feb 13, 2019 at 04:17:41PM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 10 February 2019 20:16
> ...
> > We have issues on read path too. 52ccb8e90c0a ("[SCTP]: Update
> > SCTP_PEER_ADDR_PARAMS socket option to the latest api draft.")
> > extended struct sctp_paddrparams and its getsockopt goes with:
> 
> The API shouldn't change like this at all.
> Is this from the RFC or elsewhere??

I would think so. That commit is from 2005, pretty close to initial
SCTP RFCs.

> 
> If the structure changes the socket option name and value
> should also change.

That's what is at the core of this thread.

  Marcelo

> 
> IMHO large chunks of the sctp rfc are just horrid.
> In particular all the places where is states that API functions are
> implemented using setsockopt() - that should be an implementation detail.
> Also ISTR that some of the structures are defined to have holes in them...
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
