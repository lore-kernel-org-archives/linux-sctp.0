From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 08 Jan 2018 21:02:26 +0000
Subject: [PATCH net 0/3] Some sockopt optlen fixes
Message-Id: <cover.1515436112.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, haliu@redhat.com

Hangbin Liu reported that some SCTP sockopt are allowing the user to get
the kernel to allocate really large buffers by not having a ceiling on
optlen.

This patchset address this issue (in patch 2), replace an GFP_ATOMIC
that isn't needed and avoid calculating the option size multiple times
in some setsockopt.

Marcelo Ricardo Leitner (3):
  sctp: GFP_ATOMIC is not needed in sctp_setsockopt_events
  sctp: add a ceiling to optlen in some sockopts
  sctp: make use of pre-calculated len

 net/sctp/socket.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

-- 
2.14.3

