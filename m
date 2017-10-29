From: David Miller <davem@davemloft.net>
Date: Sun, 29 Oct 2017 09:04:05 +0000
Subject: Re: [PATCH net 0/4] sctp: a bunch of fixes for some sparse warnings
Message-Id: <20171029.180405.85677078762613174.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1509190967.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1509190967.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, edumazet@google.com, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 28 Oct 2017 19:43:53 +0800

> As Eric noticed, when running 'make C=2 M=net/sctp/', a plenty of
> warnings or errors checked by sparse appear. They are all problems
> about Endian and type cast.
> 
> Most of them are just warnings by which no issues could be caused
> while some might be bugs.
> 
> This patchset fixes them with four patches basically according to
> how they are introduced.

Series applied, thanks.
