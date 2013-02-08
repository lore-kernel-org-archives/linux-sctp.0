From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 08 Feb 2013 13:04:33 +0000
Subject: [PATCH net 0/2] two small fixes for sctp key usage
Message-Id: <cover.1360327229.git.dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Cryptographically used keys should be zeroed out when our session
ends resp. memory is freed, thus do not leave them somewhere in the
memory.

Daniel Borkmann (2):
  net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
  net: sctp: sctp_endpoint_free: zero out secret key data

 net/sctp/endpointola.c | 5 +++++
 net/sctp/socket.c      | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
1.7.11.7

