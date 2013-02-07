From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 07 Feb 2013 10:55:35 +0000
Subject: [PATCH net 0/2] fixes for net/sctp/auth.c
Message-Id: <cover.1360231701.git.dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

This set fixes two issues in the net/sctp/auth.c implementation.

Daniel Borkmann (2):
  net: sctp: sctp_auth_make_key_vector: fix undefined ref-count behaviour
  net: sctp: sctp_auth_key_put: use kzfree instead of kfree

 net/sctp/auth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
1.7.11.7

