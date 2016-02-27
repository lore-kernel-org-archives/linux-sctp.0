From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sat, 27 Feb 2016 08:32:14 +0000
Subject: [PATCH v2 0/3] Convert network timestamps to be y2038 safe
Message-Id: <1456561938-7653-1-git-send-email-deepa.kernel@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, y2038@lists.linaro.org
Cc: arnd@arndb.de, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, linux-sctp@vger.kernel.org

Introduction:

The series is aimed at transitioning network timestamps to being
y2038 safe.
All patches can be reviewed and merged independently.

Socket timestamps and ioctl calls will be handled separately.

Thanks to Arnd Bergmann for discussing solution options with me.

Solution:

Data type struct timespec is not y2038 safe.
Replace timespec with struct timespec64 which is y2038 safe.

Changes v1 -> v2: 
  Move and rename inet_current_time() as discussed
  Squash patches 1 and 2
  Reword commit text for patch 2/3
  Carry over review tags

Deepa Dinamani (3):
  net: ipv4: Convert IP network timestamps to be y2038 safe
  net: ipv4: tcp_probe: Replace timespec with timespec64
  net: sctp: Convert log timestamps to be y2038 safe

 include/net/ip.h      |  2 ++
 net/ipv4/af_inet.c    | 26 ++++++++++++++++++++++++++
 net/ipv4/icmp.c       |  5 +----
 net/ipv4/ip_options.c | 14 ++++++--------
 net/ipv4/tcp_probe.c  |  8 ++++----
 net/sctp/probe.c      | 10 +++++-----
 6 files changed, 44 insertions(+), 21 deletions(-)

-- 
1.9.1

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: linux-sctp@vger.kernel.org
