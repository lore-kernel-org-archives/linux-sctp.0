From: "Chris Friesen" <cfriesen@nortel.com>
Date: Thu, 13 Aug 2009 00:16:39 +0000
Subject: got some questions on support for multihoming
Message-Id: <4A835B67.2040202@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all,

I've got a few questions about the current implementation of SCTP.
Suppose I have two network nodes, each of which has two IP addresses.
Theoretically this results in four possible paths between the two nodes.

If the network device corresponding to the primary IP address goes down
on the remote node, will the current implementation properly switch over
to use the "most divergent source-destination pair" as suggested in the
RFC?  I assume this would mean switching to the other IP address on both
nodes?

Same question, but with the device corresponding to the primary IP
address going down on the local node.

If a chunk times out, will the current implementation retransmit it via
the "most divergent source-destination pair" as suggested in the RFC?

Thanks,

Chris
