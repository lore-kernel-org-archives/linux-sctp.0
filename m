From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 30 Sep 2015 11:26:30 +0000
Subject: [PATCH 00/12] net: assorted y2038 changes
Message-Id: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org, netfilter-devel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>

Hi everyone,

This is a set of changes for network drivers and core code to
get rid of the use of time_t and derived data structures.

I have a longer set of patches that enables me to build kernels
with the time_t definition removed completely as a help to find
y2038 overflow issues. This is the subset for networking that
contains all code that has a reasonable way of fixing at the
moment and that is either commonly used (in one of the defconfigs)
or that blocks building a whole subsystem.

Most of the patches in this series should be noncontroversial,
but the last two that I marked [RFC] are a bit tricky and
need input from people that are more familiar with the code than
I am. All 12 patches are independent of one another and can
be applied in any order, so feel free to pick all that look
good.

Patches that are not included here are:

 - disabling less common device drivers that I don't have a fix
   for yet, this includes
	drivers/net/ethernet/brocade/bna/bfa_ioc.c
	drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
	drivers/net/ethernet/tile/tilegx.c
	drivers/net/hamradio/baycom_ser_fdx.c
	drivers/net/wireless/ath/ath10k/core.h
	drivers/net/wireless/ath/ath9k/
	drivers/net/wireless/ath/ath9k/
	drivers/net/wireless/atmel.c
	drivers/net/wireless/prism54/isl_38xx.c
	drivers/net/wireless/rt2x00/rt2x00debug.c
	drivers/net/wireless/rtlwifi/
	drivers/net/wireless/ti/wlcore/
	drivers/staging/ozwpan/
	net/atm/mpoa_caches.c
	net/atm/mpoa_proc.c
	net/dccp/probe.c
	net/ipv4/tcp_probe.c
	net/netfilter/nfnetlink_queue_core.c
	net/netfilter/nfnetlink_queue_core.c
	net/netfilter/xt_time.c
	net/openvswitch/flow.c
	net/sctp/probe.c
	net/sunrpc/auth_gss/
	net/sunrpc/svcauth_unix.c
	net/vmw_vsock/af_vsock.c
   We'll get there eventually, or we an add a dependency to ensure
   they are not built on 32-bit kernels that need to survive
   beyond 2038. Most of these should be really easy to fix.

 - recvmmsg/sendmmsg system calls: patches have been sent out
   as part of the syscall series, need a little more work and
   review

 - SIOCGSTAMP/SIOCGSTAMPNS/ ioctl calls: tricky, need to discuss
   with some folks at kernel summit

 - SO_RCVTIMEO/SO_SNDTIMEO/SO_TIMESTAMP/SO_TIMESTAMPNS socket
   opt: similar and related to the ioctl

 - mmapped packet socket: need to create v4 of the API, nontrivial

 - pktgen: sends 32-bit timestamps over network, need to find out
   if using unsigned stamps is good enough

 - af_rxpc: similar to pktgen, uses 32-bit times for deadlines

 - ppp ioctl: patch is being worked on, nontrivial but doable

	Arnd

Arnd Bergmann (12):
  net: fec: avoid timespec use
  net: stmmac: avoid using timespec
  net: igb: avoid using timespec
  mwifiex: use ktime_get_real for timestamping
  mwifiex: avoid gettimeofday in ba_threshold setting
  mac80211: use ktime_get_seconds
  atm: hide 'struct zatm_t_hist'
  nfnetlink: use y2038 safe timestamp
  ipv6: use ktime_t for internal timestamps
  net: sctp: avoid incorrect time_t use
  [RFC] ipv4: avoid timespec in timestamp computation
  [RFC] can: avoid using timeval for uapi

 drivers/net/ethernet/freescale/fec_ptp.c          |  6 ++--
 drivers/net/ethernet/intel/igb/igb.h              |  4 +--
 drivers/net/ethernet/intel/igb/igb_main.c         | 15 +++++-----
 drivers/net/ethernet/intel/igb/igb_ptp.c          |  8 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  8 ++++--
 drivers/net/wireless/mwifiex/11n_aggr.c           |  4 +--
 drivers/net/wireless/mwifiex/wmm.c                | 15 +++-------
 include/linux/timekeeping.h                       |  2 ++
 include/uapi/linux/atm_zatm.h                     |  3 +-
 include/uapi/linux/can/bcm.h                      |  7 ++++-
 kernel/time/timekeeping.c                         | 34 +++++++++++++++++++++++
 net/can/bcm.c                                     | 15 ++++++----
 net/ipv4/icmp.c                                   |  8 ++----
 net/ipv4/ip_options.c                             |  9 ++----
 net/ipv6/mip6.c                                   | 16 +++++------
 net/mac80211/sta_info.c                           |  8 ++----
 net/netfilter/nfnetlink_log.c                     |  6 ++--
 net/sctp/sm_make_chunk.c                          |  2 +-
 net/sctp/sm_statefuns.c                           |  2 +-
 19 files changed, 99 insertions(+), 73 deletions(-)

Cc: coreteam@netfilter.org
Cc: intel-wired-lan@lists.osuosl.org
Cc: linux-api@vger.kernel.org
Cc: linux-atm-general@lists.sourceforge.net
Cc: linux-can@vger.kernel.org
Cc: linux-sctp@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org


-- 
2.1.0.rc2

