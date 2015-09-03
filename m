From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 03 Sep 2015 14:37:47 +0000
Subject: Re: [PATCH net 0/2] couple of sctp fixes for 0ca50d12fe46
Message-Id: <55E85B3B.6010607@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1441220305.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1441220305.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 09/02/2015 03:20 PM, Marcelo Ricardo Leitner wrote:
> These are two fixes for sctp after my patch on 0ca50d12fe46 ("sctp: fix
> src address selection if using secondary addresses")
> 
> The first, fix a dst leak on those it decided to skip.
> 
> The second, adds the fallback on src selection that Vlad had asked
> about. Unfortunatelly a lot of ipvs setups relies on the old behavior
> and I don't see a better fix for it.
> 
> Please consider both to -stable tree.
> 
> Thanks!
> 
> Marcelo Ricardo Leitner (2):
>   sctp: fix dst leak
>   sctp: add routing output fallback
> 
>  net/sctp/protocol.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

For the series

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
