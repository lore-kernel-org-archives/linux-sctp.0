From: Jakub Sitnicki <jkbs@redhat.com>
Date: Tue, 19 Apr 2016 09:13:07 +0000
Subject: Re: [PATCHv3 net-next] net: use jiffies_to_msecs to replace EXPIRES_IN_MS in inet/sctp_diag
Message-Id: <87mvoqotb0.fsf@beetle.home>
List-Id: <linux-sctp.vger.kernel.org>
References: <87a0e83132ce64a3fe2266a5323fa6577a2e5c96.1461049801.git.lucien.xin@gmail.com>
In-Reply-To: <87a0e83132ce64a3fe2266a5323fa6577a2e5c96.1461049801.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net, eric.dumazet@gmail.com

On Tue, Apr 19, 2016 at 09:10 AM CEST, Xin Long <lucien.xin@gmail.com> wrote:
> EXPIRES_IN_MS macro comes from net/ipv4/inet_diag.c and dates
> back to before jiffies_to_msecs() has been introduced.
>
> Now we can remove it and use jiffies_to_msecs().
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Acked-by: Jakub Sitnicki <jkbs@redhat.com>
