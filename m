From: Javier Martinez Canillas <javier@osg.samsung.com>
Date: Fri, 09 Sep 2016 12:43:12 +0000
Subject: [PATCH 0/8] net: use IS_ENABLED() instead of checking for built-in or module
Message-Id: <1473425000-9782-1-git-send-email-javier@osg.samsung.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, James Chapman <jchapman@katalix.com>, Alexander Duyck <aduyck@mirantis.com>, Vlad Yasevich <vyasevich@gmail.com>, Florian Westphal <fw@strlen.de>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Daniel Borkmann <daniel@iogearbox.net>, stephen hemminger <stephen@networkplumber.org>, Tom Herbert <tom@herbertland.com>, linux-sctp@vger.kernel.org, Antonio Quartulli <a@unstable.cc>, Jamal Hadi Salim <jhs@mojatatu.com>, Herbert Xu <herbert@gondor.apana.org.au>, Mugunthan V N <mugunthanvnm@ti.com>, Steffen Klassert <steffen.klassert@secunet.com>, Eric Dumazet <edumazet@google.com>, Felipe Balbi <felipe.balbi@linux.intel.com>, netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Jarod Wilson <jarod@redhat.com>, Patrick McHardy <kaber@trash.net>, Paolo Abeni <pabeni@redhat.com>, James Morris <jmorris@namei.org>

Hello David,

This trivial series replace the open coding to check for a Kconfig symbol
being built-in or module, with IS_ENABLED() macro that does exactly that.

Using the macro makes the code more readable by helping abstract away some
of the Kconfig built-in and module enable details.

Best regards,
Javier


Javier Martinez Canillas (8):
  appletalk: use IS_ENABLED() instead of checking for built-in or module
  lec: use IS_ENABLED() instead of checking for built-in or module
  net: use IS_ENABLED() instead of checking for built-in or module
  ipv4: use IS_ENABLED() instead of checking for built-in or module
  l2tp: use IS_ENABLED() instead of checking for built-in or module
  net: sched: use IS_ENABLED() instead of checking for built-in or
    module
  sctp: use IS_ENABLED() instead of checking for built-in or module
  xfrm: use IS_ENABLED() instead of checking for built-in or module

 net/appletalk/ddp.c  |  2 +-
 net/atm/lec.c        | 12 ++++++------
 net/core/dev.c       |  3 +--
 net/ipv4/ip_output.c |  2 +-
 net/l2tp/l2tp_core.h |  2 +-
 net/l2tp/l2tp_eth.c  |  4 ++--
 net/l2tp/l2tp_ppp.c  |  4 ++--
 net/sched/cls_flow.c |  6 +++---
 net/sctp/auth.c      |  2 +-
 net/xfrm/xfrm_algo.c |  2 +-
 10 files changed, 19 insertions(+), 20 deletions(-)

-- 
2.7.4

