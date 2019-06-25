From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 25 Jun 2019 18:09:06 +0000
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-Id: <CADvbK_fWmRFs_wfcttH+1y6D_0zzZzKgpEOb64wYSGBA+1j86g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190616153804.3604-1-hdanton@sina.com> <20190617134913.GL3436@localhost.localdomain>
 <20190617144331.GE3500@localhost.localdomain>
In-Reply-To: <20190617144331.GE3500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>, syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Mon, Jun 17, 2019 at 10:43 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Jun 17, 2019 at 10:49:13AM -0300, Marcelo Ricardo Leitner wrote:
> > Hi,
> >
> > On Sun, Jun 16, 2019 at 11:38:03PM +0800, Hillf Danton wrote:
> > >
> > > Hello Syzbot
> > >
> > > On Sat, 15 Jun 2019 16:36:06 -0700 (PDT) syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > ...
> > > Check prio_head and bail out if it is not valid.
> > >
> > > Thanks
> > > Hillf
> > > ----->8---
> > > ---
> > > net/sctp/stream_sched_prio.c | 2 ++
> > > 1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> > > index 2245083..db25a43 100644
> > > --- a/net/sctp/stream_sched_prio.c
> > > +++ b/net/sctp/stream_sched_prio.c
> > > @@ -135,6 +135,8 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
> > >     struct sctp_stream_priorities *prio, *prio_head;
> > >
> > >     prio_head = soute->prio_head;
> > > +   if (!prio_head)
> > > +           return;
> > >
> > >     /* Nothing to do if already scheduled */
> > >     if (!list_empty(&soute->prio_list))
> > > --
> >
> > Thanks but this is not a good fix for this. It will cause the stream
> > to never be scheduled.
> >
> > The problem happens because of the fault injection that happened a bit
> > before the crash, in here:
> >
> > int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
> > {
> >         struct sctp_stream_out_ext *soute;
> >
> >         soute = kzalloc(sizeof(*soute), GFP_KERNEL);
> >         if (!soute)
> >                 return -ENOMEM;
> >         SCTP_SO(stream, sid)->ext = soute;  <---- [A]
> >
> >         return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> >                       ^^^^^^^^^^^^---- [B] failed
> > }
> >
> > This causes the 1st sendmsg to bail out with the error. When the 2nd
> > one gets in, it will:
> >
> > sctp_sendmsg_to_asoc()
> > {
> > ...
> >         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
> >                                                                  ^^^^^--- [C]
> >                 err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
> >                 if (err)
> >                         goto err;
> >         }
> >
> > [A] leaves ext initialized, despite the failed in [B]. Then in [C], it
> > will not try to initialize again.
> >
> > We need to either uninitialize ->ext as error handling for [B], or
> > improve the check on [C].
>
> The former one, please. This should be enough (untested):
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 93ed07877337..25946604af85 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -153,13 +153,20 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>  int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
>  {
>         struct sctp_stream_out_ext *soute;
> +       int ret;
>
>         soute = kzalloc(sizeof(*soute), GFP_KERNEL);
>         if (!soute)
>                 return -ENOMEM;
>         SCTP_SO(stream, sid)->ext = soute;
>
> -       return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> +       ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> +       if (ret) {
> +               kfree(SCTP_SO(stream, sid)->ext);
> +               SCTP_SO(stream, sid)->ext = NULL;
> +       }
> +
> +       return ret;
>  }
>
>  void sctp_stream_free(struct sctp_stream *stream)
>

Tested-by: Xin Long <lucien.xin@gmail.com>

Hi, Marcelo, please feel free to move forward with this patch, :-)
