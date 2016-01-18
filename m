From: David Miller <davem@davemloft.net>
Date: Mon, 18 Jan 2016 00:12:20 +0000
Subject: Re: [PATCH net] sctp: the temp asoc's transports should not be hashed/unhashed
Message-Id: <20160117.191220.636907487411695644.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <488453d4e06805934290a1ef3cf633ee4b26bdc6.1452946637.git.lucien.xin@gmail.com>
In-Reply-To: <488453d4e06805934290a1ef3cf633ee4b26bdc6.1452946637.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 16 Jan 2016 20:17:17 +0800

> Re-establish the previous behavior and avoid hashing temporary asocs by
> checking t->asoc->temp in sctp_(un)hash_transport. Also, remove the
> check of t->asoc->temp in __sctp_lookup_association, since they are
> never hashed now.
> 
> Fixes: 4f0087812648 ("sctp: apply rhashtable api to send/recv path")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Reported-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks.
