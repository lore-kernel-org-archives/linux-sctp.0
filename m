From: David Miller <davem@davemloft.net>
Date: Wed, 20 Jan 2010 23:03:43 +0000
Subject: Re: [PATCH 4/9] net/sctp: Eliminate useless code
Message-Id: <20100120.150343.236848237.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <Pine.LNX.4.64.1001161657570.28745@ask.diku.dk>
	<4B574702.4040602@hp.com>
In-Reply-To: <4B574702.4040602@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: julia@diku.dk, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 20 Jan 2010 13:10:10 -0500

> 
> 
> Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>> 
>> The variable newinet is initialized twice to the same (side effect-free)
>> expression.  Drop one initialization.
>> 
>> A simplified version of the semantic match that finds this problem is:
>> (http://coccinelle.lip6.fr/)
>> 
>> // <smpl>
>> @forall@
>> idexpression *x;
>> identifier f!=ERR_PTR;
>> @@
>> 
>> x = f(...)
>> ... when != x
>> (
>> x = f(...,<+...x...+>,...)
>> |
>> * x = f(...)
>> )
>> // </smpl>
>> 
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Julia,  just like patch #3 this one had the missing final
line of the patch corrupting it, so you'll need to resubmit.
