From: David Miller <davem@davemloft.net>
Date: Sun, 04 Nov 2018 02:41:18 +0000
Subject: Re: [PATCH net] sctp: define SCTP_SS_DEFAULT for Stream schedulers
Message-Id: <20181103.194118.1130202147748232277.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4986625e9c58cccdfbb6c809a82c77a83b57a541.1541224891.git.lucien.xin@gmail.com>
In-Reply-To: <4986625e9c58cccdfbb6c809a82c77a83b57a541.1541224891.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  3 Nov 2018 14:01:31 +0800

> According to rfc8260#section-4.3.2, SCTP_SS_DEFAULT is required to
> defined as SCTP_SS_FCFS or SCTP_SS_RR.
> 
> SCTP_SS_FCFS is used for SCTP_SS_DEFAULT's value in this patch.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied and queued up for -stable.

Thanks.
