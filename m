From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 30 Nov 2018 06:22:39 +0000
Subject: Re: [PATCHv2 net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <CADvbK_cJOBrSFumcEOtyKL0eBwYHFg__Ob37Z1H7Ty-sPow0dw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <8a5df8eb5cc41dfc3d08e294147b9729bbe90aa0.1543473776.git.lucien.xin@gmail.com>
 <20181129143855.GB14550@hmswarspite.think-freely.org>
In-Reply-To: <20181129143855.GB14550@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Thu, Nov 29, 2018 at 11:39 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, Nov 29, 2018 at 02:42:56PM +0800, Xin Long wrote:
> > Now when using stream reconfig to add out streams, stream->out
> > will get re-allocated, and all old streams' information will
> > be copied to the new ones and the old ones will be freed.
> >
> > So without stream->out_curr updated, next time when trying to
> > send from stream->out_curr stream, a panic would be caused.
> >
> > This patch is to check and update stream->out_curr when
> > allocating stream_out.
> >
> > v1->v2:
> >   - define fa_index() to get elem index from stream->out_curr.
> >
> > Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> > Reported-by: Ying Xu <yinxu@redhat.com>
> > Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/stream.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index 3892e76..30e7809 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -84,6 +84,19 @@ static void fa_zero(struct flex_array *fa, size_t index, size_t count)
> >       }
> >  }
> >
> > +static size_t fa_index(struct flex_array *fa, void *elem, size_t count)
> > +{
> > +     size_t index = 0;
> > +
> > +     while (count--) {
> > +             if (elem = flex_array_get(fa, index))
> > +                     break;
> > +             index++;
> > +     }
> > +
> > +     return index;
> > +}
> > +
> >  /* Migrates chunks from stream queues to new stream queues if needed,
> >   * but not across associations. Also, removes those chunks to streams
> >   * higher than the new max.
> > @@ -147,6 +160,13 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> >
> >       if (stream->out) {
> >               fa_copy(out, stream->out, 0, min(outcnt, stream->outcnt));
> > +             if (stream->out_curr) {
> > +                     size_t index = fa_index(stream->out, stream->out_curr,
> > +                                             stream->outcnt);
> > +
> > +                     BUG_ON(index = stream->outcnt);
> > +                     stream->out_curr = flex_array_get(out, index);
> > +             }
> >               fa_free(stream->out);
> >       }
> >
> > --
> > 2.1.0
> >
> >
>
> This is the sort of thing I'm talking about. Its a little more code, but if you
> augment the flex_array api like this, you can preform a resize operation on your
> existing flex array, and you can avoid all the copying, and need to update
> pointers maintained outside the array.  Note this code isn't tested at all, but
> its close to what I think should work.
>
>
> diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
> index b94fa61b51fb..7fa1f27a91b5 100644
> --- a/include/linux/flex_array.h
> +++ b/include/linux/flex_array.h
> @@ -73,6 +73,8 @@ struct flex_array {
>  struct flex_array *flex_array_alloc(int element_size, unsigned int total,
>                 gfp_t flags);
>
> +struct flex_array *flex_array_resize(struct flex_array *fa, unsigned int total, gfp_t flags);
> +
>  /**
>   * flex_array_prealloc() - Ensures that memory for the elements indexed in the
>   * range defined by start and nr_elements has been allocated.
> diff --git a/lib/flex_array.c b/lib/flex_array.c
> index 2eed22fa507c..f8d54af3891b 100644
> --- a/lib/flex_array.c
> +++ b/lib/flex_array.c
> @@ -109,6 +109,7 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
>         ret->total_nr_elements = total;
>         ret->elems_per_part = elems_per_part;
>         ret->reciprocal_elems = reciprocal_elems;
> +       ret->elements_used = 0;
>         if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
>                 memset(&ret->parts[0], FLEX_ARRAY_FREE,
>                                                 FLEX_ARRAY_BASE_BYTES_LEFT);
> @@ -116,6 +117,53 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
>  }
>  EXPORT_SYMBOL(flex_array_alloc);
>
> +static int flex_array_last_element_index(struct flex_array *fa)
> +{
> +       struct flex_array_part *part;
> +       int part_nr;
> +       int i,j;
> +
> +       if (elements_fit_in_base(fa)) {
> +               part = (struct flex_array_part *)&fa->parts[0];
> +               for (i = fa->elems_per_part; i >= 0; i--)
> +                       if (part->elements[i] != FLEX_ARRAY_FREE)
> +                               return i;
> +       }
> +
> +       i = fa->total_nr_elements;
> +       for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
> +               part = fa->parts[part_nr];
> +               if (!part) {
> +                       i -= fa->elems_per_part;
> +                       continue;
> +               }
> +               for (j = fa->elems_per_part; j >= 0; j--, i--)
> +                       if (part->elements[j] != FLEX_ARRAY_FREE)
> +                               goto out;
> +       }
> +out:
> +       return i;
> +}
> +
> +struct flex_array *flex_array_resize(struct flex_array *fa, unsigned int total, gfp_t flags)
> +{
> +       if (total >= fa->total_nr_elements) {
> +               /* Grow case */
> +               if (total > max_size)
> +                       return ERR_PTR(-ETOOBIG);
> +               fa->total_nr_elements = total;
> +       } else {
> +               /* Shrink case */
> +               /* Drop any pages we don't need*/
> +               flex_array_shrink(fa);
> +               if (flex_array_last_element_index(fa) >= total)
> +                       return ERR_PTR(-ESIZE);
> +               fa->total_nr_elements = total;
> +       }
> +       return fa;
> +}
> +EXPORT_SYMBOL(flex_array_resize);
> +
>  static int fa_element_to_part_nr(struct flex_array *fa,
>                                         unsigned int element_nr)
>  {
I have a question about how it checks one part is free in
flex_array_shrink():
  part_is_free() is doing it by checking:
  if (part->elements[all] = FLEX_ARRAY_FREE) ...

What if the data in the array that users put is FLEX_ARRAY_FREE,
it will be treated as free, but in fact it's still in use?
