From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 14 Jun 2016 13:21:36 +0000
Subject: Re: [PATCH -next] sctp: fix error return code in sctp_init()
Message-Id: <20160614132136.GA32288@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1465830506-22752-1-git-send-email-weiyj_lk@163.com>
 <CADvbK_eOtTS9NSRoKmJYXSYHtCRMFMkKqkeCREVY09qtE=Y4og@mail.gmail.com>
In-Reply-To: <CADvbK_eOtTS9NSRoKmJYXSYHtCRMFMkKqkeCREVY09qtE=Y4og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: weiyj_lk@163.com, Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>

On Tue, Jun 14, 2016 at 11:04:05AM +0800, Xin Long wrote:
> On Mon, Jun 13, 2016 at 11:08 PM,  <weiyj_lk@163.com> wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  net/sctp/protocol.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> > index 40022ee..3b56ae5 100644
> > --- a/net/sctp/protocol.c
> > +++ b/net/sctp/protocol.c
> > @@ -1479,7 +1479,8 @@ static __init int sctp_init(void)
> >                 INIT_HLIST_HEAD(&sctp_port_hashtable[i].chain);
> >         }
> >
> > -       if (sctp_transport_hashtable_init())
> > +       status = sctp_transport_hashtable_init();
> > +       if (status)
> >                 goto err_thash_alloc;
> >
> >         pr_info("Hash tables configured (bind %d/%d)\n", sctp_port_hashsize,
> >
> >
> Acked-by: Xin Long <lucien.xin@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Neil Horman <nhorman@tuxdriver.com>

