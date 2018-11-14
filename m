From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 14 Nov 2018 15:11:55 +0000
Subject: Re: [PATCHv2 net-next 1/4] sctp: define subscribe in sctp_sock as __u16
Message-Id: <CADvbK_couZ5M=mgk9QHLYGP4rgpL51bsSKj2+Qz0Lnc42DOSVg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542089666.git.lucien.xin@gmail.com> <82150b4fab9e70377db3db9c62fd10323be3f294.1542089666.git.lucien.xin@gmail.com>
 <20181113171521.GB7568@neilslaptop.think-freely.org>
In-Reply-To: <20181113171521.GB7568@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem <davem@davemloft.net>

On Wed, Nov 14, 2018 at 2:16 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Nov 13, 2018 at 02:24:53PM +0800, Xin Long wrote:
> >
> >       /* Default Peer Address Parameters.  These defaults can
> >        * be modified via SCTP_PEER_ADDR_PARAMS
> > @@ -5267,14 +5274,24 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
> >  static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
> >                                 int __user *optlen)
> >  {
> > +     struct sctp_event_subscribe subscribe;
> > +     __u8 *sn_type = (__u8 *)&subscribe;
> > +     int i;
> > +
> >       if (len = 0)
> >               return -EINVAL;
> >       if (len > sizeof(struct sctp_event_subscribe))
> >               len = sizeof(struct sctp_event_subscribe);
> >       if (put_user(len, optlen))
> >               return -EFAULT;
> > -     if (copy_to_user(optval, &sctp_sk(sk)->subscribe, len))
> > +
> > +     for (i = 0; i <= len; i++)
> > +             sn_type[i] = sctp_ulpevent_type_enabled(sctp_sk(sk)->subscribe,
> > +                                                     SCTP_SN_TYPE_BASE + i);
> > +
> This seems like an off by one error.  sctp_event_subscribe has N bytes in it (1
> byte for each event), meaning that that events 0-(N-1) are subscribable.
> Iterating this loop imples that you are going to check N events, overrunning the
> sctp_event_subscribe struct.
you're right, thanks.

>
> Neil
>
> >
