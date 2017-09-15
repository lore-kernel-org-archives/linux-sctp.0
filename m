From: David Miller <davem@davemloft.net>
Date: Fri, 15 Sep 2017 21:51:34 +0000
Subject: Re: [PATCH net] sctp: do not mark sk dumped when inet_sctp_diag_fill returns err
Message-Id: <20170915.145134.235758682095715785.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <c5398945d4e80ed8b8497675dd0449763fec4eec.1505444568.git.lucien.xin@gmail.com>
In-Reply-To: <c5398945d4e80ed8b8497675dd0449763fec4eec.1505444568.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 15 Sep 2017 11:02:48 +0800

> sctp_diag would not actually dump out sk/asoc if inet_sctp_diag_fill
> returns err, in which case it shouldn't mark sk dumped by setting
> cb->args[3] as 1 in sctp_sock_dump().
> 
> Otherwise, it could cause some asocs to have no parent's sk dumped
> in 'ss --sctp'.
> 
> So this patch is to not set cb->args[3] when inet_sctp_diag_fill()
> returns err in sctp_sock_dump().
> 
> Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
