From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 Sep 2015 19:20:20 +0000
Subject: [PATCH net 0/2] couple of sctp fixes for 0ca50d12fe46
Message-Id: <cover.1441220305.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

These are two fixes for sctp after my patch on 0ca50d12fe46 ("sctp: fix
src address selection if using secondary addresses")

The first, fix a dst leak on those it decided to skip.

The second, adds the fallback on src selection that Vlad had asked
about. Unfortunatelly a lot of ipvs setups relies on the old behavior
and I don't see a better fix for it.

Please consider both to -stable tree.

Thanks!

Marcelo Ricardo Leitner (2):
  sctp: fix dst leak
  sctp: add routing output fallback

 net/sctp/protocol.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.4.3

