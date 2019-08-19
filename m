From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 15:19:09 +0000
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-Id: <CADvbK_c3Tv=O4D18w1N-8j_KXjQ-kVwKK0k2u8OPtpQhGoY7MQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com> <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <20190819145843.GE2870@localhost.localdomain>
In-Reply-To: <20190819145843.GE2870@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>

On Mon, Aug 19, 2019 at 10:58 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> > +static int sctp_setsockopt_asconf_supported(struct sock *sk,
> > +                                         char __user *optval,
> > +                                         unsigned int optlen)
> > +{
> > +     struct sctp_assoc_value params;
> > +     struct sctp_association *asoc;
> > +     struct sctp_endpoint *ep;
> > +     int retval = -EINVAL;
> > +
> > +     if (optlen != sizeof(params))
> > +             goto out;
> > +
> > +     if (copy_from_user(&params, optval, optlen)) {
> > +             retval = -EFAULT;
> > +             goto out;
> > +     }
> > +
> > +     asoc = sctp_id2assoc(sk, params.assoc_id);
> > +     if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
> > +         sctp_style(sk, UDP))
> > +             goto out;
> > +
> > +     ep = sctp_sk(sk)->ep;
> > +     ep->asconf_enable = !!params.assoc_value;
>
> Considering this will be negotiated on handshake, shouldn't it deny
> changes to Established asocs? (Same for Auth)
ep->asconf_enable is for 'furture' asocs, and furture
asoc->peer.asconf_capable will be negotiated according to
peer ep->asconf_enable (EXT chunk) and local ep->asconf_enable.

It won't affect the 'current'/Established asocs, and the Established
asocs have asoc->peer.asconf_capable, which can't be changed by sockopt.

>
> > +
> > +     if (ep->asconf_enable && ep->auth_enable) {
> > +             sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
> > +             sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
> > +     }
> > +
> > +     retval = 0;
> > +
> > +out:
> > +     return retval;
> > +}
