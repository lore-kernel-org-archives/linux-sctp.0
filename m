From: David Miller <davem@davemloft.net>
Date: Sat, 14 Nov 2009 03:57:17 +0000
Subject: Re: [PATCH] sctp: Fix regression introduced by new sctp_connectx
Message-Id: <20091113.195717.177244655.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1257963564-26376-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1257963564-26376-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 11 Nov 2009 13:19:24 -0500

> A new (unrealeased to the user) sctp_connectx api
> 
> c6ba68a26645dbc5029a9faa5687ebe6fcfc53e4
>     sctp: support non-blocking version of the new sctp_connectx() API
> 
> introduced a regression cought by the user regression test
> suite.  In particular, the API requires the user library to
> re-allocate the buffer and could potentially trigger a SIGFAULT.
> 
> This change corrects that regression by passing the original
> address buffer to the kernel unmodified, but still allows for
> a returned association id.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
