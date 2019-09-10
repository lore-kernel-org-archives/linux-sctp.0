From: Mao Wenan <maowenan@huawei.com>
Date: Tue, 10 Sep 2019 06:56:39 +0000
Subject: [PATCH net 0/2] fix memory leak for sctp_do_bind
Message-Id: <20190910071343.18808-1-maowenan@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Mao Wenan <maowenan@huawei.com>

First patch is to do cleanup, remove redundant assignment,
second patch is to fix memory leak for sctp_do_bind if failed
to bind address.

Mao Wenan (2):
  sctp: remove redundant assignment when call sctp_get_port_local
  sctp: destroy bucket if failed to bind addr

 net/sctp/socket.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.20.1
