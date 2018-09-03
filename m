From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 03 Sep 2018 22:06:06 +0000
Subject: Re: [PATCH net 0/2] sctp: two fixes for spp_ipv6_flowlabel and spp_dscp sockopts
Message-Id: <20180903220606.GA19741@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1535960717.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1535960717.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Mon, Sep 03, 2018 at 03:47:09PM +0800, Xin Long wrote:
> This patchset fixes two problems in sctp_apply_peer_addr_params()
> when setting spp_ipv6_flowlabel or spp_dscp.
> 
> Xin Long (2):
>   sctp: fix invalid reference to the index variable of the iterator
>   sctp: not traverse asoc trans list if non-ipv6 trans exists for
>     ipv6_flowlabel
> 
>  net/sctp/socket.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)

Series
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
