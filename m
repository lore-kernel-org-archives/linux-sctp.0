From: David Miller <davem@davemloft.net>
Date: Mon, 11 Apr 2011 01:52:36 +0000
Subject: Re: [PATCH net-next-2.6 v3 0/3] sctp: Patch series
Message-Id: <20110410.185236.59685173.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <DF0CDFCF-8559-495A-9C9E-60997E7DE0F2@sfc.wide.ad.jp>
In-Reply-To: <DF0CDFCF-8559-495A-9C9E-60997E7DE0F2@sfc.wide.ad.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: micchie@sfc.wide.ad.jp
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Michio Honda <micchie@sfc.wide.ad.jp>
Date: Fri, 8 Apr 2011 14:18:30 +0900

[ Changed lksctp to linux-sctp@vger.kernel.org as that is the mailing
  list provided in linux/MAINTAINERS ]

> Series of 5 patches to support auto_asconf and the other related
> functionalities that auto_asconf relies on.
...
> [1/3] Add Auto-ASCONF support
> [2/3] Add ASCONF operation on the single-homed host
> [3/3] Add a valid address list in association local

Can an SCTP expert please review these patches?
