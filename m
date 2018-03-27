From: David Miller <davem@davemloft.net>
Date: Tue, 27 Mar 2018 14:22:36 +0000
Subject: Re: [PATCH net] sctp: remove unnecessary asoc in sctp_has_association
Message-Id: <20180327.102236.313919266340860945.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <955d9f51fafeb670cb4468e6253f4e54cd3c90f0.1522054500.git.lucien.xin@gmail.com>
In-Reply-To: <955d9f51fafeb670cb4468e6253f4e54cd3c90f0.1522054500.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Mar 2018 16:55:00 +0800

> After Commit dae399d7fdee ("sctp: hold transport instead of assoc
> when lookup assoc in rx path"), it put transport instead of asoc
> in sctp_has_association. Variable 'asoc' is not used any more.
> 
> So this patch is to remove it, while at it,  it also changes the
> return type of sctp_has_association to bool, and does the same
> for it's caller sctp_endpoint_is_peeled_off.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Since this is just a cleanup and a simplification, and doesn't fix
any bugs, I'm applying this to net-next.

Thanks.
