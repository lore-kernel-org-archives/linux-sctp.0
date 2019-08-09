From: David Miller <davem@davemloft.net>
Date: Fri, 09 Aug 2019 01:05:29 +0000
Subject: Re: [PATCH net-next] net: use "nb" for notifier blocks
Message-Id: <20190808.180529.1408453640987288575.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190805204331.GA25178@avx2>
In-Reply-To: <20190805204331.GA25178@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: adobriyan@gmail.com
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 5 Aug 2019 23:43:31 +0300

> Use more pleasant looking
> 
> 	struct notifier_block *nb,
> 
> instead of "this".
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Sorry, this is a lot of churn for something that is basically an
opinion of being nicer or less nice.

I actually kind of like "this".
