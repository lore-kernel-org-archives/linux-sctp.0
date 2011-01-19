From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 19 Jan 2011 07:23:36 +0000
Subject: Re: [PATCH] sctp: Make some local functions static
Message-Id: <4D369178.7060207@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D35798E.3010800@selfish.org>
In-Reply-To: <4D35798E.3010800@selfish.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> sparse proposed to mark these functions as static as they are
> only accessed locally. This patch is doing that.

It is OK to me.

Acked-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Would your please send patch inline and cc to David and netdev@vger.kernel.org? thanks

> Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
> ---
>  net/sctp/probe.c         |   10 +++++-----
>  net/sctp/sm_make_chunk.c |    4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
>
