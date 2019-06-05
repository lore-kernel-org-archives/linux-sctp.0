From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Date: Wed, 05 Jun 2019 22:53:17 +0000
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-Id: <56e6ad8c-28b7-9f19-d8fa-a4857b694a1d@metux.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1559768607-17439-1-git-send-email-info@metux.net>
 <20190605215026.GB3778@localhost.localdomain>
In-Reply-To: <20190605215026.GB3778@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 05.06.19 21:50, Marcelo Ricardo Leitner wrote:
> On Wed, Jun 05, 2019 at 11:03:27PM +0200, Enrico Weigelt, metux IT consult wrote:
>> From: Enrico Weigelt <info@metux.net>
>>
>> IS_ERR() already calls unlikely(), so this extra unlikely() call
>> around IS_ERR() is not needed.
>>
>> Signed-off-by: Enrico Weigelt <info@metux.net>
> 
> Hi,
> 
> This patch overlaps with
> Jun 05 Kefeng Wang     (4.4K) [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)

I've missed Kefeng's patch ... feel free to ignore mine.


--mtx


-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
