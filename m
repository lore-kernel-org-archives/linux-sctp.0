From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 04 Sep 2009 19:25:18 +0000
Subject: Re: [PATCH 2/2] sctp: remove dup code in net/sctp/output.c
Message-Id: <4AA1699E.8010405@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4AA0B4DE.20404@cn.fujitsu.com>
In-Reply-To: <4AA0B4DE.20404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Use sctp_packet_reset() instead of dup code.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

applied

thanks
-vlad
