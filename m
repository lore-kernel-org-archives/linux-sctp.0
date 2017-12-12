From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Dec 2017 13:59:03 +0000
Subject: Re: [PATCH net-next 3/8] sctp: implement validate_ftsn for sctp_stream_interleave
Message-Id: <CADvbK_chy_Emz8qkLJwKb_2v4nFZWVzs9WF-zMhqDiLJy7GpCQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513070662.git.lucien.xin@gmail.com> <807b1707f79b11d5883d71ea771e98e8f7af3ead.1513070662.git.lucien.xin@gmail.com>
 <20171212131853.GB3532@localhost.localdomain> <CADvbK_d5ZqBtyuWYOJ19gwcd51g0Vgcdq-xCjevqwGpTgC-yDQ@mail.gmail.com>
 <20171212133700.GD3532@localhost.localdomain>
In-Reply-To: <20171212133700.GD3532@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>

On Tue, Dec 12, 2017 at 9:37 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Tue, Dec 12, 2017 at 09:31:36PM +0800, Xin Long wrote:
>> On Tue, Dec 12, 2017 at 9:18 PM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>> > On Tue, Dec 12, 2017 at 05:25:54PM +0800, Xin Long wrote:
>> > ...
>> >> --- a/net/sctp/sm_statetable.c
>> >> +++ b/net/sctp/sm_statetable.c
>> >> @@ -992,7 +992,8 @@ static const struct sctp_sm_table_entry *sctp_chunk_event_lookup(
>> >>               return &chunk_event_table[cid][state];
>> >>
>> >>       if (net->sctp.prsctp_enable) {
>> >> -             if (cid = SCTP_CID_FWD_TSN)
>> >> +             if (cid = SCTP_CID_FWD_TSN ||
>> >> +                 (net->sctp.intl_enable && cid = SCTP_CID_I_FWD_TSN))
>> >
>> > We don't really need to check intl_enable here, do we?
>> We think net->sctp.xxx_enable as a main switch here,
>> that means it only accepts SCTP_CID_I_FWD_TSN
>> when this switch is open.
>
> Yes, but
>
>>
>> As for the check in validate_ftsn(), it follows the RFC checking
>> on asoc's intl_enable.
>
> Yes.
>
>>
>> does it make sense from this perspective ?
>
> Sort of. We need consistency. If we want do discard such invalid
> chunks right here, that condition also needs to ensure that fwd_tsn
> chunks are actually allowed (IOW, that intl_enable is false).
>
> And we don't do any check for idata chunks. We just just accept them
> and discard later when trying to consume it.
Yeah, seems not a good idea to check intl_enable here, it's not like
other _enable.

intl_enable is more like a 'which' option, while other _enables are
like 'yes or no' option.

I will just remove intl_enable checks, for both ifwdtsn and idata.

Thanks.

>
>>
>>
>>
>> > Because a) it should actually look like:
>> > -               if (cid = SCTP_CID_FWD_TSN)
>> > +               if ((!net->sctp.intl_enable && cid = SCTP_CID_FWD_TSN) ||
>> > +                   (net->sctp.intl_enable && cid = SCTP_CID_I_FWD_TSN))
>> > but b) we will validate the chunk format/feature later with
>> > validate_ftsn(), similarly to what happens with data chunks, so it
>> > seems the check on intl_enable here is not necessary.
>> >
>> > Same happens with data chunks, btw.
>> >
>> >>                       return &prsctp_chunk_event_table[0][state];
>> >>       }
>> >>
>> >> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
>> >> index 2ead372..cc4a5e3 100644
>> >> --- a/net/sctp/stream_interleave.c
>> >> +++ b/net/sctp/stream_interleave.c
>> >> @@ -1153,8 +1153,49 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
>> >>       }
>> >>  }
>> >>
>> >> +#define _sctp_walk_ifwdtsn(pos, chunk, end) \
>> >> +     for (pos = chunk->subh.ifwdtsn_hdr->skip; \
>> >> +          (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
>> >> +
>> >> +#define sctp_walk_ifwdtsn(pos, ch) \
>> >> +     _sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
>> >> +                                     sizeof(struct sctp_ifwdtsn_chunk))
>> >> +
>> >> +static bool sctp_validate_fwdtsn(struct sctp_chunk *chunk)
>> >> +{
>> >> +     struct sctp_fwdtsn_skip *skip;
>> >> +     __u16 incnt;
>> >> +
>> >> +     if (chunk->chunk_hdr->type != SCTP_CID_FWD_TSN)
>> >> +             return false;
>> >> +
>> >> +     incnt = chunk->asoc->stream.incnt;
>> >> +     sctp_walk_fwdtsn(skip, chunk)
>> >> +             if (ntohs(skip->stream) >= incnt)
>> >> +                     return false;
>> >> +
>> >> +     return true;
>> >> +}
>> >> +
>> >> +static bool sctp_validate_iftsn(struct sctp_chunk *chunk)
>> >> +{
>> >> +     struct sctp_ifwdtsn_skip *skip;
>> >> +     __u16 incnt;
>> >> +
>> >> +     if (chunk->chunk_hdr->type != SCTP_CID_I_FWD_TSN)
>> >> +             return false;
>> >> +
>> >> +     incnt = chunk->asoc->stream.incnt;
>> >> +     sctp_walk_ifwdtsn(skip, chunk)
>> >> +             if (ntohs(skip->stream) >= incnt)
>> >> +                     return false;
>> >> +
>> >> +     return true;
>> >> +}
>> >> +
>> >>  static struct sctp_stream_interleave sctp_stream_interleave_0 = {
>> >>       .data_chunk_len         = sizeof(struct sctp_data_chunk),
>> >> +     .ftsn_chunk_len         = sizeof(struct sctp_fwdtsn_chunk),
>> >>       /* DATA process functions */
>> >>       .make_datafrag          = sctp_make_datafrag_empty,
>> >>       .assign_number          = sctp_chunk_assign_ssn,
>> >> @@ -1166,10 +1207,12 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
>> >>       .abort_pd               = sctp_ulpq_abort_pd,
>> >>       /* FORWARD-TSN process functions */
>> >>       .generate_ftsn          = sctp_generate_fwdtsn,
>> >> +     .validate_ftsn          = sctp_validate_fwdtsn,
>> >>  };
>> >>
>> >>  static struct sctp_stream_interleave sctp_stream_interleave_1 = {
>> >>       .data_chunk_len         = sizeof(struct sctp_idata_chunk),
>> >> +     .ftsn_chunk_len         = sizeof(struct sctp_ifwdtsn_chunk),
>> >>       /* I-DATA process functions */
>> >>       .make_datafrag          = sctp_make_idatafrag_empty,
>> >>       .assign_number          = sctp_chunk_assign_mid,
>> >> @@ -1181,6 +1224,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
>> >>       .abort_pd               = sctp_intl_abort_pd,
>> >>       /* I-FORWARD-TSN process functions */
>> >>       .generate_ftsn          = sctp_generate_iftsn,
>> >> +     .validate_ftsn          = sctp_validate_iftsn,
>> >>  };
>> >>
>> >>  void sctp_stream_interleave_init(struct sctp_stream *stream)
>> >> --
>> >> 2.1.0
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
