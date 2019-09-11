From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 11 Sep 2019 08:14:38 +0000
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <CADvbK_doDp3oFX5SdSwkqmAf+vkMo9XtqK8hLykixqBZYUL2OQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
 <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <20190910.192755.717621354475214603.davem@davemloft.net>
In-Reply-To: <20190910.192755.717621354475214603.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Wed, Sep 11, 2019 at 1:27 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon,  9 Sep 2019 15:56:51 +0800
>
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
>
> As pointed out you can't add things to this structure without breaking existing
> binaries.
we had the same problem when adding:
spp_ipv6_flowlabel and spp_dscp into struct sctp_paddrparams. in:

commit 0b0dce7a36fb9f1a9dd8245ea82d3a268c6943fe
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jul 2 18:21:13 2018 +0800

    sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams

the solution was:

        if (optlen = sizeof(params)) {
                if (copy_from_user(&params, optval, optlen))
                        return -EFAULT;
        } else if (optlen = ALIGN(offsetof(struct sctp_paddrparams,
                                            spp_ipv6_flowlabel), 4)) {
                if (copy_from_user(&params, optval, optlen))
                        return -EFAULT;
                if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
                        return -EINVAL;
        } else {
                return -EINVAL;
        }

I will do the same for this patch. Thanks.
