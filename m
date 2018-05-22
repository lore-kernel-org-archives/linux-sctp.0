From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 22 May 2018 15:36:58 +0000
Subject: RE: [PATCH net-next] sctp: add support for SCTP_REUSE_PORT sockopt
Message-Id: <bfc973f868914c339caed34334f3e170@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <be8e672439406e6c8b838321d63aa109b9620f4c.1526715880.git.lucien.xin@gmail.com>
 <20180521005059.GA15233@neilslaptop.think-freely.org>
 <20180521015404.GI5488@localhost.localdomain>
 <20180521113939.GA17593@hmswarspite.think-freely.org>
 <4918BFA7-18F9-4125-A7F5-2A603C692A14@fh-muenster.de>
 <20180521134857.GC17593@hmswarspite.think-freely.org>
 <43A7D2C9-DFCE-4ADA-9ABB-B7ACD78C210B@fh-muenster.de>
 <20180521155127.GB5489@localhost.localdomain>
In-Reply-To: <20180521155127.GB5489@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Michael Tuexen <tuexen@fh-muenster.de>
Cc: Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

...
> > >> the reason this was added is to have a specified way to allow a system to
> > >> behave like a client and server making use of the INIT collision.
> > >>
> > >> For 1-to-many style sockets you can do this by creating a socket, binding it,
> > >> calling listen on it and trying to connect to the peer.
> > >>
> > >> For 1-to-1 style sockets you need two sockets for it. One listener and one
> > >> you use to connect (and close it in case of failure, open a new one...).
> > >>
> > >> It was not clear if one can achieve this with SO_REUSEPORT and/or SO_REUSEADDR
> > >> on all platforms. We left that unspecified.
> > >>
> > >> I hope this makes the intention clearer.

That really doesn't help for 1-1 sockets.
You need a way of accepting connections that come from a specific remote host.

Otherwise the application has to verify that the remove address on the incoming
connection is the one it is expecting.

It is also a problem if two different applications (instances) want to
generate 'INIT collisions' for the same local addresses but different remote
ones.

The only way 'INIT collisions' are going to work is with a different
option that stops the receipt of an ABORT chunk erroring a connect.

	David

