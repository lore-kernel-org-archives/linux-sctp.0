From: Adam Endrodi <adam.endrodi@nsn.com>
Date: Fri, 06 Mar 2015 11:13:41 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <20150306111341.GC2684@timmy>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Mar 06, 2015 at 11:52:05AM +0100, ext Danny Smit wrote:
> 
> I'm look into a possible memory issue when using sctp_connectx. This
> week I've asked to following on the CentOS mailing list:

I think you'll find this thread relevant:
http://www.spinics.net/lists/linux-sctp/msg03705.html

> ------------------------------
> I'm running into a possible memory issue with the SCTP implementation
> in CentOS 6, using lksctp-tools. So far I've not seen the problem with
> other distributions yet.
> 
> The problem is that whenever a SCTP client connection is initiated to
> a second host and port at which no SCTP server application is
> listening
> 
> The scenario is simple:
> - call socket() to create a socket.
> - call sctp_connectx() to establish a connection.
> 
> The last call is repeated periodically to retry to establish a connection.
> 
> When looking on the wire using wireshark it shows that an SCTP INIT
> packet is sent to the second host, which replies with an SCTP ABORT.
> 
> This is exactly according to the SCTP specification. However it
> appears ABORT isn't propagated into to application layer that calls
> sctp_connectx().
[...] 
> Note that the API is used in non-blocking mode.

This case sctp_connectx() doesn't wait until the connection is established.
You need to use sctp_recvmsg() to get the notification.

> Furthermore, because reconnect attempts are made, a steady memory
> increasement occurs. Looking at /proc/meminfo, the increasement occurs
> in SUnreclaim, the kernel slab cache.

Perhaps these are the event being queued up?

-- 
So if you walk away, who is gonna stay?
