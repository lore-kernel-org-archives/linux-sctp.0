From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Sep 2016 21:19:12 +0000
Subject: [PATCH next 0/2] improvements to SSN and TSN handling
Message-Id: <cover.1474405559.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Laight <David.Laight@ACULAB.COM>

First patch fixes a potential issue made visible by the second one
noticed by David Laight and is a preparation for the next one.

The second patch changes how SSN, TSN and ASCONF serials are compared so
they can use typecheck() and are more like time_before() macro.

Marcelo Ricardo Leitner (2):
  sctp: fix the handling of SACK Gap Ack blocks
  sctp: improve how SSN, TSN and ASCONF serial are compared

 include/net/sctp/sm.h | 94 ++++++++++-----------------------------------------
 net/sctp/outqueue.c   | 11 +++---
 2 files changed, 24 insertions(+), 81 deletions(-)

-- 
2.7.4

