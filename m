From: David Miller <davem@davemloft.net>
Date: Tue, 13 Aug 2013 22:04:39 +0000
Subject: Re: [PATCH net-next] net: sctp: Add rudimentary infrastructure to account for control chunks
Message-Id: <20130813.150439.445852624627246263.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52058BB2.4010606@gmail.com>
	<1376100336-21481-1-git-send-email-vyasevich@gmail.com>
In-Reply-To: <1376100336-21481-1-git-send-email-vyasevich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dborkman@redhat.com, eric.dumazet@gmail.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri,  9 Aug 2013 22:05:36 -0400

> This patch adds a base infrastructure that allows SCTP to do
> memory accounting for control chunks.  Real accounting code will
> follow.
> 
> This patch alos fixes the following triggered bug ...
 ...
> The approach taken here is to split data and control chunks
> creation a  bit.  Data chunks already have memory accounting
> so noting needs to happen.  For control chunks, add stubs handlers.
> 
> Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, but:

> +	/* TODO: properly account for control chunks. 

I had to delete the trailing whitespace on that line.
