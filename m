From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:37 +0000
Subject: do a single memdup_user in sctp_setsockopt v2
Message-Id: <20200719072228.112645-1-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hi all,

here is a resend of my series to lift the copy_from_user out of the
individual sctp sockopt handlers into the main sctp_setsockopt
routine.


Changes since v1:
 - fixes a few sizeof calls.
 - use memzero_explicit in sctp_setsockopt_auth_key instead of special
   casing it for a kzfree in the caller
 - remove some minor cleanups from sctp_setsockopt_autoclose to keep
   it closer to the existing version
 - add another little only vaguely related cleanup patch
