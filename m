From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 24 Jul 2019 07:21:12 +0000
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size in __sctp_setsockopt_connectx
Message-Id: <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1563817029.git.lucien.xin@gmail.com> <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain>
In-Reply-To: <20190723152449.GB8419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem <davem@davemloft.net>

On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > sctp_inet_connect(), the latter has done addr_size check with size
> > of sa_family_t.
> >
> > In the next patch to clean up __sctp_connect(), we will remove
> > addr_size check with size of sa_family_t from __sctp_connect()
> > for the 1st address.
> >
> > So before doing that, __sctp_setsockopt_connectx() should do
> > this check first, as sctp_inet_connect() does.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/socket.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index aa80cda..5f92e4a 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> >                __func__, sk, addrs, addrs_size);
> >
> > -     if (unlikely(addrs_size <= 0))
> > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> I don't think this is what you want to check for here.  sa_family_t is
> an unsigned short, and addrs_size is the number of bytes in the addrs
> array.  The addrs array should be at least the size of one struct
> sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> sizeof(struct sockaddr)
sizeof(struct sockaddr) is not the right value to check either.

The proper check will be done later in __sctp_connect():

        af = sctp_get_af_specific(daddr->sa.sa_family);
        if (!af || af->sockaddr_len > addrs_size)
                return -EINVAL;

So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
just to make sure daddr->sa.sa_family is accessible. the same
check is also done in sctp_inet_connect().

>
> Neil
>
> >               return -EINVAL;
> >
> >       kaddrs = memdup_user(addrs, addrs_size);
> > --
> > 2.1.0
> >
> >
