From: David Teigland <teigland@redhat.com>
Date: Fri, 29 May 2020 18:09:25 +0000
Subject: Re: [PATCH 1/4] sctp: add sctp_sock_set_nodelay
Message-Id: <20200529180925.GB25942@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-2-hch@lst.de>
In-Reply-To: <20200529120943.101454-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:40PM +0200, Christoph Hellwig wrote:
> Add a helper to directly set the SCTP_NODELAY sockopt from kernel space
> without going through a fake uaccess.

Ack, they look fine to me, thanks.
Dave
