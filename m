From: David Miller <davem@davemloft.net>
Date: Wed, 20 Apr 2011 04:47:41 +0000
Subject: Re: [PATCH net-next-2.6 7/8] sctp: Allow bindx_del to accept 0 port
Message-Id: <20110419.214741.13766667.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
	<4DAD1A47.5080007@cn.fujitsu.com>
In-Reply-To: <4DAD1A47.5080007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 13:14:47 +0800

> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> We allow 0 port when adding new addresses.  It only
> makes sence to allow 0 port when removing addresses.
> When removing the currently bound port will be used
> when the port in the address is set to 0.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
