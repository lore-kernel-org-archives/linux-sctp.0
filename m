From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 26 Nov 2018 13:46:36 +0000
Subject: Re: [PATCH net] sctp: update frag_point when stream_interleave is set
Message-Id: <20181126134636.GB30481@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <9d006cb7fe16d32e2cbacfaddb9c9f4b48aa2755.1543222931.git.lucien.xin@gmail.com>
 <20181126122903.GI3601@localhost.localdomain>
 <CADvbK_eQKdarLLEdb1V49TJMyiuZ6+QcuMHo=KxXWucboYxsbA@mail.gmail.com>
In-Reply-To: <CADvbK_eQKdarLLEdb1V49TJMyiuZ6+QcuMHo=KxXWucboYxsbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Jakub Audykowicz <jakub.audykowicz@gmail.com>

On Mon, Nov 26, 2018 at 10:16:50PM +0900, Xin Long wrote:
> On Mon, Nov 26, 2018 at 9:29 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, Nov 26, 2018 at 05:02:11PM +0800, Xin Long wrote:
> > > sctp_assoc_update_frag_point() should be called whenever asoc->pathmtu
> > > changes, but we missed one place in sctp_association_init(). It would
> > > cause frag_point is zero when sending data.
> > >
> > > As says in Jakub's reproducer, if sp->pathmtu is set by socketopt, the
> > > new asoc->pathmtu inherits it in sctp_association_init(). Later when
> > > transports are added and their pmtu >= asoc->pathmtu, it will never
> > > call sctp_assoc_update_frag_point() to set frag_point.
> > >
> > > This patch is to fix it by updating frag_point when stream_interleave
> > > is set in sctp_stream_interleave_init(), which is also called in
> > > sctp_association_init(). We're doing this also because frag_point
> > > is affected by datachunk's type, namely stream_interleave_0/1.
> > >
> > > Fixes: 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
> > > Reported-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/sctp/stream_interleave.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> > > index 0a78cdf..19d596d 100644
> > > --- a/net/sctp/stream_interleave.c
> > > +++ b/net/sctp/stream_interleave.c
> > > @@ -1327,4 +1327,5 @@ void sctp_stream_interleave_init(struct sctp_stream *stream)
> > >       asoc = container_of(stream, struct sctp_association, stream);
> > >       stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
> > >                                      : &sctp_stream_interleave_0;
> > > +     sctp_assoc_update_frag_point(asoc);
> >
> > I get that by adding it here we avoid adding it twice, one in
> > sctp_association_init and another in sctp_process_init, but here it is
> > out of context.
> >
> > The decision on data chunk format is not made on this function but
> > higher in the stack and we can leverage that for sctp_process_init,
> > and for sctp_association_init, we should have it as close as possible
> > to where it initialized pathmtu and did not update the frag point.
> okay, but both have to be after sctp_stream_init().
> though we want sctp_assoc_update_frag_point()
> called right after "asoc->pathmtu = sp->pathmtu;".

Good point, sctp_datachk_len needs stream->si there.

> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index a827a1f..a614937 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -252,6 +252,8 @@ static struct sctp_association *sctp_association_init(
>                              0, gfp))
>                 goto fail_init;
> 

Can we move the asoc->pathmtu initialization down here too then?
I don't see anything that would block it.
Otherwise LGTM.

> +       sctp_assoc_update_frag_point(asoc);
> +
>         /* Assume that peer would support both address types unless we are
>          * told otherwise.
>          */
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 4a4fd19..600ca0d 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2462,6 +2462,8 @@ int sctp_process_init(struct sctp_association
> *asoc, struct sctp_chunk *chunk,
>                              asoc->c.sinit_max_instreams, gfp))
>                 goto clean_up;
> 
> +       sctp_assoc_update_frag_point(asoc);
> +
>         if (!asoc->temp && sctp_assoc_set_id(asoc, gfp))
>                 goto clean_up;
> 
> >
> > >  }
> > > --
> > > 2.1.0
> > >
