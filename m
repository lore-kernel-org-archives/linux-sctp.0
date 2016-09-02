From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 02 Sep 2016 14:25:42 +0000
Subject: RE: [PATCH net 2/2] sctp: not copying duplicate addrs to the assoc's bind address list
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DB00F04FB@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1471605833.git.lucien.xin@gmail.com>
 <130956b1e880eab780162a795fde156d61d4de0f.1471605833.git.lucien.xin@gmail.com>
 <20160819175007.GB3578@hmsreliant.think-freely.org>
 <CADvbK_do3kQSotq7-PbvoCBBSwOBBdZtx=rR+Q2XX3_bhV4_0w@mail.gmail.com>
 <20160822142538.GA10323@hmsreliant.think-freely.org>
 <20160824112338.GB11144@localhost.localdomain>
 <CADvbK_dJbaze7qMsDp-7x0xANsXZX=JfYBNhKOo=2VgbM_ywZg@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB00EF186@AcuExch.aculab.com>
 <20160902134657.GB11159@localhost.localdomain>
In-Reply-To: <20160902134657.GB11159@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: 'Xin Long' <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, davem <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>

From: Marcelo Ricardo Leitner
> Sent: 02 September 2016 14:47
...
> > Consider the following network:
> >
> >     ----+---------------+----------------------+---------
> >         |               |                      |
> >      x.x.1.1         x.x.1.2                y.y.1.2
> >     10.1.1.1        10.1.1.2               10.1.1.2
> >         |               |                      |
> >     ----+---------------+                      +---------
...
> > I'm not at sure whether it is possible to setup listener(s) on x.x.1.1
> > that can accept connections from both x.x.1.2 and y.y.1.2.
> 
> You mean without an explicit bind()?

You might be able to bind one socket to x.x.1.1 and a second to 10.1.1.1
and x.x.1.1 so that connections to x.x.1.1 are only offered x.x.1.1 and
those to 10.1.1.1 are offered both addresses.

But you can't make the init-ack responses for connections to x.x.1.1
depend on whether the connect came from x.x.1.2 or y.y.1.2.

If the source and destination ports are fixed (as they usually are for M3UA)
you can sit trying to make an outward connection, relying on the init collision
code to work properly. Far from ideal!

	David

