From: 'Christoph Hellwig' <hch@lst.de>
Date: Fri, 29 May 2020 12:29:21 +0000
Subject: Re: [PATCH 4/4] net: remove kernel_setsockopt
Message-Id: <20200529122921.GA28533@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de> <20200529120943.101454-5-hch@lst.de> <d95348e2191046e9986860e3f1023491@AcuMS.aculab.com>
In-Reply-To: <d95348e2191046e9986860e3f1023491@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Christoph Hellwig' <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Fri, May 29, 2020 at 12:27:12PM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 29 May 2020 13:10
> > 
> > No users left.
> 
> There is no point even proposing this until all the changes to remove
> its use have made it at least as far into 'net-next' and probably 'net'.

If you look at net-next, the only two users left are the two removed in
this series.
