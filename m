From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 13 Aug 2009 17:15:35 +0000
Subject: Re: got some questions on support for multihoming
Message-Id: <4A844A37.6070101@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A835B67.2040202@nortel.com>
In-Reply-To: <4A835B67.2040202@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Chris Friesen wrote:
> Hi all,
> 
> I've got a few questions about the current implementation of SCTP.
> Suppose I have two network nodes, each of which has two IP addresses.
> Theoretically this results in four possible paths between the two nodes.

Theoretically, but often not in practice.

> 
> If the network device corresponding to the primary IP address goes down
> on the remote node, will the current implementation properly switch over
> to use the "most divergent source-destination pair" as suggested in the
> RFC?  I assume this would mean switching to the other IP address on both
> nodes?

It sort of depends on how the addresses are configured.  Assuming a typical
multihomed scenario where each address is in its own subnet, then the answer
is yes.  Ex:

node A (addrs: 1.2.3.4, 2.3.4.5)  <---------> Node B (addrs: 1.2.3.5, 2.3.4.6)

In this case, assuming 1.2.3.0/24 was primary, the path with switch to
2.3.4.5 <--> 2.3.4.5.

It really is a function of the routing looking by the kernel.

> 
> Same question, but with the device corresponding to the primary IP
> address going down on the local node.

Once the appropriate time-outs happen, it should switch the same as above.

> 
> If a chunk times out, will the current implementation retransmit it via
> the "most divergent source-destination pair" as suggested in the RFC?

Most of the time.  We simply try to pick a different destination address to
send to, and let the kernel pick a source.  As long as the source picked by
the kernel is within our bound set, we'll use it.  We don't check for
'mostly divergent pair'.

-vlad

> 
> Thanks,
> 
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

