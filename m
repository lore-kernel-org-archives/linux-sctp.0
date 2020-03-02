From: Harald Welte <laforge@gnumonks.org>
Date: Mon, 02 Mar 2020 12:37:54 +0000
Subject: Re: Expected SCTP DATA chunk per second performance
Message-Id: <20200302123754.GM43827@nataraja>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200302093532.GE43827@nataraja>
In-Reply-To: <20200302093532.GE43827@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Michael,

On Mon, Mar 02, 2020 at 12:41:57PM +0100, Michael Tuexen wrote:
> > In wireshark, I can see that up to 9 DATA chunks are aggregated into each SCTP
> > packet.  However, it typically takes the stack 203-201ms to send a SACK to each
>
> That looks suspicious. It seems this is the 200ms delayed ACK timer. That is fine.
> The question is why the sender is not sending more? I guess you can work around this
> issue by disabling the Nagle Algorithm:
> https://tools.ietf.org/html/rfc6458#section-8.1.5
> Enable SCTP_NODELAY on the sender side. Does that fix the issue?
> However, Nagle should not step into the game here...

I was thinking of SCTP_NODELAY before, but didn't do it as I thought it
would only impact the lower latency bound in sporadic communication, but
not throttle the transmit message rate?

I've just tried your suggestion, and indeed:

with SCTP_NODELAY=0
10000 DATA chunks of 150 bytes each in 19.59 seconds: 510.53 DATA chunks per second

with SCTP_NODELAY=1
10000 DATA chunks of 150 bytes each in  0.26 seconds: 38360.42 DATA chunks per second

So AFAICT there now is a work-around... but still I assume there is a bug in lksctp
if it throttles the overall message rate down to 1.3% of what it could
be when Nagle is enabled?

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
======================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
