From: Joe Perches <joe@perches.com>
Date: Thu, 19 Jul 2012 16:54:19 +0000
Subject: Re: [PATCH v2] sctp: Implement quick failover draft from tsvwg
Message-Id: <1342716859.1988.20.camel@joe2Laptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <1342203998-24037-1-git-send-email-nhorman@tuxdriver.com>
	 <1342634466-17930-1-git-send-email-nhorman@tuxdriver.com>
	 <1342643458.2013.32.camel@joe2Laptop>
	 <20120719104513.GB2070@hmsreliant.think-freely.org>
In-Reply-To: <20120719104513.GB2070@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org

On Thu, 2012-07-19 at 06:45 -0400, Neil Horman wrote:
> On Wed, Jul 18, 2012 at 01:30:58PM -0700, Joe Perches wrote:
> > On Wed, 2012-07-18 at 14:01 -0400, Neil Horman wrote:
> > > I've seen several attempts recently made to do quick failover of sctp transports
> > > by reducing various retransmit timers and counters.  While its possible to
> > > implement a faster failover on multihomed sctp associations, its not
> > > particularly robust, in that it can lead to unneeded retransmits, as well as
> > > false connection failures due to intermittent latency on a network.
[]
> > > @@ -878,12 +896,15 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > []
> > > +	if (ulp_notify) {
> > > +		memset(&addr, 0, sizeof(struct sockaddr_storage));
> > > +		memcpy(&addr, &transport->ipaddr,
> > > +		       transport->af_specific->sockaddr_len);
> > 
> > Perhaps it's better to do the memcpy then the memset of the
> > space left instead.
> > 
> > 		memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
> > 		memset((char *)&addr) + transport->af_specific->sockaddr_len, 0,
> > 		       sizeof(struct sockaddr_storage) - transport->af_specific->sockaddr_len);
> > 
> hmm, not sure about that. It works either way for me, but I've not changed that
> code, just the condition under which it was executed.  I'd rather save cleanups
> like that for a separate patch if you don't mind.

Not a bit.

It's almost certain reversing the order is slower for v4
addresses anyway.  It might be slower for v6 too given
the arithmetic.

cheers, Joe

