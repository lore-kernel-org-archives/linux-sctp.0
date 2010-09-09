From: David Miller <davem@davemloft.net>
Date: Thu, 09 Sep 2010 22:00:51 +0000
Subject: Re: [Alternative PATCH net-next] sctp: fix test for end of loop
Message-Id: <20100909.150051.115922917.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100908.133747.232732909.davem@davemloft.net>
	<1283979861.2479.21.camel@Joe-Laptop>
	<4C88E7CB.7060804@hp.com>
In-Reply-To: <4C88E7CB.7060804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: joe@perches.com, error27@gmail.com, sri@us.ibm.com, yjwei@cn.fujitsu.com, cascardo@holoscopio.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 09 Sep 2010 09:57:31 -0400

> On 09/08/2010 05:04 PM, Joe Perches wrote:
>> Perhaps something like this is clearer?
>> 
>> Add a list_has_sctp_addr function to simplify loop
>> 
>> Based on a patches by Dan Carpenter and David Miller
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Thanks Joe
> 
> I like this.  Nice and clean. :)
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied to net-2.6 since this is reasonably important bug fix.

Thanks guys!
