From: David Miller <davem@davemloft.net>
Date: Mon, 03 Dec 2018 23:55:16 +0000
Subject: Re: [PATCH net] sctp: kfree_rcu asoc
Message-Id: <20181203.155516.1922731498178619066.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cbb02c228ba4d3500580bf1fe0792a3b5561517b.1543599419.git.lucien.xin@gmail.com>
In-Reply-To: <cbb02c228ba4d3500580bf1fe0792a3b5561517b.1543599419.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  1 Dec 2018 01:36:59 +0800

> In sctp_hash_transport/sctp_epaddr_lookup_transport, it dereferences
> a transport's asoc under rcu_read_lock while asoc is freed not after
> a grace period, which leads to a use-after-free panic.
> 
> This patch fixes it by calling kfree_rcu to make asoc be freed after
> a grace period.
> 
> Note that only the asoc's memory is delayed to free in the patch, it
> won't cause sk to linger longer.
> 
> Thanks Neil and Marcelo to make this clear.
> 
> Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
> Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
> Reported-by: syzbot+0b05d8aa7cb185107483@syzkaller.appspotmail.com
> Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
> Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
