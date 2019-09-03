From: Baolin Wang <baolin.wang@linaro.org>
Date: Tue, 03 Sep 2019 06:53:46 +0000
Subject: [BACKPORT 4.14.y 0/8] Candidates from Spreadtrum 4.14 product kernel
Message-Id: <cover.1567492316.git.baolin.wang@linaro.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stable@vger.kernel.org, chris@chris-wilson.co.uk, airlied@linux.ie, davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com, peterz@infradead.org, mingo@redhat.com, vyasevich@gmail.com, nhorman@tuxdriver.com, linus.walleij@linaro.org, natechancellor@gmail.com, sre@kernel.org, paulus@samba.org, gregkh@linuxfoundation.org
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, longman@redhat.com, hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org, linux-gpio@vger.kernel.org, david@lechnology.com, linux-pm@vger.kernel.org, ebiggers@google.com, linux-ppp@vger.kernel.org, lanqing.liu@unisoc.com, linux-serial@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org, orsonzhai@gmail.com, vincent.guittot@linaro.org, linux-kernel@vger.kernel.org

With Arnd's script [1] help, I found some bugfixes in Spreadtrum 4.14 product
kernel, but missing in v4.14.141:

86fda90ab588 net: sctp: fix warning "NULL check before some freeing functions is not needed"
25a09ce79639 ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
d9b308b1f8a1 drm/i915/fbdev: Actually configure untiled displays
47d3d7fdb10a ip6: fix skb leak in ip6frag_expire_frag_queue()
5b9cea15a3de serial: sprd: Modify the baud rate calculation formula
513e1073d52e locking/lockdep: Add debug_locks check in __lock_downgrade()
957063c92473 pinctrl: sprd: Use define directive for sprd_pinconf_params values
87a2b65fc855 power: supply: sysfs: ratelimit property read error message

[1] https://lore.kernel.org/lkml/20190322154425.3852517-19-arnd@arndb.de/T/

Chris Wilson (1):
  drm/i915/fbdev: Actually configure untiled displays

David Lechner (1):
  power: supply: sysfs: ratelimit property read error message

Eric Biggers (1):
  ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"

Eric Dumazet (1):
  ip6: fix skb leak in ip6frag_expire_frag_queue()

Hariprasad Kelam (1):
  net: sctp: fix warning "NULL check before some freeing functions is
    not needed"

Lanqing Liu (1):
  serial: sprd: Modify the baud rate calculation formula

Nathan Chancellor (1):
  pinctrl: sprd: Use define directive for sprd_pinconf_params values

Waiman Long (1):
  locking/lockdep: Add debug_locks check in __lock_downgrade()

 drivers/gpu/drm/i915/intel_fbdev.c        |   12 +++++++-----
 drivers/net/ppp/ppp_mppe.c                |    1 -
 drivers/pinctrl/sprd/pinctrl-sprd.c       |    6 ++----
 drivers/power/supply/power_supply_sysfs.c |    3 ++-
 drivers/tty/serial/sprd_serial.c          |    2 +-
 include/net/ipv6_frag.h                   |    1 -
 kernel/locking/lockdep.c                  |    3 +++
 net/sctp/sm_make_chunk.c                  |   12 ++++--------
 8 files changed, 19 insertions(+), 21 deletions(-)

-- 
1.7.9.5
