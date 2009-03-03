From: David Miller <davem@davemloft.net>
Date: Tue, 03 Mar 2009 06:29:08 +0000
Subject: Re: [PATCH 2/2] sctp: fix kernel panic with ERROR chunk containing
Message-Id: <20090302.222908.180790085.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1236012411-17841-3-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1236012411-17841-3-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon,  2 Mar 2009 11:46:51 -0500

> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> If ERROR chunk is received with too many error causes in ESTABLISHED
> state, the kernel get panic.
> 
> This is because sctp limit the max length of cmds to 14, but while
> ERROR chunk is received, one error cause will add around 2 cmds by
> sctp_add_cmd_sf(). So many error causes will fill the limit of cmds
> and panic.
> 
> This patch fixed the problem.
> 
> This bug can be test by SCTP Conformance Test Suite
> <http://networktest.sourceforge.net/>.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
