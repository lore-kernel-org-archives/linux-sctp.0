From: David Miller <davem@davemloft.net>
Date: Wed, 08 Sep 2010 20:30:45 +0000
Subject: Re: [patch] sctp: fix test for end of loop
Message-Id: <20100908.133045.245384362.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100906122344.GA2764@bicker>
	<4C87F185.3070402@hp.com>
In-Reply-To: <4C87F185.3070402@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: error27@gmail.com, sri@us.ibm.com, yjwei@cn.fujitsu.com, cascardo@holoscopio.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 08 Sep 2010 16:26:45 -0400

> I am really not fond of this code.  I think it would be better to move
> this abort code into the loop and break out once things are aborted.
> 
> This way we can get rid of the whole found check after the outer loop happens
> and it cleans things up nicely.

Vlad see my followup.
