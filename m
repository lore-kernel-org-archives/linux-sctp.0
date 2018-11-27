From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 27 Nov 2018 14:43:04 +0000
Subject: Re: [PATCH net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <20181127144304.GA19586@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <3abaeca7357361956c7c5629544aeb7704353308.1543231325.git.lucien.xin@gmail.com>
 <20181126125351.GB18847@hmswarspite.think-freely.org>
 <CADvbK_cvJYeuvjfahaWV-O3EGcm3cnSPDcXftQGQjw_mr8WFBw@mail.gmail.com>
 <20181126135846.GC18847@hmswarspite.think-freely.org>
 <CADvbK_fOv0+9bx1APO4rPwnRjYYC=Mov_803zCLAVAU7TgpekQ@mail.gmail.com>
In-Reply-To: <CADvbK_fOv0+9bx1APO4rPwnRjYYC=Mov_803zCLAVAU7TgpekQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Tue, Nov 27, 2018 at 07:30:49PM +0900, Xin Long wrote:
> On Mon, Nov 26, 2018 at 10:59 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Mon, Nov 26, 2018 at 10:46:33PM +0900, Xin Long wrote:
> > > On Mon, Nov 26, 2018 at 9:54 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > >
> > > > On Mon, Nov 26, 2018 at 07:22:05PM +0800, Xin Long wrote:
> > > > > Now when using stream reconfig to add out streams, stream->out
> > > > > will get re-allocated, and all old streams' information will
> > > > > be copied to the new ones and the old ones will be freed.
> > > > >
> > > > > So without stream->out_curr updated, next time when trying to
> > > > > send from stream->out_curr stream, a panic would be caused.
> > > > >
> > > > > This patch is to define sctp_stream_out_copy used to update the
> > > > > stream->out_curr pointer to the new stream when copying the old
> > > > > streams' information.
> > > > >
> > > > > While at it, rename fa_copy to sctp_stream_in_copy.
> > > > >
> > > > > Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> > > > > Reported-by: Ying Xu <yinxu@redhat.com>
> > > > > Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
> > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > ---
> > > > >  net/sctp/stream.c | 46 ++++++++++++++++++++++++++++++++--------------
> > > > >  1 file changed, 32 insertions(+), 14 deletions(-)
> > > > >
> > > > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > > > index 3892e76..0687eeb 100644
> > > > > --- a/net/sctp/stream.c
> > > > > +++ b/net/sctp/stream.c
> > > > > @@ -61,18 +61,6 @@ static void fa_free(struct flex_array *fa)
> > > > >               flex_array_free(fa);
> > > > >  }
> > > > >
> > > > > -static void fa_copy(struct flex_array *fa, struct flex_array *from,
> > > > > -                 size_t index, size_t count)
> > > > > -{
> > > > > -     void *elem;
> > > > > -
> > > > > -     while (count--) {
> > > > > -             elem = flex_array_get(from, index);
> > > > > -             flex_array_put(fa, index, elem, 0);
> > > > > -             index++;
> > > > > -     }
> > > > > -}
> > > > > -
> > > > >  static void fa_zero(struct flex_array *fa, size_t index, size_t count)
> > > > >  {
> > > > >       void *elem;
> > > > > @@ -135,6 +123,36 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
> > > > >               kfree(SCTP_SO(stream, i)->ext);
> > > > >  }
> > > > >
> > > > > +static void sctp_stream_in_copy(struct flex_array *fa,
> > > > > +                             struct sctp_stream *stream, __u16 count)
> > > > > +{
> > > > > +     size_t index = 0;
> > > > > +     void *elem;
> > > > > +
> > > > > +     count = min(count, stream->incnt);
> > > > > +     while (count--) {
> > > > > +             elem = flex_array_get(stream->in, index);
> > > > > +             flex_array_put(fa, index, elem, 0);
> > > > > +             index++;
> > > > > +     }
> > > > > +}
> > > > > +
> > > > > +static void sctp_stream_out_copy(struct flex_array *fa,
> > > > > +                              struct sctp_stream *stream, __u16 count)
> > > > > +{
> > > > > +     size_t index = 0;
> > > > > +     void *elem;
> > > > > +
> > > > > +     count = min(count, stream->outcnt);
> > > > > +     while (count--) {
> > > > > +             elem = flex_array_get(stream->out, index);
> > > > > +             flex_array_put(fa, index, elem, 0);
> > > > > +             if (stream->out_curr = elem)
> > > > > +                     stream->out_curr = flex_array_get(fa, index);
> > > > > +             index++;
> > > > > +     }
> > > > > +}
> > > > > +
> > > > Seems like you are duplicating code here.  I think you would be better off
> > > > moving the fa_copy routine to the flex_array api (perhaps renaming it
> > > > flex_array_copy), and then codig sctp_stream_*_copy as static inlines that just
> > > > call the flex_array api to do the copy.  As for setting the out_curr pointer,
> > > > perhaps you should convert that to an index, so it can be looked up on demand,
> > > changing to use index only for this  may not worth it.
> > > there is no API from flex_array to convert element to index either
> > > the index is also the stream_id, but we didn't save it into stream_out
> > > either, too.
> > >
> > Right, I'm saying it would be valuable to augment the flex_array api to include
> > a copy function, as well as a pointer to index lookup element, that could have
> > use beyond just sctp.
> What do you think of this?
> 
> It's not called in tx/rx path, so no performance problem caused.
> Since only SCTP is using fa_xxx(), I will not move any to
> lib/flex_array.c for now.
> 
> +static size_t fa_index(struct flex_array *fa, void *elem, size_t count)
> +{
> +       size_t index = 0;
> +
> +       while (count--)
> +               if (elem = flex_array_get(fa, index++))
> +                       break;
> +
> +       return index;
> +}
> +
>  /* Migrates chunks from stream queues to new stream queues if needed,
>   * but not across associations. Also, removes those chunks to streams
>   * higher than the new max.
> @@ -147,6 +158,13 @@ static int sctp_stream_alloc_out(struct
> sctp_stream *stream, __u16 outcnt,
> 
>         if (stream->out) {
>                 fa_copy(out, stream->out, 0, min(outcnt, stream->outcnt));
> +               if (stream->out_curr) {
> +                       size_t index = fa_index(stream->out, stream->out_curr,
> +                                               stream->outcnt);
> +
> +                       BUG_ON(index = stream->outcnt);
> +                       stream->out_curr = flex_array_get(out, index);
> +               }
>                 fa_free(stream->out);
>         }
> 

I like this idea, I think its more concise than what you had the first time,
though as I'm reading over the flex array code, it seems like what might be even
better would be a flex_array_grow function, that internally adjusted the
flex_array structure to house the new maximum number of elements, and krealloced
the parts[] array to accordingly.  There is already a flex_array_shrink
function, so it seems there would be a use for its corresponding grow method
genreally speaking, and implementing it that way would avoid the need to do all
this copying, and checking for the current element pointer, as a realloc would
allow the existing memory to remain in place unaltered.

As for implementing in the flex array code vs the sctp code, I'll let Dave be
the deciding factor on that, but it would be my preference to implement this as
a general mechanism in the flex array code so others can make use of it.

Best
Neil

> >
> > > > so that it doesn't have to be updated here at all, or alternatively, just set it
> > > > back to NULL here so that the selected scheduler will be forced to do the next
> > > > lookup.
> > > We can't set it back to NULL. Otherwise, the scheduler may go to
> > > send other msg if the last msg (with multiple chunks) is not yet sent
> > > out completely, which is not allowed when it's not I-Data chunk.
> > >
> > If setting it back to NULL isn't valid, then the above is your solution.
> >
> > > This is not much duplicating, and this can reduce few params.
> > > I'm actually ok with this.
> > >
> > I know your ok with it, you wrote the patch :).  I however, am not really ok
> > with the duplication.  I would like to see it collapsed, if its not going to
> > create a significant performance impact.
> >
> > Neil
> >
> 
