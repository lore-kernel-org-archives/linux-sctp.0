From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 12:05:58 +0000
Subject: [PATCH net 00/13] sctp: fix ignoring asoc_id for tcp-style sockets on some setsockopts
Message-Id: <cover.1552910681.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This is a patchset to fix ignoring asoc_id for tcp-style sockets on
some setsockopts, introduced by SCTP_CURRENT_ASSOC of the patchset:

  [net-next,00/24] sctp: support SCTP_FUTURE/CURRENT/ALL_ASSOC
  (https://patchwork.ozlabs.org/cover/1031706/)

As Marcelo suggested, we fix it on each setsockopt that is using
SCTP_CURRENT_ASSOC one by one by adding the check:

    if (sctp_style(sk, TCP))
        	xxx.xxx_assoc_id = SCTP_FUTURE_ASSOC;

so that assoc_id will be completely ingored for tcp-style socket on
setsockopts, and works as SCTP_FUTURE_ASSOC.

Marcelo Ricardo Leitner (1):
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_DEFAULT_SEND_PARAM sockopt

Xin Long (12):
  sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_DELAYED_SACK
    sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_DEFAULT_SNDINFO sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_CONTEXT
    sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_MAX_BURST
    sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_AUTH_KEY
    sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_AUTH_ACTIVE_KEY sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_AUTH_DELETE_KEY sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_AUTH_DEACTIVATE_KEY sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_DEFAULT_PRINFO sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_ENABLE_STREAM_RESET sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_EVENT sockopt
  sctp: fix ignoring asoc_id for tcp-style sockets on
    SCTP_STREAM_SCHEDULER sockopt

 net/sctp/socket.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

-- 
2.1.0
