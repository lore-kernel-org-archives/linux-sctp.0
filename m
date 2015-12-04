From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 04 Dec 2015 17:14:02 +0000
Subject: [PATCH net 0/3] sctp: packet timestamp fixes
Message-Id: <cover.1449249050.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20151203184316.GF4164@mrl.redhat.com>
In-Reply-To: <20151203184316.GF4164@mrl.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Eric Dumazet <eric.dumazet@gmail.com>, syzkaller <syzkaller@googlegroups.com>, linux-sctp@vger.kernel.org, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>, Dmitry Vyukov <dvyukov@google.com>

Hi,

These a couple of fixes regarding sctp/packet timestamps.

Dmitry Vyukov <dvyukov@google.com> reported the counter leak on missing
net_enable_timestamp() (2nd patch) and further testing here revealed the
other two issues.

Please consider these to -stable.

Thanks!

Marcelo Ricardo Leitner (3):
  sctp: use the same clock as if sock source timestamps were on
  sctp: update the netstamp_needed counter when copying sockets
  sctp: also copy sk_tsflags when copying the socket

 include/net/sock.h       | 2 ++
 net/core/sock.c          | 2 --
 net/sctp/sm_make_chunk.c | 4 ++--
 net/sctp/socket.c        | 4 ++++
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.5.0

