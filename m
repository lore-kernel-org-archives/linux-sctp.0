From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 20 Jan 2017 18:00:34 +0000
Subject: [PATCHv4 net-next 0/5] sctp: add sender-side procedures for stream reconf asoc reset and add streams
Message-Id: <cover.1484934853.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

Patch 3/5 is to implement sender-side procedures for the SSN/TSN Reset
Request Parameter described in rfc6525 section 5.1.4, patch 2/5 is
ahead of it to define a function to make the request chunk for it.

Patch 5/5 is to implement sender-side procedures for the Add Incoming
and Outgoing Streams Request Parameter Request Parameter described in
rfc6525 section 5.1.5 and 5.1.6, patch 4/5 is ahead of it to define a
function to make the request chunk for it.

Patch 1/5 is a fix to make streams be closed only when request is sent
successfully.

v1->v2:
  - put these into a smaller group.
  - rename some temporary variables in the codes.
  - rename the titles of the commits and improve some changelogs.
v2->v3:
  - re-split the patchset and make sure it has no dead codes for review.
  - move some codes into stream.c from socket.c.
v3->v4:
  - add one more patch to fix a send reset stream request issue.
  - doing actual work only when request is sent successfully.
  - reduce some indents in sctp_send_add_streams.

Xin Long (5):
  sctp: streams should be closed when stream reset request is sent
    successfully.
  sctp: add support for generating stream reconf ssn/tsn reset request
    chunk
  sctp: implement sender-side procedures for SSN/TSN Reset Request
    Parameter
  sctp: add support for generating stream reconf add incoming/outgoing
    streams request chunk
  sctp: implement sender-side procedures for Add Incoming/Outgoing
    Streams Request Parameter

 include/linux/sctp.h      |  12 +++++
 include/net/sctp/sctp.h   |   3 ++
 include/net/sctp/sm.h     |   5 ++
 include/uapi/linux/sctp.h |   8 +++
 net/sctp/sm_make_chunk.c  |  75 ++++++++++++++++++++++++++++
 net/sctp/socket.c         |  58 ++++++++++++++++++++++
 net/sctp/stream.c         | 124 +++++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 284 insertions(+), 1 deletion(-)

-- 
2.1.0

