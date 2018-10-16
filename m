From: David Miller <davem@davemloft.net>
Date: Tue, 16 Oct 2018 16:59:18 +0000
Subject: Re: [PATCH net] sctp: get pr_assoc and pr_stream all status with SCTP_PR_SCTP_ALL instead
Message-Id: <20181016.095918.2016842324386473147.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <e1b1741db983e1775312816bc2e6f0f685f9828d.1539676322.git.lucien.xin@gmail.com>
In-Reply-To: <e1b1741db983e1775312816bc2e6f0f685f9828d.1539676322.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 16 Oct 2018 15:52:02 +0800

> According to rfc7496 section 4.3 or 4.4:
> 
>    sprstat_policy:  This parameter indicates for which PR-SCTP policy
>       the user wants the information.  It is an error to use
>       SCTP_PR_SCTP_NONE in sprstat_policy.  If SCTP_PR_SCTP_ALL is used,
>       the counters provided are aggregated over all supported policies.
> 
> We change to dump pr_assoc and pr_stream all status by SCTP_PR_SCTP_ALL
> instead, and return error for SCTP_PR_SCTP_NONE, as it also said "It is
> an error to use SCTP_PR_SCTP_NONE in sprstat_policy. "
> 
> Fixes: 826d253d57b1 ("sctp: add SCTP_PR_ASSOC_STATUS on sctp sockopt")
> Fixes: d229d48d183f ("sctp: add SCTP_PR_STREAM_STATUS sockopt for prsctp")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
