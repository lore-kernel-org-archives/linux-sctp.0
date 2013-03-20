From: Ankit Mahawar <ankit.mahawar@tcs.com>
Date: Wed, 20 Mar 2013 10:37:45 +0000
Subject: Query regarding heartbeat re-transmission pattern
Message-Id: <OFC9C24BC7.4A688B98-ON65257B34.00393EBB-65257B34.00394A48@tcs.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Hi All ,

I have a basic query regarding SCTP heartbeat re-transmission pattern .

As per the RFC 4960 :

Furthermore, when its peer is multi-homed, an endpoint SHOULD try to
retransmit a chunk that timed out to an active destination transport
address that is different from the last destination address to which the
DATA chunk was sent.

Also,
When retransmitting data that timed out, if the endpoint is multi-homed, it
should consider each source-destination address pair in its retransmission
selection policy.  When retransmitting timed-out data, the endpoint should
attempt to pick the most divergent source-destination pair from the
original source-destination pair to which the packet was transmitted.

Suppose if we have multihomed SCTP endpoints A and B .

A                      B

a.a.a.p               b.b.b.p
a.a.a.s               b.b.b.s

If we transmit heartbeat from a.a.a.s to b.b.b.s and it is not acknowledged
so does it re-transmit it using the same src and destination or with
a.a.a.p to b.b.b.s.

Please help to understand .

Thanks

===-----===-----==Notice: The information contained in this e-mail
message and/or attachments to it may contain 
confidential or privileged information. If you are 
not the intended recipient, any dissemination, use, 
review, distribution, printing or copying of the 
information contained in this e-mail message 
and/or attachments to it are strictly prohibited. If 
you have received this communication in error, 
please notify us by reply e-mail or telephone and 
immediately and permanently delete the message 
and any attachments. Thank you



