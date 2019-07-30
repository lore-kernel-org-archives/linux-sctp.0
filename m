From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 30 Jul 2019 19:42:31 +0000
Subject: Re: [PATCHv2 net-next 0/5] sctp: clean up __sctp_connect function
Message-Id: <20190730194231.GE4064@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Tue, Jul 30, 2019 at 08:38:18PM +0800, Xin Long wrote:
> This patchset is to factor out some common code for
> sctp_sendmsg_new_asoc() and __sctp_connect() into 2
> new functioins.
> 
> v1->v2:
>   - add the patch 1/5 to avoid a slab-out-of-bounds warning.
>   - add some code comment for the check change in patch 2/5.
>   - remove unused 'addrcnt' as Marcelo noticed in patch 3/5.
> 
> Xin Long (5):
>   sctp: only copy the available addr data in sctp_transport_init
>   sctp: check addr_size with sa_family_t size in
>     __sctp_setsockopt_connectx
>   sctp: clean up __sctp_connect
>   sctp: factor out sctp_connect_new_asoc
>   sctp: factor out sctp_connect_add_peer

Series,
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
