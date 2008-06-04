From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jun 2008 19:37:43 +0000
Subject: Re: [PATCH 1/6] SCTP: retran_path update bug fix
Message-Id: <20080604.123743.54863058.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
	<1212603951-24932-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, guijianfeng@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  4 Jun 2008 14:25:46 -0400

> If the current retran_path is the only active one, it should
> update it to the the next inactive one.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
