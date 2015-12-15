From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 15 Dec 2015 03:38:59 +0000
Subject: Re: Question on SACK handling in LKSCTP
Message-Id: <566F8B53.1090800@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftJ57SHB5Cw433JQ-xqdRVjK2euKzBe+t8i8OyN_ax5Y8A@mail.gmail.com>
In-Reply-To: <CAFXGftJ57SHB5Cw433JQ-xqdRVjK2euKzBe+t8i8OyN_ax5Y8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/14/2015 08:13 PM, Sun Paul wrote:
> Hi All
> 
> I would like to check how LKSCTP handle late arrival of SACK.
> 
> Our application is a DIAMETER based application running over SCTP, and
> we found a strange behavior that if we send out DIAMETER request in a
> batch, says 10 requests, the remote end point do not response at once,
> and maybe after 5 secs, they response back with 10 SACKS.

The fact that you get 10 SACKs back means that you are transmitting
each DIAMETER request individually.  So while at the DIAMETER level you
may be batching, SCTP isn't bundling messages.

Your statement about getting sacks back after 5 seconds leads to me
believe that you have a very long rtt in your setup for some reason.
5 seconds is really excessive...

There could be multihoming issues or something else and without more
information it's hard to say.

> 
> If in this case, will the LKSCTP libraries wait for the SACK before
> sending the new request? Or, it is actually controlled by user
> application level?

The amount of data SCTP can have outstanding is governed by available
congestion window and receive window.  Once either of those windows
is full, SCTP will not transmit more data until the window opens again.
The windows will using open when a SACK arrives acknowledging that
data.

If a SACK isn't receiving within the round trip time, a retransmit is
triggered.  Late SACKs will not update the rtt, but will still open windows
for more data to be sent.

-vlad

> 
> Thanks
> 
> - RBK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

