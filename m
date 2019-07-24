From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 24 Jul 2019 14:25:12 +0000
Subject: Re: [PATCH net-next 0/4] sctp: clean up __sctp_connect function
Message-Id: <20190724142512.GG6204@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Tue, Jul 23, 2019 at 01:37:56AM +0800, Xin Long wrote:
> This patchset is to factor out some common code for
> sctp_sendmsg_new_asoc() and __sctp_connect() into 2
> new functioins.
> 
> Xin Long (4):
>   sctp: check addr_size with sa_family_t size in
>     __sctp_setsockopt_connectx
>   sctp: clean up __sctp_connect
>   sctp: factor out sctp_connect_new_asoc
>   sctp: factor out sctp_connect_add_peer

Nice cleanup! These patches LGTM. Hopefully for Neil as well.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
