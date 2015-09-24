From: Karl Heiss <kheiss@gmail.com>
Date: Thu, 24 Sep 2015 16:15:05 +0000
Subject: [PATCH net 0/2] sctp: Fix SCTP deadlock
Message-Id: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

These patches fix a deadlock during accept() of an SCTP connection.

The first patch fixes whitespace issues.

The second patch actually fixes the deadlock race.

Karl Heiss (2):
  sctp: Whitespace fix
  sctp: Prevent soft lockup when sctp_accept() is called during a
    timeout event

 net/sctp/sm_sideeffect.c |   44 ++++++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

