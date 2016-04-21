From: David Miller <davem@davemloft.net>
Date: Thu, 21 Apr 2016 17:56:13 +0000
Subject: Re: [PATCHv3 net-next] net: use jiffies_to_msecs to replace EXPIRES_IN_MS in inet/sctp_diag
Message-Id: <20160421.135613.237170463938906762.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <87a0e83132ce64a3fe2266a5323fa6577a2e5c96.1461049801.git.lucien.xin@gmail.com>
In-Reply-To: <87a0e83132ce64a3fe2266a5323fa6577a2e5c96.1461049801.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net, eric.dumazet@gmail.com, jsitnick@redhat.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 19 Apr 2016 15:10:01 +0800

> EXPIRES_IN_MS macro comes from net/ipv4/inet_diag.c and dates
> back to before jiffies_to_msecs() has been introduced.
> 
> Now we can remove it and use jiffies_to_msecs().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
