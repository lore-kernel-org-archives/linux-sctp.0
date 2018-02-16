From: David Miller <davem@davemloft.net>
Date: Fri, 16 Feb 2018 21:32:52 +0000
Subject: Re: [PATCH net] sctp: remove the left unnecessary check for chunk in sctp_renege_events
Message-Id: <20180216.163252.661670043154563633.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0e61bb1ebe6aad2c06f426fec30f69a80d127ad8.1518772713.git.lucien.xin@gmail.com>
In-Reply-To: <0e61bb1ebe6aad2c06f426fec30f69a80d127ad8.1518772713.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, dan.carpenter@oracle.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 16 Feb 2018 17:18:33 +0800

> Commit fb23403536ea ("sctp: remove the useless check in
> sctp_renege_events") forgot to remove another check for
> chunk in sctp_renege_events.
> 
> Dan found this when doing a static check.
> 
> This patch is to remove that check, and also to merge
> two checks into one 'if statement'.
> 
> Fixes: fb23403536ea ("sctp: remove the useless check in sctp_renege_events")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thank you.
