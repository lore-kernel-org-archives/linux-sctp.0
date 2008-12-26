From: David Miller <davem@davemloft.net>
Date: Fri, 26 Dec 2008 00:58:33 +0000
Subject: Re: [PATCH net-next 4/5] sctp: Avoid memory overflow while FWD-TSN
Message-Id: <20081225.165833.216057003.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
	<1229737672-28328-6-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1229737672-28328-6-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Dec 2008 20:47:51 -0500

> If FWD-TSN chunk is received with bad stream ID, the sctp will not do the
> validity check, this may cause memory overflow when overwrite the TSN of
> the stream ID.
> 
> The FORWARD-TSN chunk is like this:
> 
> FORWARD-TSN chunk
>   Type                       = 192
>   Flags                      = 0
>   Length                     = 172
>   NewTSN                     = 99
>   Stream                     = 10000
>   StreamSequence             = 0xFFFF
> 
> This patch fix this problem by discard the chunk if stream ID is not
> less than MIS.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied and queued up for -stable.
