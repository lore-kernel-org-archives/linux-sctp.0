From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 05 Mar 2018 12:44:17 +0000
Subject: [PATCH net-next 0/3] sctp: add support for some msg_control options from RFC6458
Message-Id: <cover.1520253539.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset is to add support for 3 msg_control options described
in RFC6458:

    5.3.7.  SCTP PR-SCTP Information Structure (SCTP_PRINFO)
    5.3.9.  SCTP Destination IPv4 Address Structure (SCTP_DSTADDRV4)
    5.3.10. SCTP Destination IPv6 Address Structure (SCTP_DSTADDRV6)

one send flag described in RFC6458:

    SCTP_SENDALL:  This flag, if set, will cause a one-to-many
    style socket to send the message to all associations that
    are currently established on this socket.  For the one-to-
    one style socket, this flag has no effect.

Note there is another msg_control option:

    5.3.8.  SCTP AUTH Information Structure (SCTP_AUTHINFO)

It's a little complicated, I will post it in another patchset after
this.

Xin Long (3):
  sctp: add support for PR-SCTP Information for sendmsg
  sctp: add support for SCTP_DSTADDRV4/6 Information for sendmsg
  sctp: add support for snd flag SCTP_SENDALL process in sendmsg

 include/net/sctp/structs.h |   2 +
 include/uapi/linux/sctp.h  |  23 ++++++++
 net/sctp/socket.c          | 143 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 163 insertions(+), 5 deletions(-)

-- 
2.1.0

