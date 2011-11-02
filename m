From: "Kiss, Zoltan (NSN - HU/Budapest)" <zoltan.kiss@nsn.com>
Date: Wed, 02 Nov 2011 17:34:35 +0000
Subject: Per association statistics
Message-Id: <79C4240C13B4C84B910850B96B1B4312035355F2@DEMUEXC035.nsn-intra.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I've recently tried an application on 2.6.34.6, and I had to realize,
that SCTP_GET_ASSOC_STATS getsockopt works no longer anymore, like in
2.6.21. I couldn't find any source why it was removed from stack, and is
there anything to replace it. I've especially need in/out byte/packet
counters, but as I see I can find it on a per process basis, but I need
these counters for one specific association/socket. I've only found the
old retrans counter, but it also cumbersome as it is available only
through /proc filesystem.
Why was this feature removed, and how can I workaround its lack?

Regards,

Zoltan Kiss
