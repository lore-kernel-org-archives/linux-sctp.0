From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 05 Dec 2017 17:26:40 +0000
Subject: Re: [PATCH net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <20171205172640.GA3328@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Tue, Dec 05, 2017 at 11:16:01PM +0800, Xin Long wrote:
> To avoid hundreds of checks for the different process on I-DATA chunk,
> struct sctp_stream_interleave is defined as a group of functions used
> to replace the codes in some place where it needs to do different job
> according to if the asoc intl_enabled is set.
> 
> With these ops, it only needs to initialize asoc->stream.si with
> sctp_stream_interleave_0 for normal data if asoc intl_enable is 0,
> or sctp_stream_interleave_1 for idata if asoc intl_enable is set in
> sctp_stream_init.
> 
> After that, the members in asoc->stream.si can be used directly in
> some special places without checking asoc intl_enable.
> 
> make_datafrag is the first member for sctp_stream_interleave, it's
> used to make data or idata frags, called in sctp_datamsg_from_user.
> The old function sctp_make_datafrag_empty needs to be adjust some
> to fit in this ops.
> 
> Note that as idata and data chunks have different length, it also
> defines data_chunk_len for sctp_stream_interleave to describe the
> chunk size.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/sm.h                |  5 +--
>  include/net/sctp/stream_interleave.h | 44 ++++++++++++++++++++
>  include/net/sctp/structs.h           | 11 +++++
>  net/sctp/Makefile                    |  2 +-
>  net/sctp/chunk.c                     |  6 +--
>  net/sctp/sm_make_chunk.c             | 21 ++++------
>  net/sctp/stream.c                    |  1 +
>  net/sctp/stream_interleave.c         | 79 ++++++++++++++++++++++++++++++++++++
>  8 files changed, 148 insertions(+), 21 deletions(-)
>  create mode 100644 include/net/sctp/stream_interleave.h
>  create mode 100644 net/sctp/stream_interleave.c
> 
> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> index 5389ae0..f950186 100644
> --- a/include/net/sctp/sm.h
> +++ b/include/net/sctp/sm.h
> @@ -199,10 +199,9 @@ struct sctp_chunk *sctp_make_cwr(const struct sctp_association *asoc,
>  				 const struct sctp_chunk *chunk);
>  struct sctp_chunk *sctp_make_idata(const struct sctp_association *asoc,
>  				   __u8 flags, int paylen, gfp_t gfp);
> -struct sctp_chunk *sctp_make_datafrag_empty(struct sctp_association *asoc,
> +struct sctp_chunk *sctp_make_datafrag_empty(const struct sctp_association *asoc,
>  					    const struct sctp_sndrcvinfo *sinfo,
> -					    int len, const __u8 flags,
> -					    __u16 ssn, gfp_t gfp);
> +					    int len, __u8 flags, gfp_t gfp);
>  struct sctp_chunk *sctp_make_ecne(const struct sctp_association *asoc,
>  				  const __u32 lowest_tsn);
>  struct sctp_chunk *sctp_make_sack(const struct sctp_association *asoc);
> diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
> new file mode 100644
> index 0000000..7b9fa8d
> --- /dev/null
> +++ b/include/net/sctp/stream_interleave.h
> @@ -0,0 +1,44 @@
> +/* SCTP kernel implementation
> + * (C) Copyright Red Hat Inc. 2017
> + *
> + * These are definitions used by the stream schedulers, defined in RFC
> + * draft ndata (https://tools.ietf.org/html/draft-ietf-tsvwg-sctp-ndata-11)
> + *
> + * This SCTP implementation is free software;
> + * you can redistribute it and/or modify it under the terms of
> + * the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + *
> + * This SCTP implementation  is distributed in the hope that it
> + * will be useful, but WITHOUT ANY WARRANTY; without even the implied
> + *                 ************************
> + * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with GNU CC; see the file COPYING.  If not, see
> + * <http://www.gnu.org/licenses/>.
> + *
> + * Please send any bug reports or fixes you make to the
> + * email addresses:
> + *    lksctp developers <linux-sctp@vger.kernel.org>
> + *
> + * Written or modified by:
> + *   Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#ifndef __sctp_stream_interleave_h__
> +#define __sctp_stream_interleave_h__
> +
> +struct sctp_stream_interleave {
> +	__u16	data_chunk_len;
> +	/* (I-)DATA process */
> +	struct sctp_chunk *(*make_datafrag)(const struct sctp_association *asoc,
> +					    const struct sctp_sndrcvinfo *sinfo,
> +					    int len, __u8 flags, gfp_t gfp);
> +};
> +
> +void sctp_stream_interleave_init(struct sctp_stream *stream);
> +
> +#endif /* __sctp_stream_interleave_h__ */
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 15183bf..ae7225b 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -89,6 +89,7 @@ struct sctp_stream;
>  #include <net/sctp/tsnmap.h>
>  #include <net/sctp/ulpevent.h>
>  #include <net/sctp/ulpqueue.h>
> +#include <net/sctp/stream_interleave.h>
>  
>  /* Structures useful for managing bind/connect. */
>  
> @@ -1388,11 +1389,21 @@ struct sctp_stream {
>  			struct sctp_stream_out_ext *rr_next;
>  		};
>  	};
> +	struct sctp_stream_interleave *si;
>  };
>  
>  #define SCTP_STREAM_CLOSED		0x00
>  #define SCTP_STREAM_OPEN		0x01
>  
> +static inline __u16 sctp_datachk_len(const struct sctp_stream *stream)
> +{
> +	return stream->si->data_chunk_len;
> +}

checkpatch complained about a missing blank line here.

> +static inline __u16 sctp_datahdr_len(const struct sctp_stream *stream)
> +{
> +	return stream->si->data_chunk_len - sizeof(struct sctp_chunkhdr);
> +}
> +
>  /* SCTP_GET_ASSOC_STATS counters */
>  struct sctp_priv_assoc_stats {
>  	/* Maximum observed rto in the association during subsequent
> diff --git a/net/sctp/Makefile b/net/sctp/Makefile
> index 1ca84a2..54bd9c1 100644
> --- a/net/sctp/Makefile
> +++ b/net/sctp/Makefile
> @@ -14,7 +14,7 @@ sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
>  	  tsnmap.o bind_addr.o socket.o primitive.o \
>  	  output.o input.o debug.o stream.o auth.o \
>  	  offload.o stream_sched.o stream_sched_prio.o \
> -	  stream_sched_rr.o
> +	  stream_sched_rr.o stream_interleave.o
>  
>  sctp_probe-y := probe.o
>  
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 7b261af..bded6af 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -190,7 +190,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  	 */
>  	max_data = asoc->pathmtu -
>  		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
> -		   sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk);
> +		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream);
>  	max_data = SCTP_TRUNC4(max_data);
>  
>  	/* If the the peer requested that we authenticate DATA chunks
> @@ -263,8 +263,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  				frag |= SCTP_DATA_SACK_IMM;
>  		}
>  
> -		chunk = sctp_make_datafrag_empty(asoc, sinfo, len, frag,
> -						 0, GFP_KERNEL);
> +		chunk = asoc->stream.si->make_datafrag(asoc, sinfo, len, frag,
> +						       GFP_KERNEL);
>  		if (!chunk) {
>  			err = -ENOMEM;
>  			goto errout;
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index b969397..23a7313 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -721,38 +721,31 @@ struct sctp_chunk *sctp_make_ecne(const struct sctp_association *asoc,
>  /* Make a DATA chunk for the given association from the provided
>   * parameters.  However, do not populate the data payload.
>   */
> -struct sctp_chunk *sctp_make_datafrag_empty(struct sctp_association *asoc,
> +struct sctp_chunk *sctp_make_datafrag_empty(const struct sctp_association *asoc,
>  					    const struct sctp_sndrcvinfo *sinfo,
> -					    int data_len, __u8 flags, __u16 ssn,
> -					    gfp_t gfp)
> +					    int len, __u8 flags, gfp_t gfp)
>  {
>  	struct sctp_chunk *retval;
>  	struct sctp_datahdr dp;
> -	int chunk_len;
>  
>  	/* We assign the TSN as LATE as possible, not here when
>  	 * creating the chunk.
>  	 */
> -	dp.tsn = 0;
> +	memset(&dp, 0, sizeof(dp));
> +	dp.ppid = sinfo->sinfo_ppid;
>  	dp.stream = htons(sinfo->sinfo_stream);
> -	dp.ppid   = sinfo->sinfo_ppid;
>  
>  	/* Set the flags for an unordered send.  */
> -	if (sinfo->sinfo_flags & SCTP_UNORDERED) {
> +	if (sinfo->sinfo_flags & SCTP_UNORDERED)
>  		flags |= SCTP_DATA_UNORDERED;
> -		dp.ssn = 0;
> -	} else
> -		dp.ssn = htons(ssn);
>  
> -	chunk_len = sizeof(dp) + data_len;
> -	retval = sctp_make_data(asoc, flags, chunk_len, gfp);
> +	retval = sctp_make_data(asoc, flags, sizeof(dp) + len, gfp);
>  	if (!retval)
> -		goto nodata;
> +		return NULL;
>  
>  	retval->subh.data_hdr = sctp_addto_chunk(retval, sizeof(dp), &dp);
>  	memcpy(&retval->sinfo, sinfo, sizeof(struct sctp_sndrcvinfo));
>  
> -nodata:
>  	return retval;
>  }
>  
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 76ea66b..8370e6c 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -167,6 +167,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>  	sched->init(stream);
>  
>  in:
> +	sctp_stream_interleave_init(stream);
>  	if (!incnt)
>  		goto out;
>  
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> new file mode 100644
> index 0000000..397c3c1
> --- /dev/null
> +++ b/net/sctp/stream_interleave.c
> @@ -0,0 +1,79 @@
> +/* SCTP kernel implementation
> + * (C) Copyright Red Hat Inc. 2017
> + *
> + * This file is part of the SCTP kernel implementation
> + *
> + * These functions manipulate sctp stream queue/scheduling.
> + *
> + * This SCTP implementation is free software;
> + * you can redistribute it and/or modify it under the terms of
> + * the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + *
> + * This SCTP implementation is distributed in the hope that it
> + * will be useful, but WITHOUT ANY WARRANTY; without even the implied
> + *                 ************************
> + * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with GNU CC; see the file COPYING.  If not, see
> + * <http://www.gnu.org/licenses/>.
> + *
> + * Please send any bug reports or fixes you make to the
> + * email addresched(es):
> + *    lksctp developers <linux-sctp@vger.kernel.org>
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#include <net/sctp/sctp.h>
> +#include <net/sctp/sm.h>
> +#include <linux/sctp.h>
> +
> +static struct sctp_chunk *sctp_make_idatafrag_empty(

And that the line shouldn't end with the (
but the parameter is big.. I don't see a good way here.

> +					const struct sctp_association *asoc,
> +					const struct sctp_sndrcvinfo *sinfo,
> +					int len, __u8 flags, gfp_t gfp)
> +{
> +	struct sctp_chunk *retval;
> +	struct sctp_idatahdr dp;
> +
> +	memset(&dp, 0, sizeof(dp));
> +	dp.stream = htons(sinfo->sinfo_stream);
> +
> +	if (sinfo->sinfo_flags & SCTP_UNORDERED)
> +		flags |= SCTP_DATA_UNORDERED;
> +
> +	retval = sctp_make_idata(asoc, flags, sizeof(dp) + len, gfp);
> +	if (!retval)
> +		return NULL;
> +
> +	retval->subh.idata_hdr = sctp_addto_chunk(retval, sizeof(dp), &dp);
> +	memcpy(&retval->sinfo, sinfo, sizeof(struct sctp_sndrcvinfo));
> +
> +	return retval;
> +}
> +
> +static struct sctp_stream_interleave sctp_stream_interleave_0 = {
> +	.data_chunk_len		= sizeof(struct sctp_data_chunk),
> +	/* DATA process functions */
> +	.make_datafrag		= sctp_make_datafrag_empty,
> +};
> +
> +static struct sctp_stream_interleave sctp_stream_interleave_1 = {
> +	.data_chunk_len		= sizeof(struct sctp_idata_chunk),
> +	/* I-DATA process functions */
> +	.make_datafrag		= sctp_make_idatafrag_empty,
> +};
> +
> +void sctp_stream_interleave_init(struct sctp_stream *stream)
> +{
> +	struct sctp_association *asoc;
> +
> +	asoc = container_of(stream, struct sctp_association, stream);
> +	stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
> +				       : &sctp_stream_interleave_0;
> +}
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
