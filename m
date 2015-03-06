From: Adam Endrodi <adam.endrodi@nokia.com>
Date: Fri, 06 Mar 2015 16:29:33 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <20150306162933.GH2684@timmy>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Mar 06, 2015 at 04:42:57PM +0100, ext Danny Smit wrote:
> On Fri, Mar 6, 2015 at 12:13 PM, Adam Endrodi wrote:
> > On Fri, Mar 06, 2015 at 11:52:05AM +0100, ext Danny Smit wrote:
> >>
> >> The scenario is simple:
> >> - call socket() to create a socket.
> >> - call sctp_connectx() to establish a connection.
> >>
> >> The last call is repeated periodically to retry to establish a connection.
> >>
> >> When looking on the wire using wireshark it shows that an SCTP INIT
> >> packet is sent to the second host, which replies with an SCTP ABORT.
> >>
> >> This is exactly according to the SCTP specification. However it
> >> appears ABORT isn't propagated into to application layer that calls
> >> sctp_connectx().
> > [...]
> >> Note that the API is used in non-blocking mode.
> >
> > This case sctp_connectx() doesn't wait until the connection is established.
> > You need to use sctp_recvmsg() to get the notification.
> 
> I tried to apply this as suggested, the scenario now is as follows:
> 
> First call sctp_connectx() on a socket in non blocking mode, which
> results in the error code EINPROGRESS.
> 
> Next call sctp_recvmsg(), which results in the error code ENOTCONN
> instead of getting any notifications.
> 
> This actually feels right because there is no connection established
> yet. It also doesn't seem to make a difference for the memory
> consumption. Am I missing something?

How about something like:

for (;;)
{
	sctp_connectx(sfd);
	poll([sfd], -1);
	sctp_recvmsg(sfd);
}

-- 
adam
