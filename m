From: Adam Endrodi <adam.endrodi@nokia.com>
Date: Mon, 09 Mar 2015 09:40:36 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <20150309094036.GJ2684@timmy>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Mar 07, 2015 at 08:44:24PM +0100, ext Danny Smit wrote:
> I changed my code to reflect this, but it doesn't really make a
> difference. For what its worth, I already tried something similar with
> an higher level API to wait for socket notification, which led to the
> same results.
> 
> Whats interesting is that the poll() call returns immediately (within
> milliseconds) regardless of the timeout value. It does set "revents"
> on the struct in [sfd], of which the very first occurrence of this
> call sets revents to 73 (0x49), but all subsequent calls to poll
> within the loop shown above sets revents to 65 (0x48).

So POLLERR (0x08) is reported in all cases.  Perhaps this is the indication
of ABORT you're looking for?

> But every call to sctp_recvmsg() still returns with an error and sets
> errno to 107 (ENOTCONN). Therefore sctp_recvmsg somehow still seems
> unable to read the events.

I'm out of ideas :( Time to involve real experts I guess.

-- 
What doesn't kill you makes you stronger.
