From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 07 Jun 2013 08:35:03 +0000
Subject: [PATCH net-next 0/3] Minor sctp cleanups
Message-Id: <1370594106-25745-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Daniel Borkmann (3):
  net: sctp: let sctp_destroy_sock destroy related members
  net: sctp: sctp_association_init: hold refs in reverse order
  net: sctp: minor: remove variable in sctp_init_sock

 net/sctp/associola.c   |  5 ++---
 net/sctp/endpointola.c |  7 -------
 net/sctp/socket.c      | 15 +++++++++++----
 3 files changed, 13 insertions(+), 14 deletions(-)

-- 
1.7.11.7

