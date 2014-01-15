From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Jan 2014 14:10:16 +0000
Subject: Re: [PATCH net-next] sctp: create helper function to enable|disable sackdelay
Message-Id: <20140115141016.GA19718@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <52D653B1.4040708@huawei.com>
In-Reply-To: <52D653B1.4040708@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Wed, Jan 15, 2014 at 05:24:01PM +0800, Wang Weidong wrote:
> add sctp_spp_sackdelay_{enable|disable} helper function for
> avoiding code duplication. 
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Acked-by: Neil Horman <nhorman@tuxdriver.com>

