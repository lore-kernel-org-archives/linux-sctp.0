From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 01 Jun 2020 08:27:08 +0000
Subject: RE: [PATCH 2/4] sctp: refactor sctp_setsockopt_bindx
Message-Id: <ef0754831c294934b67f89fd8c5e1b5b@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-3-hch@lst.de>
 <20200529160544.GI2491@localhost.localdomain>
In-Reply-To: <20200529160544.GI2491@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: Marcelo Ricardo Leitner
> Sent: 29 May 2020 17:06
> On Fri, May 29, 2020 at 02:09:41PM +0200, Christoph Hellwig wrote:
> > Split out a sctp_setsockopt_bindx_kernel that takes a kernel pointer
> > to the sockaddr and make sctp_setsockopt_bindx a small wrapper around
> > it.  This prepares for adding a new bind_add proto op.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> > ---
> >  net/sctp/socket.c | 61 ++++++++++++++++++++++-------------------------
> >  1 file changed, 28 insertions(+), 33 deletions(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 827a9903ee288..6e745ac3c4a59 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -972,23 +972,22 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
> >   * it.
> >   *
> >   * sk        The sk of the socket
> > - * addrs     The pointer to the addresses in user land
> > + * addrs     The pointer to the addresses
> >   * addrssize Size of the addrs buffer
> >   * op        Operation to perform (add or remove, see the flags of
> >   *           sctp_bindx)
> >   *
> >   * Returns 0 if ok, <0 errno code on error.
> >   */
> > -static int sctp_setsockopt_bindx(struct sock *sk,
> > -				 struct sockaddr __user *addrs,
> > -				 int addrs_size, int op)
> > +static int sctp_setsockopt_bindx_kernel(struct sock *sk,
                        const
> > +					struct sockaddr *addrs, int addrs_size,
> > +					int op)

The list of addresses ought to be 'const'.

IIRC that requires the test for 'port = 0' be moved down  a few layers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
