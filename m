From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 03 Jun 2008 15:41:00 +0000
Subject: Re: [PATCH] SCTP: Move sctp_v4_dst_saddr out of loop
Message-Id: <4845660C.2030200@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4844D993.7090705@cn.fujitsu.com>
In-Reply-To: <4844D993.7090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>

Hi Gui

Gui Jianfeng wrote:
> There's no need to execute sctp_v4_dst_saddr() for each
> iteration, just move it out of loop.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

I'll put this in the set that I am getting ready to submit.

-vlad
