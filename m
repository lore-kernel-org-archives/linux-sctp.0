From: Geir Ola Vaagland <geirola@gmail.com>
Date: Tue, 17 Jun 2014 11:57:47 +0000
Subject: [PATCH net-next 0/6] A step closer to RFC 6458 compliancy
Message-Id: <1403006273-27859-1-git-send-email-geirola@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org


Geir Ola Vaagland (6):
  Support for SCTP_RECVRCVINFO socket option
  Support for SCTP_RCVINFO ancillary data
  Support for SCTP_SNDINFO ancillary data
  Support for SCTP_NXTINFO socket option
  Support for receiving SCTP_NXTINFO ancillary data
  Support for SCTP_DEFAULT_SNDINFO socket option

 include/net/sctp/structs.h  |  11 +-
 include/net/sctp/ulpevent.h |   4 +
 include/uapi/linux/sctp.h   |  46 ++++++++
 net/sctp/socket.c           | 260 ++++++++++++++++++++++++++++++++++++++++++--
 net/sctp/ulpevent.c         | 158 +++++++++++++++++++++++++++
 5 files changed, 470 insertions(+), 9 deletions(-)

