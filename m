From: David Miller <davem@davemloft.net>
Date: Thu, 09 Oct 2008 21:32:37 +0000
Subject: Re: [PATCH net-next 1/3] sctp: Fix the SNMP number of
Message-Id: <20081009.143237.155401326.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
	<1223558975-1550-3-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223558975-1550-3-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu,  9 Oct 2008 09:29:33 -0400

> RFC3873 defined SCTP_MIB_CURRESTAB:
>   sctpCurrEstab OBJECT-TYPE
>     SYNTAX         Gauge32
>     MAX-ACCESS     read-only
>     STATUS         current
>     DESCRIPTION
>          "The number of associations for which the current state is
>          either ESTABLISHED, SHUTDOWN-RECEIVED or SHUTDOWN-PENDING."
>     REFERENCE
>          "Section 4 in RFC2960 covers the SCTP   Association state
>          diagram."
> 
> If the T4 RTO timer expires many times(timeout), the association will enter
> CLOSED state, so we should dec the number of SCTP_MIB_CURRESTAB, not inc the
> number of SCTP_MIB_CURRESTAB.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
