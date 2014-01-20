From: Wang Weidong <wangweidong1@huawei.com>
Date: Mon, 20 Jan 2014 11:27:25 +0000
Subject: [PATCH net-next 0/2] sctp: some small clean ups
Message-Id: <1390217247-9408-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com, davem@davemloft.net, vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

We have the macros in sctp.h, so use them for coding accordance
in sctp.

Wang Weidong (2):
  sctp: use sctp_local_bh_{disable|enable} instead
    local_bh_{disable|enable}
  sctp: use sctp_read_[un]lock instead of read_[un]lock

 net/sctp/endpointola.c   |  4 ++--
 net/sctp/input.c         | 10 +++++-----
 net/sctp/proc.c          | 12 ++++++------
 net/sctp/sm_make_chunk.c |  8 ++++----
 net/sctp/socket.c        |  8 ++++----
 5 files changed, 21 insertions(+), 21 deletions(-)

-- 
1.7.12


