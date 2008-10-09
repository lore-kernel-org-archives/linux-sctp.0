From: David Miller <davem@davemloft.net>
Date: Thu, 09 Oct 2008 21:33:34 +0000
Subject: Re: [PATCH net-next 3/3] sctp: update SNMP statiscts when T5 timer
Message-Id: <20081009.143334.141756059.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
	<1223558975-1550-5-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223558975-1550-5-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu,  9 Oct 2008 09:29:35 -0400

> The T5 timer is the timer for the over-all shutdown procedure.  If
> this timer expires, then shutdown procedure has not completed and we
> ABORT the association.  We should update SCTP_MIB_ABORTED and
> SCTP_MIB_CURRESTAB  when aborting.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Also applied, thanks.
