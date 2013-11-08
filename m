From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 08 Nov 2013 12:31:19 +0000
Subject: Re: [PATCH net-next v2 0/4] sctp: do some clean ups
Message-Id: <20131108123119.GD4819@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Fri, Nov 08, 2013 at 02:17:47PM +0800, Wang Weidong wrote:
> This patch series include: remove the duplicate initialize,                                                                                                
> make code simple, convert func to boolean, fix some typos.
> 
> v1 -> v2:
>   - patch2: make the code more simplification, as suggested
>     by Joe Perches.
> 
> Wang Weidong (4):
>   sctp: remove the duplicate initialize
>   sctp: remove the else path
>   sctp: convert sctp_peer_needs_update to boolean
>   sctp: fix some comments in associola.c
> 
>  net/sctp/associola.c | 65 ++++++++--------------------------------------------
>  1 file changed, 10 insertions(+), 55 deletions(-)
> 
> -- 
> 1.7.12
> 
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
