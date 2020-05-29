From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 29 May 2020 12:27:12 +0000
Subject: RE: [PATCH 4/4] net: remove kernel_setsockopt
Message-Id: <d95348e2191046e9986860e3f1023491@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-5-hch@lst.de>
In-Reply-To: <20200529120943.101454-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: Christoph Hellwig
> Sent: 29 May 2020 13:10
> 
> No users left.

There is no point even proposing this until all the changes to remove
its use have made it at least as far into 'net-next' and probably 'net'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
