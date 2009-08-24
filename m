From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 24 Aug 2009 14:38:42 +0000
Subject: Re: [PATCH] sctp: drop SHUTDOWN chunk if the TSN is less than the
Message-Id: <4A92A5F2.4030802@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A8F64D0.8000408@cn.fujitsu.com>
In-Reply-To: <4A8F64D0.8000408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> If Cumulative TSN Ack field of SHUTDOWN chunk is less than the
> Cumulative TSN Ack Point then drop the SHUTDOWN chunk.

Applied, thanks
-vlad
