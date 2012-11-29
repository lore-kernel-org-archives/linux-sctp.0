From: Dilip Daya <dilip.daya@hp.com>
Date: Thu, 29 Nov 2012 20:35:37 +0000
Subject: SCTP sysctl /proc/sys/net/sctp/rto_min/initial/max variables
Message-Id: <1354221337.6915.107.camel@pro6455b.example.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

Testing kernel 3.2.32 x86_64 environment show the sctp sysctl variables:

 - net.sctp.rto_initial,
 - net.sctp.rto_min,
 - net.sctp.rto_max

are not overriding the hard-coded recommended values of:
- http://lxr.linux.no/linux+v3.2.34/include/net/sctp/constants.h#L276

I've confirmed the following values are correct to what I need modified:
 - /proc/sys/net/sctp/rto_initial
 - /proc/sys/net/sctp/rto_min
 - /proc/sys/net/sctp/rto_max

If I change the hard-coded values and rebuild sctp they take effect. Is
this an issue on my end or is this a sctp sysctl issue?

Thanks,
-DilipD.

