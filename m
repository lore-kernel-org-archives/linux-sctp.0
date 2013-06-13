From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 13 Jun 2013 16:04:19 +0000
Subject: [PATCH net-next 0/4] Some SCTP cleanups/improvements
Message-Id: <1371139463-12512-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

v1 -> v2:
  - Apply Neil's feedback, I'll send out the first patch at a later
    point in time though, have not included it in this set
  - Add two other patches that appear to be useful from the last
    couple of days debugging SCTP code

Daniel Borkmann (4):
  net: sctp: throw BUG if primary_path in sctp_seq_dump_local_addrs is NULL
  net: sctp: sctp_sf_do_prm_asoc: do SCTP_CMD_INIT_CHOOSE_TRANSPORT first
  net: sctp: minor: remove variable in sctp_init_sock
  net: sctp: sctp_association_init: put refs in reverse order on error

 net/sctp/associola.c    |  7 +++----
 net/sctp/proc.c         | 15 ++++++++++++---
 net/sctp/sm_statefuns.c |  8 ++++----
 net/sctp/socket.c       |  6 ++----
 4 files changed, 21 insertions(+), 15 deletions(-)

-- 
1.7.11.7

