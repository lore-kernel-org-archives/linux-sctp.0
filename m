From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Thu, 25 Feb 2016 07:07:07 +0000
Subject: [PATCH 0/4] Convert network timestamps to be y2038 safe
Message-Id: <1456384031-29244-1-git-send-email-deepa.kernel@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, y2038@lists.linaro.org
Cc: arnd@arndb.de, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-sctp@vger.kernel.org

Introduction:

The series is aimed at transitioning network timestamps to being
y2038 safe.
All patches can be reviewed and merged independently, except for
the [PATCH 2/4], which is dependent on the [PATCH 1/4].

Socket timestamps and ioctl calls will be handled separately.

Thanks to Arnd Bergmann for discussing solution options with me.

Solution:

Data type struct timespec is not y2038 safe.
Replace timespec with struct timespec64 which is y2038 safe.

Deepa Dinamani (4):
  kernel: time: Add current_nw_timestamp() for network timestamps
  net: ipv4: Use y2038 safe functions and data structures
  net: ipv4: tcp_probe: Replace timespec with timespec64
  net: sctp: Convert log timestamps to be y2038 safe

 include/linux/ip.h     |  2 ++
 include/linux/time64.h |  3 +++
 kernel/time/time.c     | 26 ++++++++++++++++++++++++++
 net/ipv4/icmp.c        |  5 +----
 net/ipv4/ip_options.c  | 13 +++++--------
 net/ipv4/tcp_probe.c   |  8 ++++----
 net/sctp/probe.c       | 10 +++++-----
 7 files changed, 46 insertions(+), 21 deletions(-)

-- 
1.9.1

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-sctp@vger.kernel.org
