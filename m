From: Andreas Fink <afink@list.fink.org>
Date: Mon, 05 Oct 2020 16:39:22 +0000
Subject: Heartbeat on closed SCTP sockets?
Message-Id: <1FB70B30-857C-4CD9-A05C-4BA15F57B1D2@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello all,

We are trying to debug a very strange case here and would like to hear your input.

Here is what we have

1. we have a application which listens on a  point to multipoint SCTP socket
2. when a incoming connection comes in and it matches a preconfigured one, it peels of that socket and a separate thread is starting communication on the upper layer.
3. when it doesnt match, an abort is triggered (that part might not work yet though).


Now we have multiple connections to different vendors and we have traces where we can see that there was a temporary issue on the IP layer and associations get shutdown and restarted.
After the IP layer resolved, all connection came up except two which go to the same peer and vendor.

What we now see in netstat --sctp is:

we have a LISTEN on port 2010
we have a  association from port 2010 to the remote in status CLOSED

in tcpdump we see packets coming in from the remote and heartbeat being acknowledged. However our application is not answering to these packets and the status of the application shows SCTP being down.
In other words, my application sees the association down. Netstat shows the association as being closed but the kernel seems to continue to entertain this association by continue to send heartbeat ACK and not sending ABORT.

We now kill the application

What we now see in netstat --sctp is:
we no longer listen on port 2010
we have a closed association from port 2010 to the remote.

in tcpdump we however we STILL see packets coming in from the remote and heartbeat being acknowledged, even though no application is listening on this port and no userspace application is using that port.
We do not see any SHUTDOWN or INIT even if we restart the application.

Can anyone explain how this can be?

We are using kernel linux-image-5.4.0-0.bpo.4-amd64 from the Debian Backport repositiory on Debian 10.

The issue seems to be related that the remote side never closes the SCTP assoc but simply tries to restart the upper layers while other vendors time out on upper layers and restart the SCTP assoc.
Restarting it from my application outbound also didnt help. Kernel somehow still remembers there's something up where theres clearly not.

The only solution to get this assoc back alive is to reboot the whole machine it seems.

Thanks for any input.
