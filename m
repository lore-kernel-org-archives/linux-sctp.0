From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 12 Sep 2019 14:52:03 +0000
Subject: Re: [PATCH v2 net 2/3] sctp: remove redundant assignment when call sctp_get_port_local
Message-Id: <20190912145203.GS3431@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
 <20190912040219.67517-3-maowenan@huawei.com>
In-Reply-To: <20190912040219.67517-3-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mao Wenan <maowenan@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, Sep 12, 2019 at 12:02:18PM +0800, Mao Wenan wrote:
> There are more parentheses in if clause when call sctp_get_port_local
> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> do cleanup.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
