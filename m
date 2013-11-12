From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 12 Nov 2013 13:43:40 +0000
Subject: Re: Multi-homing question
Message-Id: <20131112134340.GA19780@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
In-Reply-To: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Nov 12, 2013 at 10:05:25AM +0800, tsoi andrew wrote:
> Hi Neil,
> 
> Many thanks.
> > Moreover, in your utility, can your secondary IP return heartbeat ACK to client?
> >
> Yes, Heartbeak ACKs always need to be sent on the same transport that received
> the heartbeat in the first place.
You seem like you know this.  Why did you ask the question then?

> Do you mean the lksctp server secondary IP can be connected to primary
> IP and secondary IP for the client at the same time?
> 
I never made that assertion previously.  You can have two transports, one
between each peer address from a single local address, but you will only wind up
using a single transport at any one time (unless you are using round robin
transmission).
Neil

> 
