From: David Miller <davem@davemloft.net>
Date: Wed, 27 Sep 2017 04:17:58 +0000
Subject: Re: [PATCH net v2] sctp: Fix a big endian bug in sctp_diag_dump()
Message-Id: <20170926.211758.629176988425489674.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADvbK_dCT6Z6JwD+VtjNg6UUkQneU2OLeme9JVqrXjnJJ63cGg@mail.gmail.com>
        <20170925101926.db4f6x4hblh7tcvo@mwanda>
In-Reply-To: <20170925101926.db4f6x4hblh7tcvo@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dan.carpenter@oracle.com
Cc: vyasevich@gmail.com, lucien.xin@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 25 Sep 2017 13:19:26 +0300

> The sctp_for_each_transport() function takes an pointer to int.  The
> cb->args[] array holds longs so it's only using the high 32 bits.  It
> works on little endian system but will break on big endian 64 bit
> machines.
> 
> Fixes: d25adbeb0cdb ("sctp: fix an use-after-free issue in sctp_sock_dump")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: The v1 patch changed the function to take a long pointer, but v2
>     just changes the caller.

Applied, thanks.
