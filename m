From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 01 May 2017 13:30:25 +0000
Subject: [PATCH 0/3] net-SCTP: Fine-tuning for six function implementations
Message-Id: <ea9206ca-2a2f-095e-d764-3f819610d5e8@users.sourceforge.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 May 2017 15:25:05 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Replace six seq_printf() calls by seq_putc()
  Combine two seq_printf() calls into one call in sctp_remaddr_seq_show()
  Replace four seq_printf() calls by seq_puts()

 net/sctp/proc.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

-- 
2.12.2

