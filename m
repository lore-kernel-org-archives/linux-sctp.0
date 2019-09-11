From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 11 Sep 2019 08:51:41 +0000
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
In-Reply-To: <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 09 September 2019 08:57
> > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> >
> > Note that ps_retrans is not allowed to be greater than pf_retrans.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  1 +
> >  net/sctp/socket.c         | 10 ++++++++++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index a15cc28..dfd81e1 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> >       struct sockaddr_storage spt_address;
> >       __u16 spt_pathmaxrxt;
> >       __u16 spt_pathpfthld;
> > +     __u16 spt_pathcpthld;
> >  };
> >
> >  /*
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 5e2098b..5b9774d 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
>
> This code does:
>         if (optlen < sizeof(struct sctp_paddrthlds))
>                 return -EINVAL;
here will become:

        if (optlen >= sizeof(struct sctp_paddrthlds)) {
                optlen = sizeof(struct sctp_paddrthlds);
        } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
                                            spt_pathcpthld), 4))
                optlen = ALIGN(offsetof(struct sctp_paddrthlds,
                                        spt_pathcpthld), 4);
                val.spt_pathcpthld = 0xffff;
        else {
                return -EINVAL;
        }

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
                           optlen))
                return -EFAULT;

in sctp_getsockopt_paddr_thresholds():

        if (len >= sizeof(struct sctp_paddrthlds))
                len = sizeof(struct sctp_paddrthlds);
        else if (len >= ALIGN(offsetof(struct sctp_paddrthlds,
                                       spt_pathcpthld), 4))
                len = ALIGN(offsetof(struct sctp_paddrthlds,
                                     spt_pathcpthld), 4);
        else
                return -EINVAL;

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
                return -EFAULT;

>
> So adding an extra field breaks existing application binaries
> that use this option.
>
> I've not checked the other patches or similar fubar.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
