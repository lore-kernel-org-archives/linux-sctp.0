From: David Miller <davem@davemloft.net>
Date: Wed, 15 Jan 2014 02:19:45 +0000
Subject: Re: [PATCH] sctp: remove a redundant NULL check
Message-Id: <20140114.181945.615823290540787555.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140113134608.GA5232@elgon.mountain>
In-Reply-To: <20140113134608.GA5232@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dan.carpenter@oracle.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 13 Jan 2014 16:46:08 +0300

> It confuses Smatch when we check "sinit" for NULL and then non-NULL and
> that causes a false positive warning later.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
