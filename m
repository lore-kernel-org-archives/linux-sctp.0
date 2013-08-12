From: Karl Heiss <kheiss@gmail.com>
Date: Mon, 12 Aug 2013 12:23:12 +0000
Subject: Socket buffer autotuning
Message-Id: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

All,

A recent post to the netdev mailing list made it clear that SCTP
doesn't support socket buffer autotuning.  All of a sudden, many of
our benchmarks start to make sense...  Has there been any
work/investigation to support this?  I suspect that there might be
some difficulty due to the multihoming nature of SCTP, but I haven't
taken the time to really investigate this avenue...  Any insight it
greatly appreciated.

Thanks,
Karl
