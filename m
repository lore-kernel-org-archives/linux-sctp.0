From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 14 May 2016 02:29:23 +0000
Subject: Re: sctp_getpaddrs() on a SHUTDOWN association
Message-Id: <20160514022923.GC13980@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160513103533.GH3043@timmy>
In-Reply-To: <20160513103533.GH3043@timmy>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Fri, May 13, 2016 at 12:35:33PM +0200, Adam Endrodi wrote:
> 
> Hi there,
> 
> 
> I've got a simple case: a multi-homed client connects to a server, then
> disconnects right away.  On the server side we receive the SCTP_COMM_UP
> notification and try to get the client's addresses with sctp_getpaddrs().
> But since the L3 connection has been SHUTDOWN properly the function fails
> with EINVAL.
> 
> Unfortunately accept(2) only returns the first address of the client.
> 
> I have a 3.13.0-37.64 generic kernel from Ubuntu, but the affected code
> path seems to be the same as in kernel 4.4.
> 
> Do you happen to have an idea how to work it around and obtain the client's
> addresses after the associtation has been SHUTDOWN?  I've made the client
> wait a little before closing the connection, but I don't like it.
> 
> Thanks,
> adam

Not to work around, as that seems just impossible.

But one idea to improve it would be to not schedule SCTP_CMD_DELETE_TCB
right on sctp_sf_do_4_C() but when that event:
        ev = sctp_ulpevent_make_assoc_change(asoc, 0, SCTP_SHUTDOWN_COMP, 
                                             0, 0, 0, NULL, GFP_ATOMIC);  
is consumed by the application, or right away if the event allocation
fails.

I didn't check for possible side-effects of this change, btw.

  Marcelo

