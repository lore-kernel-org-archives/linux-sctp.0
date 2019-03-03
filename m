From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Mar 2019 09:54:52 +0000
Subject: [PATCH net 0/3] sctp: process the error returned from sctp_sock_migrate()
Message-Id: <cover.1551606805.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patchset is to process the errs returned by sctp_auth_init_hmacs()
and sctp_bind_addr_dup() from sctp_sock_migrate(). And also fix a panic
caused by new ep->auth_hmacs was not set due to net->sctp.auth_enable
changed by sysctl before accepting an assoc.

Xin Long (3):
  sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
  sctp: move up sctp_auth_init_hmacs() in sctp_endpoint_init()
  sctp: call sctp_auth_init_hmacs() in sctp_sock_migrate()

 net/sctp/auth.c        |  6 ------
 net/sctp/endpointola.c | 18 ++++++++++--------
 net/sctp/socket.c      | 44 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 44 insertions(+), 24 deletions(-)

-- 
2.1.0
