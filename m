From: Phil Sutter <phil@nwl.cc>
Date: Thu, 04 Aug 2016 10:11:54 +0000
Subject: [PATCH v3 0/3] sctp_diag: A bunch of fixes for upcoming 'ss' support
Message-Id: <1470305517-31880-1-git-send-email-phil@nwl.cc>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

The following series contains a number of fixes necessary to make my yet
unpublished 'ss' support patch functional.

Changes since v1:
- Fixed patch 2/3
- Rebased whole series onto current net-next/master

Changes since v2:
- Improved description of patch 2/3

Phil Sutter (3):
  sctp: Export struct sctp_info to userspace
  sctp_diag: Fix T3_rtx timer export
  sctp_diag: Respect ss adding TCPF_CLOSE to idiag_states

 include/linux/sctp.h      | 64 -----------------------------------------------
 include/uapi/linux/sctp.h | 64 +++++++++++++++++++++++++++++++++++++++++++++++
 net/sctp/sctp_diag.c      | 18 ++++++++-----
 3 files changed, 76 insertions(+), 70 deletions(-)

-- 
2.8.2

