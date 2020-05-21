From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:35 +0000
Subject: do a single memdup_user in sctp_setsockopt
Message-Id: <20200521174724.2635475-1-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hi all,

based on the review of Davids patch to do something similar I dusted off
the series I had started a few days ago to move the memdup_user or
copy_from_user from the inidividual sockopts into sctp_setsockopt,
which is done with one patch per option, so it might suit Marcelo's
taste a bit better.  I did not start any work on getsockopt.
