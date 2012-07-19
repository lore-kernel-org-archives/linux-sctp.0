From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 19 Jul 2012 10:45:13 +0000
Subject: Re: [PATCH v2] sctp: Implement quick failover draft from tsvwg
Message-Id: <20120719104513.GB2070@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1342203998-24037-1-git-send-email-nhorman@tuxdriver.com>
 <1342634466-17930-1-git-send-email-nhorman@tuxdriver.com>
 <1342643458.2013.32.camel@joe2Laptop>
In-Reply-To: <1342643458.2013.32.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org

On Wed, Jul 18, 2012 at 01:30:58PM -0700, Joe Perches wrote:
> On Wed, 2012-07-18 at 14:01 -0400, Neil Horman wrote:
> > I've seen several attempts recently made to do quick failover of sctp transports
> > by reducing various retransmit timers and counters.  While its possible to
> > implement a faster failover on multihomed sctp associations, its not
> > particularly robust, in that it can lead to unneeded retransmits, as well as
> > false connection failures due to intermittent latency on a network.
> 
> trivia:
> 
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> 
> > @@ -871,6 +885,10 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> >  		spc_state = SCTP_ADDR_UNREACHABLE;
> >  		break;
> >  
> > +	case SCTP_TRANSPORT_PF:
> > +		transport->state = SCTP_PF;
> > +		ulp_notify = false;
> > +		break;
> 
> nicer to add a newline here
> 
Ack, I'll fix that.

> >  	default:
> >  		return;
> >  	}
> > @@ -878,12 +896,15 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> []
> > +	if (ulp_notify) {
> > +		memset(&addr, 0, sizeof(struct sockaddr_storage));
> > +		memcpy(&addr, &transport->ipaddr,
> > +		       transport->af_specific->sockaddr_len);
> 
> Perhaps it's better to do the memcpy then the memset of the
> space left instead.
> 
> 		memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
> 		memset((char *)&addr) + transport->af_specific->sockaddr_len, 0,
> 		       sizeof(struct sockaddr_storage) - transport->af_specific->sockaddr_len);
> 		       
> 
hmm, not sure about that. It works either way for me, but I've not changed that
code, just the condition under which it was executed.  I'd rather save cleanups
like that for a separate patch if you don't mind.
Neil

> 
> 
