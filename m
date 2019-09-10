From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 10 Sep 2019 07:16:49 +0000
Subject: Re: [PATCH net 0/2] fix memory leak for sctp_do_bind
Message-Id: <20190910071649.GB31884@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190910071343.18808-1-maowenan@huawei.com>
In-Reply-To: <20190910071343.18808-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mao Wenan <maowenan@huawei.com>
Cc: vyasevich@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Sep 10, 2019 at 03:13:41PM +0800, Mao Wenan wrote:
> First patch is to do cleanup, remove redundant assignment,
> second patch is to fix memory leak for sctp_do_bind if failed
> to bind address.
> 
> Mao Wenan (2):
>   sctp: remove redundant assignment when call sctp_get_port_local
>   sctp: destroy bucket if failed to bind addr
> 
>  net/sctp/socket.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> -- 
> 2.20.1
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
