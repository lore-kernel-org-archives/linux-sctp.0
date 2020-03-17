From: David Miller <davem@davemloft.net>
Date: Tue, 17 Mar 2020 01:25:10 +0000
Subject: Re: [PATCH] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200316.182510.943116149103375831.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
In-Reply-To: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hqjagain@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>
Date: Mon, 16 Mar 2020 11:53:24 +0800

> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk.
> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

SCTP folks, please review.
