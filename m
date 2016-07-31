From: David Miller <davem@davemloft.net>
Date: Sun, 31 Jul 2016 05:06:52 +0000
Subject: Re: [PATCH net] sctp: fix the issue sctp requeue auth chunk incorrectly
Message-Id: <20160730.220652.1863192062471461146.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <af1555c524101278be2e5b07ff78a1eaacc0f7bb.1469858315.git.lucien.xin@gmail.com>
In-Reply-To: <af1555c524101278be2e5b07ff78a1eaacc0f7bb.1469858315.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 30 Jul 2016 13:58:35 +0800

> sctp needs to queue auth chunk back when we know that we are going
> to generate another segment. But commit f1533cce60d1 ("sctp: fix
> panic when sending auth chunks") requeues the last chunk processed
> which is probably not the auth chunk.
> 
> It causes panic when calculating the MAC in sctp_auth_calculate_hmac(),
> as the incorrect offset of the auth chunk in skb->data.
> 
> This fix is to requeue it by using packet->auth.
> 
> Fixes: f1533cce60d1 ("sctp: fix panic when sending auth chunks")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
