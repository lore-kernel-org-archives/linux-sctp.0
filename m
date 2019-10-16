From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 16 Oct 2019 10:42:23 +0000
Subject: RE: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Message-Id: <1f6cf86fce074a9cbf7f8c2496cc7c84@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <20191015.175639.347136446069377956.davem@davemloft.net>
In-Reply-To: <20191015.175639.347136446069377956.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'David Miller' <davem@davemloft.net>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>

From: David Miller
> Sent: 16 October 2019 01:57
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 14 Oct 2019 14:14:43 +0800
> 
> > SCTP-PF was implemented based on a Internet-Draft in 2012:
> >
> >   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> >
> > It's been updated quite a few by rfc7829 in 2016.
> >
> > This patchset adds the following features:
> >
> >   1. add SCTP_ADDR_POTENTIALLY_FAILED notification
> >   2. add pf_expose per netns/sock/asoc
> >   3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
> >   4. add ps_retrans per netns/sock/asoc/transport
> >      (Primary Path Switchover)
> >   5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt
> 
> I would like to see some SCTP expert ACKs here.

I'm only an SCTP user, but I think some of the API changes aren't right.
I'm not going to try to grok the sctp code - it makes my brain hurt.
(Even though I've written plenty of protocol stack code.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
