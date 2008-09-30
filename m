From: David Miller <davem@davemloft.net>
Date: Tue, 30 Sep 2008 12:33:31 +0000
Subject: Re: [PATCH] sctp: Fix kernel panic while process protocol
Message-Id: <20080930.053331.193692654.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1222377260-11088-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1222377260-11088-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 25 Sep 2008 17:14:20 -0400

> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> Since call to function sctp_sf_abort_violation() need paramter 'arg' with
> 'struct sctp_chunk' type, it will read the chunk type and chunk length from
> the chunk_hdr member of chunk. But call to sctp_sf_violation_paramlen()
> always with 'struct sctp_paramhdr' type's parameter, it will be passed to
> sctp_sf_abort_violation(). This may cause kernel panic.
> 
>    sctp_sf_violation_paramlen()
>      |-- sctp_sf_abort_violation()
>         |-- sctp_make_abort_violation()
> 
> This patch fixed this problem. This patch also fix two place which called
> sctp_sf_violation_paramlen() with wrong paramter type.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied to net-2.6, thanks.
