From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 08 Oct 2020 09:37:17 +0000
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port is set
Message-Id: <CADvbK_fmWxXzHjvmCf-BoDiXrj6FAOR5MR4=SiLCy3Q31E2-ZA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com> <20201003040824.GG70998@localhost.localdomain>
 <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com>
 <CADvbK_eXnzjDCypRkep9JqxBFV=cMXNkSZr4nyAaMiDc1VGXJg@mail.gmail.com>
 <CADvbK_fzASk9dLbHLNtLLc+uS7hLz6nDi2CESgN55Yh-o92+rQ@mail.gmail.com> <20201005190114.GL70998@localhost.localdomain>
In-Reply-To: <20201005190114.GL70998@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: kernel test robot <lkp@intel.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, kbuild-all@lists.01.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem <davem@davemloft.net>

On Tue, Oct 6, 2020 at 3:01 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sat, Oct 03, 2020 at 08:24:34PM +0800, Xin Long wrote:
> > On Sat, Oct 3, 2020 at 7:23 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Sat, Oct 3, 2020 at 4:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > On Sat, Oct 3, 2020 at 12:08 PM Marcelo Ricardo Leitner
> > > > <marcelo.leitner@gmail.com> wrote:
> > > > >
> > > > > On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> > > > > > Hi Xin,
> > > > > >
> > > > > > Thank you for the patch! Yet something to improve:
> > > > >
> > > > > I wonder how are you planning to fix this. It is quite entangled.
> > > > > This is not performance critical. Maybe the cleanest way out is to
> > > > > move it to a .c file.
> > > > >
> > > > > Adding a
> > > > > #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> > > > > in there doesn't seem good.
> > > > >
> > > > > >    In file included from include/net/sctp/checksum.h:27,
> > > > > >                     from net/netfilter/nf_nat_proto.c:16:
> > > > > >    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> > > > > > >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
> > > > > >      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
> > > > > >          |                               ^~~~
> > > > > >          |                               ct
> > > > > >
> > > > Here is actually another problem, I'm still thinking how to fix it.
> > > >
> > > > Now sctp_mtu_payload() returns different value depending on
> > > > net->sctp.udp_port. but net->sctp.udp_port can be changed by
> > > > "sysctl -w" anytime. so:
>
> Good point.
>
> > > >
> > > > In sctp_packet_config() it gets overhead/headroom by calling
> > > > sctp_mtu_payload(). When 'udp_port' is 0, it's IP+MAC header
> > > > size. Then if 'udp_port' is changed to 9899 by 'sysctl -w',
> > > > udphdr will also be added to the packet in sctp_v4_xmit(),
> > > > and later the headroom may not be enough for IP+MAC headers.
> > > >
> > > > I'm thinking to add sctp_sock->udp_port, and it'll be set when
> > > > the sock is created with net->udp_port. but not sure if we should
> > > > update sctp_sock->udp_port with  net->udp_port when sending packets?
>
> I don't think so,
>
> > > something like:
> ...
> > diff --git a/net/sctp/output.c b/net/sctp/output.c
> > index 6614c9fdc51e..c96b13ec72f4 100644
> > --- a/net/sctp/output.c
> > +++ b/net/sctp/output.c
> > @@ -91,6 +91,14 @@ void sctp_packet_config(struct sctp_packet *packet,
> > __u32 vtag,
> >         if (asoc) {
> >                 sk = asoc->base.sk;
> >                 sp = sctp_sk(sk);
> > +
> > +               if (unlikely(sp->udp_port != sock_net(sk)->sctp.udp_port)) {
>
> RFC6951 has:
>
> 6.1.  Get or Set the Remote UDP Encapsulation Port Number
>       (SCTP_REMOTE_UDP_ENCAPS_PORT)
> ...
>    sue_assoc_id:  This parameter is ignored for one-to-one style
>       sockets.  For one-to-many style sockets, the application may fill
>       in an association identifier or SCTP_FUTURE_ASSOC for this query.
>       It is an error to use SCTP_{CURRENT|ALL}_ASSOC in sue_assoc_id.
>
>    sue_address:  This specifies which address is of interest.  If a
>       wildcard address is provided, it applies only to future paths.
>
> So I'm not seeing a reason to have a system wide knob that takes
> effect in run time like this.
> Enable, start apps, and they keep behaving as initially configured.
> Need to disable? Restart the apps/sockets.
>
> Thoughts?
Right, not to update it on tx path makes more sense. Thanks.

>
> > +                       __u16 port = sock_net(sk)->sctp.udp_port;
> > +
> > +                       if (!sp->udp_port || !port)
> > +                               sctp_assoc_update_frag_point(asoc);
> > +                       sp->udp_port = port;
> > +               }
> >         }
