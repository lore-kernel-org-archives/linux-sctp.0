From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 19 Apr 2016 12:25:32 +0000
Subject: Re: [PATCHv3 net-next] net: use jiffies_to_msecs to replace EXPIRES_IN_MS in inet/sctp_diag
Message-Id: <1461068732.10638.169.camel@edumazet-glaptop3.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <87a0e83132ce64a3fe2266a5323fa6577a2e5c96.1461049801.git.lucien.xin@gmail.com>
In-Reply-To: <87a0e83132ce64a3fe2266a5323fa6577a2e5c96.1461049801.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net, jsitnick@redhat.com

On Tue, 2016-04-19 at 15:10 +0800, Xin Long wrote:
> EXPIRES_IN_MS macro comes from net/ipv4/inet_diag.c and dates
> back to before jiffies_to_msecs() has been introduced.
> 
> Now we can remove it and use jiffies_to_msecs().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Ok. Note that you could have mentioned this was 

Suggested-by: Jakub Sitnicki <jkbs@redhat.com>

Even coworkers deserve credits ;)

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks.



