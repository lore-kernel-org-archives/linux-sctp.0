From: "Lee A. Roberts" <lee.roberts@hp.com>
Date: Thu, 28 Feb 2013 14:37:26 +0000
Subject: [PATCH v3 0/4] sctp: fix association hangs due to reassembly/ordering logic
Message-Id: <1362062250-26749-1-git-send-email-lee.roberts@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
In-Reply-To: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, lee.roberts@hp.com

From: "Lee A. Roberts" <lee.roberts@hp.com>

This series of patches resolves several SCTP association hangs observed during
SCTP stress testing.  Observable symptoms include communications hangs with
data being held in the association reassembly and/or lobby (ordering) queues.
Close examination of reassembly/ordering queues may show either duplicated
or missing packets.

In version #2, corrected build failure in initial version of patch series
due to wrong calling sequence for sctp_ulpq_partial_delivery() being inserted
in sctp_ulpq_renege().

In version #3, adjusted patch documentation to be less repetitive.

Lee A. Roberts (4):
  sctp: fix association hangs due to off-by-one errors in
    sctp_tsnmap_grow()
  sctp: fix association hangs due to reneging packets below the
    cumulative TSN ACK point
  sctp: fix association hangs due to errors when reneging events from
    the ordering queue
  sctp: fix association hangs due to partial delivery errors

 net/sctp/tsnmap.c   |   13 ++++----
 net/sctp/ulpqueue.c |   87 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 78 insertions(+), 22 deletions(-)

-- 
1.7.9.5

