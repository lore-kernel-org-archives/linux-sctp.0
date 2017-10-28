From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 28 Oct 2017 11:43:53 +0000
Subject: [PATCH net 0/4] sctp: a bunch of fixes for some sparse warnings
Message-Id: <cover.1509190967.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

As Eric noticed, when running 'make C=2 M=net/sctp/', a plenty of
warnings or errors checked by sparse appear. They are all problems
about Endian and type cast.

Most of them are just warnings by which no issues could be caused
while some might be bugs.

This patchset fixes them with four patches basically according to
how they are introduced.

Xin Long (4):
  sctp: fix some type cast warnings introduced by stream reconf
  sctp: fix some type cast warnings introduced by transport rhashtable
  sctp: fix a type cast warnings that causes a_rwnd gets the wrong value
  sctp: fix some type cast warnings introduced since very beginning

 include/linux/sctp.h        | 34 +++++++++++++++++-----------------
 include/net/sctp/sm.h       |  2 +-
 include/net/sctp/ulpevent.h |  2 +-
 include/uapi/linux/sctp.h   |  2 +-
 net/sctp/input.c            | 22 +++++++++++-----------
 net/sctp/ipv6.c             |  2 +-
 net/sctp/sm_make_chunk.c    |  9 +++++----
 net/sctp/sm_sideeffect.c    |  8 ++++----
 net/sctp/stream.c           | 26 +++++++++++++++++---------
 net/sctp/ulpevent.c         |  2 +-
 10 files changed, 59 insertions(+), 50 deletions(-)

-- 
2.1.0

