From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 24 Dec 2013 13:19:40 +0000
Subject: [RFC PATCH net-next 0/3] sctp accept socket fix
Message-Id: <1387891183-21169-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

lksctp-tools test suite seems to work just fine with this set.

Found a bit of time, so I continued on this, still on TODO for after Xmas:

  - Peeled-off sockets, shall we treat them just like accepted sockets
    and do a flat copy here, or do we want to avoid this for some reasons?
  - Polish up commit messages, further stress tests

Daniel Borkmann (3):
  net: sock: introduce sock_sanitize
  net: sock: add sk_copy_sanitize for use in modules
  net: sctp: use sk_copy_sanitize for accept sockets

 include/net/sctp/sctp.h |   4 +-
 include/net/sock.h      |   1 +
 net/core/sock.c         | 197 ++++++++++++++++++++++++++----------------------
 net/sctp/ipv6.c         |  11 ++-
 net/sctp/protocol.c     |  13 ++--
 net/sctp/socket.c       | 102 +++++++++++++++----------
 6 files changed, 182 insertions(+), 146 deletions(-)

-- 
1.8.3.1

