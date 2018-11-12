From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Nov 2018 16:26:41 +0000
Subject: [PATCH net-next 0/4] sctp: add subscribe per asoc and sockopt SCTP_EVENT
Message-Id: <cover.1542039672.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset mainly adds the Event Subscription sockopt described in
rfc6525#section-6.2:

Subscribing to events as described in [RFC6458] uses a setsockopt()
call with the SCTP_EVENT socket option.  This option takes the
following structure, which specifies the association, the event type
(using the same value found in the event type field), and an on/off
boolean.

  struct sctp_event {
    sctp_assoc_t se_assoc_id;
    uint16_t     se_type;
    uint8_t      se_on;
  };

The user fills in the se_type field with the same value found in the
strreset_type field, i.e., SCTP_STREAM_RESET_EVENT.  The user will
also fill in the se_assoc_id field with either the association to set
this event on (this field is ignored for one-to-one style sockets) or
one of the reserved constant values defined in [RFC6458].  Finally,
the se_on field is set with a 1 to enable the event or a 0 to disable
the event.

As for the old SCTP_EVENTS Option with struct sctp_event_subscribe,
it's being DEPRECATED.

Xin Long (4):
  sctp: define subscribe in sctp_sock as __u16
  sctp: add subscribe per asoc
  sctp: rename enum sctp_event to sctp_event_type
  sctp: add sockopt SCTP_EVENT

 include/net/sctp/constants.h |   2 +-
 include/net/sctp/sm.h        |   4 +-
 include/net/sctp/structs.h   |   4 +-
 include/net/sctp/ulpevent.h  |  39 ++++++++------
 include/uapi/linux/sctp.h    |  13 ++++-
 net/sctp/associola.c         |   2 +
 net/sctp/chunk.c             |   8 ++-
 net/sctp/primitive.c         |   2 +-
 net/sctp/sm_sideeffect.c     |  12 ++---
 net/sctp/sm_statetable.c     |   2 +-
 net/sctp/socket.c            | 126 ++++++++++++++++++++++++++++++++++++++++---
 net/sctp/stream_interleave.c |  12 +++--
 net/sctp/ulpqueue.c          |   8 +--
 13 files changed, 184 insertions(+), 50 deletions(-)

-- 
2.1.0
