From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 05 Oct 2020 17:16:43 +0000
Subject: Re: Heartbeat on closed SCTP sockets?
Message-Id: <20201005171643.GK70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1FB70B30-857C-4CD9-A05C-4BA15F57B1D2@list.fink.org>
In-Reply-To: <1FB70B30-857C-4CD9-A05C-4BA15F57B1D2@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Mon, Oct 05, 2020 at 06:39:22PM +0200, Andreas Fink wrote:
...
> What we now see in netstat --sctp is:
> 
> we have a LISTEN on port 2010
> we have a  association from port 2010 to the remote in status CLOSED
> 
> in tcpdump we see packets coming in from the remote and heartbeat being acknowledged. However our application is not answering to these packets and the status of the application shows SCTP being down.
> In other words, my application sees the association down. Netstat shows the association as being closed but the kernel seems to continue to entertain this association by continue to send heartbeat ACK and not sending ABORT.

That's weird. If it is in CLOSED, then the stack should be handling
it as an OOTB packet and trigger an Abort.

> 
> We now kill the application
> 
> What we now see in netstat --sctp is:
> we no longer listen on port 2010
> we have a closed association from port 2010 to the remote.
> 
> in tcpdump we however we STILL see packets coming in from the remote and heartbeat being acknowledged, even though no application is listening on this port and no userspace application is using that port.
> We do not see any SHUTDOWN or INIT even if we restart the application.
> 
> Can anyone explain how this can be?

Please check the assoc status as well, via 'ss -a --sctp' and
/proc/net/sctp/assocs . Maybe it got out of sync of the socket status.

  Marcelo
