From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:05:31 +0000
Subject: [PATCH net 0/5] sctp: a bunch of fixes for stream reconfig
Message-Id: <cover.1511614961.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patchset is to make stream reset and asoc reset work more correctly
for stream reconfig.

Thank to Marcelo making them very clear.

Xin Long (5):
  sctp: use sizeof(__u16) for each stream number length instead of magic
    number
  sctp: only allow the out stream reset when the stream outq is empty
  sctp: only allow the asoc reset when the asoc outq is empty
  sctp: avoid flushing unsent queue when doing asoc reset
  sctp: set sender next_tsn for the old result with ctsn_ack_point plus
    1

 net/sctp/stream.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 12 deletions(-)

-- 
2.1.0

