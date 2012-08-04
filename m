From: Jan Ariyasu <jan.ariyasu@gmail.com>
Date: Sat, 04 Aug 2012 21:30:37 +0000
Subject: [PATCH 00/13] SCTP: Enable netns
Message-Id: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Ariyasu <jan.ariyasu@hp.com>

The following set of patches enable network-namespaces for the SCTP protocol.

The multitude of global parameters are stored in a net_generic
structure, and the bulk of the patches enable the protocol to access
the parameters on a per-namespace basis.  The first five patches
enable netns handling of the protocol, procfs and sysfs.

Signed-off-by: Jan Ariyasu <jan.ariyasu@hp.com>
---
