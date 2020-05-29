From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 May 2020 16:06:55 +0000
Subject: Re: [PATCH 3/4] net: add a new bind_add method
Message-Id: <20200529160655.GJ2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-4-hch@lst.de>
In-Reply-To: <20200529120943.101454-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Laight <David.Laight@aculab.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:42PM +0200, Christoph Hellwig wrote:
> The SCTP protocol allows to bind multiple address to a socket.  That
> feature is currently only exposed as a socket option.  Add a bind_add
> method struct proto that allows to bind additional addresses, and
> switch the dlm code to use the method instead of going through the
> socket option from kernel space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Even though checkpatch complained about bad alignment here:
> +static int sctp_bind_add(struct sock *sk, struct sockaddr *addrs,
> +		int addrlen)
