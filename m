From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 23 Jun 2017 22:58:39 +0000
Subject: [PATCH net-next 0/4] RFC 4960 Errata fixes
Message-Id: <cover.1498251459.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

This patchset contains fixes for 4 Errata topics from
https://tools.ietf.org/html/draft-ietf-tsvwg-rfc4960-errata-01
Namely, sections:
 3.12. Order of Adjustments of partial_bytes_acked and cwnd
 3.22. Increase of partial_bytes_acked in Congestion Avoidance
 3.26. CWND Increase in Congestion Avoidance Phase
 3.27. Refresh of cwnd and ssthresh after Idle Period

Tests performed with netperf using net namespaces, with drop rates at
0%, 0.5% and 1% by netem, IPv4 and IPv6, 10 runs for each combination.
I couldn't spot differences on the stats. With and without these patches
the results vary in a similar way in terms of throughput and
retransmissions.

Tests with 20ms delay and 20ms delay + drops at 0.5% and 1% also had
results in a similar way, no noticeable difference.

Looking at cwnd, it was possible to notice slightly lower values being
used while still sustaining same throughput profile.

Marcelo Ricardo Leitner (4):
  sctp: update order of adjustments of partial_bytes_acked and cwnd
  sctp: allow increasing cwnd regardless of ctsn moving or not
  sctp: adjust cwnd increase in Congestion Avoidance phase
  sctp: adjust ssthresh when transport is idle

 net/sctp/transport.c | 54 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 21 deletions(-)

-- 
2.9.4

