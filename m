From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 22 May 2017 16:35:47 +0000
Subject: [PATCH 0/5] net-SCTP: Adjustments for three function implementations
Message-Id: <2845df67-d35d-536a-0a53-b2eb83fe1ba5@users.sourceforge.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 22 May 2017 18:30:45 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Use kmalloc_array() in sctp_init()
  Delete an error message for a failed memory allocation in sctp_init()
  Fix a typo in a comment line in sctp_init()
  Improve a size determination in sctp_inetaddr_event()
  Adjust one function call together with a variable assignment

 net/sctp/protocol.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.13.0

