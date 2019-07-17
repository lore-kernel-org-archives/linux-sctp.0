From: David Miller <davem@davemloft.net>
Date: Wed, 17 Jul 2019 19:01:31 +0000
Subject: Re: [PATCH] net: sctp: fix warning "NULL check before some freeing functions is not needed"
Message-Id: <20190717.120131.1614957687610581259.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190716022002.GA19592@hari-Inspiron-1545>
In-Reply-To: <20190716022002.GA19592@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hariprasad.kelam@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Tue, 16 Jul 2019 07:50:02 +0530

> This patch removes NULL checks before calling kfree.
> 
> fixes below issues reported by coccicheck
> net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied.
