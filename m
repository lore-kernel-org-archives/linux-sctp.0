From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 25 Jul 2014 01:23:25 +0000
Subject: Re: source IP and interface selection
Message-Id: <53D1B18D.6070303@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E374E28@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E374E28@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/24/2014 02:12 PM, Butler, Peter wrote:
> We have a multi-homed SCTP network topology that essentially boils down to this
> 
> A <----------> A'
> B <----------> B'
> 
> where IPs A and B are on the local host, and A' and B' are the corresponding IPs on the remote host.
> 
> We are seeing HEARTBEAT request messages leave the B interface (destined for B') but that contain a source IP address of A.  On the other hand, a simple ICMP 'ping' command to B will leave the B interface, but with the (expected) source address of B as well.  So presumably the issue is SCTP-specific.
> 
> I know the Linux uses a fairly weak host model and will route packets with source address A out of B if instructed to do so.  So the question here is, is it SCTP that is specifically instructing the kernel to do so in this case?  Are there any kernel SCTP parameters, or generic kernel IP parameters for that matter, that can be configured so as to disallow this behaviour?
> 

the simplest way to tell is by using the following command:
 # ip route get A'

That will show you a route that the packet would normally take.

SCTP by default will use the same route, unless the source address specified
in the route is not a part of the sctp association.  In that case, SCTP will
try to look up routes by trying each address from the association address list.

If you are not sure what addresses are in the association, you can dump the
contents of /proc/net/sctp/assocs.  That will contain all the addresses
assigned to the association.

Depending on the addresses you use, you might also be hitting an scope issue,
but that's less likely.

-vlad

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

