From: David Miller <davem@davemloft.net>
Date: Wed, 20 Apr 2011 04:47:02 +0000
Subject: Re: [PATCH net-next-2.6 1/8 v2] sctp: delete unused macro
Message-Id: <20110419.214702.27789384.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
	<4DAD1915.70503@cn.fujitsu.com>
	<4DAD1B61.6080504@cn.fujitsu.com>
In-Reply-To: <4DAD1B61.6080504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 13:19:29 +0800

> From: Shan Wei <shanwei@cn.fujitsu.com>
> 
> The macro never be used.
> And if needed, can use !sctp_chunk_is_data instead of.
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
