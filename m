From: David Miller <davem@davemloft.net>
Date: Wed, 13 Apr 2011 02:34:06 +0000
Subject: Re: [PATCH] sctp: fix oops while removed transport still using as
Message-Id: <20110412.193406.112617933.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DA4FA70.50506@cn.fujitsu.com>
	<4DA4FACE.5060706@cn.fujitsu.com>
In-Reply-To: <4DA4FACE.5060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 13 Apr 2011 09:22:22 +0800

> Since we can not update retran path to unconfirmed transports,
> when we remove a peer, the retran path may not be update if the
> other transports are all unconfirmed, and we will still using
> the removed transport as the retran path. This may cause panic
> if retrasnmit happen.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
