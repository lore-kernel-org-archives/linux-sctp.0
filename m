From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 10 Sep 2019 19:22:08 +0000
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call sctp_get_port_local
Message-Id: <20190910192207.GE20699@kadam>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
 <20190910185710.GF15977@kadam>
In-Reply-To: <20190910185710.GF15977@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mao Wenan <maowenan@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> > There are more parentheses in if clause when call sctp_get_port_local
> > in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> > do cleanup.
> > 
> > Signed-off-by: Mao Wenan <maowenan@huawei.com>
> > ---
> >  net/sctp/socket.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 9d1f83b10c0a..766b68b55ebe 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> >  	 * detection.
> >  	 */
> >  	addr->v4.sin_port = htons(snum);
> > -	if ((ret = sctp_get_port_local(sk, addr))) {
> > +	if (sctp_get_port_local(sk, addr))
> >  		return -EADDRINUSE;
> 
> sctp_get_port_local() returns a long which is either 0,1 or a pointer
> casted to long.  It's not documented what it means and neither of the
> callers use the return since commit 62208f12451f ("net: sctp: simplify
> sctp_get_port").

Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
because before the code assumed that a pointer casted to an int was the
same as a pointer casted to a long.

regards,
dan carpenter
