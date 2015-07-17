From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 17 Jul 2015 15:34:16 +0000
Subject: [PATCH v2 0/2] sctp: fix src address selection if using secondary address
Message-Id: <cover.1437145508.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

This series improves the way SCTP chooses its src address so that the
choosen one will always belong to the interface being used for output.

v1->v2:
 - split out the refactoring from the fix itself
 - Doing a full reverse routing as in v1 is not necessary. Only looking
   for the interface that has the address and comparing its number is
   enough.

Marcelo Ricardo Leitner (2):
  sctp: reduce indent level on sctp_v4_get_dst
  sctp: fix src address selection if using secondary addresses

 net/sctp/protocol.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

-- 
2.4.1

