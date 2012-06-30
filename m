From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 30 Jun 2012 12:26:47 +0000
Subject: Re: [PATCH v5] sctp: be more restrictive in transport selection on bundled sacks
Message-Id: <20120630122647.GA22647@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1340742704-2192-1-git-send-email-nhorman@tuxdriver.com>
 <1341000929-22933-1-git-send-email-nhorman@tuxdriver.com>
 <20120629.163408.1111786778802302299.davem@davemloft.net>
In-Reply-To: <20120629.163408.1111786778802302299.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

On Fri, Jun 29, 2012 at 04:34:08PM -0700, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Fri, 29 Jun 2012 16:15:29 -0400
> 
> > +	/* Has this transport moved the ctsn since we last sacked */
> > +	__u32 sack_generation;
> > +
>  ...
> > +		__u32	sack_generation;
> 
> These are __u32 but they only take on the value '1' or '0'.  Please
> use bool and give it a more reasonable name, a name that describes
> how it is really a predicate.
> 
This is wrong.  Its a counter that increments every time we call sctp_make_sack,
so that we can create a unique generation identifier for use in tagging which
transports move ctsn in a given generation.  It saves us from having to iterate
over a list every time we send a sack. 

> > -		struct sctp_association *asoc;
> >  		struct timer_list *timer;
> > -		asoc = pkt->transport->asoc;
> > +		struct sctp_association *asoc = pkt->transport->asoc;
> > +
> 
> Please leave asoc where it was, on the first line.  We encourage
> listing local variables such that the longest lines come first,
> then gradually shorter and short lines.
> 
> > +	/*
> > +	 * Once we have a sack generated, check to see what our sack
> > +	 * generation is, if its 0, reset the transports to 0, and reset
> 
> Please format:
> 
>   /* Like
>    * this.
>    */
> 
> Thanks.
> 
Very well, I'll repost in the next few days
Neil

> 
