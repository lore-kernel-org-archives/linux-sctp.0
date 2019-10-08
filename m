From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 11:27:32 +0000
Subject: [PATCH net-next 0/4] sctp: add some missing events from rfc5061
Message-Id: <cover.1570534014.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

There are 4 events defined in rfc5061 missed in linux sctp:
SCTP_ADDR_ADDED, SCTP_ADDR_REMOVED, SCTP_ADDR_MADE_PRIM and
SCTP_SEND_FAILED_EVENT.

This patchset is to add them up.

Xin Long (4):
  sctp: add SCTP_ADDR_ADDED event
  sctp: add SCTP_ADDR_REMOVED event
  sctp: add SCTP_ADDR_MADE_PRIM event
  sctp: add SCTP_SEND_FAILED_EVENT event

 include/net/sctp/ulpevent.h | 16 +++++++------
 include/uapi/linux/sctp.h   | 16 ++++++++++++-
 net/sctp/associola.c        | 22 +++++++----------
 net/sctp/chunk.c            | 40 +++++++++++++++----------------
 net/sctp/ulpevent.c         | 57 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 108 insertions(+), 43 deletions(-)

-- 
2.1.0
