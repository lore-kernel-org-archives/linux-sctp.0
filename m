From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 11 Sep 2019 08:30:38 +0000
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call sctp_get_port_local
Message-Id: <20190911083038.GF20699@kadam>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
 <20190910185710.GF15977@kadam>
 <20190910192207.GE20699@kadam>
 <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
In-Reply-To: <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: maowenan <maowenan@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Sep 11, 2019 at 09:30:47AM +0800, maowenan wrote:
> 
> 
> On 2019/9/11 3:22, Dan Carpenter wrote:
> > On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
> >> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> >>> There are more parentheses in if clause when call sctp_get_port_local
> >>> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> >>> do cleanup.
> >>>
> >>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >>> ---
> >>>  net/sctp/socket.c | 3 +--
> >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >>> index 9d1f83b10c0a..766b68b55ebe 100644
> >>> --- a/net/sctp/socket.c
> >>> +++ b/net/sctp/socket.c
> >>> @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> >>>  	 * detection.
> >>>  	 */
> >>>  	addr->v4.sin_port = htons(snum);
> >>> -	if ((ret = sctp_get_port_local(sk, addr))) {
> >>> +	if (sctp_get_port_local(sk, addr))
> >>>  		return -EADDRINUSE;
> >>
> >> sctp_get_port_local() returns a long which is either 0,1 or a pointer
> >> casted to long.  It's not documented what it means and neither of the
> >> callers use the return since commit 62208f12451f ("net: sctp: simplify
> >> sctp_get_port").
> > 
> > Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
> > socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
> > because before the code assumed that a pointer casted to an int was the
> > same as a pointer casted to a long.
> 
> commit 4e54064e0a13 treated non-zero return value as unexpected, so the current
> cleanup is ok?

Yeah.  It's fine, I was just confused why we weren't preserving the
error code and then I saw that we didn't return errors at all and got
confused.

regards,
dan carpenter
