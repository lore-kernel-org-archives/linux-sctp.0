From: David Miller <davem@davemloft.net>
Date: Wed, 20 Apr 2011 04:47:17 +0000
Subject: Re: [PATCH net-next-2.6 3/8] sctp: use common head of addr
Message-Id: <20110419.214717.241907437.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
	<4DAD1993.5070801@cn.fujitsu.com>
In-Reply-To: <4DAD1993.5070801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 13:11:47 +0800

> From: Shan Wei <shanwei@cn.fujitsu.com>
> 
> The 'p' member of struct sctp_paramhdr is common part for
> IPv4 addr parameter and IPv6 addr parameter in union sctp_addr_param.
> 
> For addr-related code, use specified addr parameter.
> Otherwise, use common header to access type/length member.
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
