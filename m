From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 12 Sep 2019 03:45:23 +0000
Subject: [PATCH v2 net 0/3] fix memory leak for sctp_do_bind
Message-Id: <20190912040219.67517-1-maowenan@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
In-Reply-To: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Mao Wenan <maowenan@huawei.com>

First two patches are to do cleanup, remove redundant assignment,
and change return type of sctp_get_port_local.
Third patch is to fix memory leak for sctp_do_bind if failed
to bind address.

---
 v2: add one patch to change return type of sctp_get_port_local.
---
Mao Wenan (3):
  sctp: change return type of sctp_get_port_local
  sctp: remove redundant assignment when call sctp_get_port_local
  sctp: destroy bucket if failed to bind addr

 net/sctp/socket.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

-- 
2.20.1
