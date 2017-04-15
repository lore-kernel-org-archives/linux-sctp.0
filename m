From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 15 Apr 2017 14:00:26 +0000
Subject: [PATCH net-next 0/3] sctp: add proper process for duplicated stream reconf requests
Message-Id: <cover.1492264734.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Now sctp stream reconf will process a request again even if it's seqno
is less than asoc->strreset_inseq. It may cause a replay attack.

This patchset is to avoid it by add proper process for all duplicated
stream reconf requests.

Xin Long (3):
  sctp: process duplicated strreset out and addstrm out requests
    correctly
  sctp: process duplicated strreset in and addstrm in requests correctly
  sctp: process duplicated strreset asoc request correctly

 include/net/sctp/structs.h |  1 +
 net/sctp/stream.c          | 96 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 74 insertions(+), 23 deletions(-)

-- 
2.1.0

