From: David Miller <davem@davemloft.net>
Date: Tue, 22 May 2018 17:40:14 +0000
Subject: Re: [PATCH net] sctp: fix the issue that flags are ignored when using kernel_connect
Message-Id: <20180522.134014.1038689773683362410.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4863916c3e574b0d860725466d7d4a2f445fbe5b.1526805550.git.lucien.xin@gmail.com>
In-Reply-To: <4863916c3e574b0d860725466d7d4a2f445fbe5b.1526805550.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, mkubecek@suse.cz

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 20 May 2018 16:39:10 +0800

> Now sctp uses inet_dgram_connect as its proto_ops .connect, and the flags
> param can't be passed into its proto .connect where this flags is really
> needed.
> 
> sctp works around it by getting flags from socket file in __sctp_connect.
> It works for connecting from userspace, as inherently the user sock has
> socket file and it passes f_flags as the flags param into the proto_ops
> .connect.
> 
> However, the sock created by sock_create_kern doesn't have a socket file,
> and it passes the flags (like O_NONBLOCK) by using the flags param in
> kernel_connect, which calls proto_ops .connect later.
> 
> So to fix it, this patch defines a new proto_ops .connect for sctp,
> sctp_inet_connect, which calls __sctp_connect() directly with this
> flags param. After this, the sctp's proto .connect can be removed.
> 
> Note that sctp_inet_connect doesn't need to do some checks that are not
> needed for sctp, which makes thing better than with inet_dgram_connect.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thank you.

I don't see a Fixes: tag, please give me some guidance me wrt. -stable.
