From: David Miller <davem@davemloft.net>
Date: Sun, 01 Mar 2020 05:52:44 +0000
Subject: Re: [PATCH][next] net: sctp: Replace zero-length array with flexible-array member
Message-Id: <20200229.215244.324977010862063842.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200229001305.GA7465@embeddedor>
In-Reply-To: <20200229001305.GA7465@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gustavo@embeddedor.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Fri, 28 Feb 2020 18:13:05 -0600

> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
