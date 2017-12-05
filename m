From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 05 Dec 2017 18:48:53 +0000
Subject: Re: [PATCH net-next 07/12] sctp: implement ulpevent_data for sctp_stream_interleave
Message-Id: <20171205184853.GC3328@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <7dd410b23c38f41fb8402880185f5e583dabbc04.1512486606.git.lucien.xin@gmail.com>
 <20171205182855.GA10327@hmswarspite.think-freely.org>
In-Reply-To: <20171205182855.GA10327@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Tue, Dec 05, 2017 at 01:28:55PM -0500, Neil Horman wrote:
> On Tue, Dec 05, 2017 at 11:16:04PM +0800, Xin Long wrote:
> > ulpevent_data is added as a member of sctp_stream_interleave, used to
> > do the most process in ulpq, including to convert data or idata chunk
> > to event, reasm them in reasm queue and put them in lobby queue in
> > right order, and deliver them up to user sk rx queue.
> > 
> > This procedure is described in section 2.2.3 of RFC8260.
> > 
> > It adds most functions for idata here to do the similar process as
> > the old functions for data. But since the details are very different
> > between them, the old functions can not be reused for idata.
> > 
> > event->ssn and event->ppid settings are moved to ulpevent_data from
> > sctp_ulpevent_make_rcvmsg, so that sctp_ulpevent_make_rcvmsg could
> > work for both data and idata.
> > 
> > Note that mid is added in sctp_ulpevent for idata, __packed has to
> > be used for defining sctp_ulpevent, or it would exceeds the skb cb
> > that saves a sctp_ulpevent variable for ulp layer process.
> > 
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/sctp/stream_interleave.h |   2 +
> >  include/net/sctp/structs.h           |   3 +
> >  include/net/sctp/ulpevent.h          |  20 +-
> >  net/sctp/sm_sideeffect.c             |   5 +-
> >  net/sctp/stream_interleave.c         | 418 +++++++++++++++++++++++++++++++++++
> >  net/sctp/ulpevent.c                  |   2 -
> >  net/sctp/ulpqueue.c                  |  12 +-
> >  7 files changed, 451 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
> > index d8d1b51..02f60f5 100644
> > --- a/include/net/sctp/stream_interleave.h
> > +++ b/include/net/sctp/stream_interleave.h
> > @@ -39,6 +39,8 @@ struct sctp_stream_interleave {
> >  					    int len, __u8 flags, gfp_t gfp);
> >  	void	(*assign_number)(struct sctp_chunk *chunk);
> >  	bool	(*validate_data)(struct sctp_chunk *chunk);
> > +	int	(*ulpevent_data)(struct sctp_ulpq *ulpq,
> > +				 struct sctp_chunk *chunk, gfp_t gfp);
> >  };
> >  
> >  void sctp_stream_interleave_init(struct sctp_stream *stream);
> > diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> > index 348b25e..d7da719 100644
> > --- a/include/net/sctp/structs.h
> > +++ b/include/net/sctp/structs.h
> > @@ -411,6 +411,8 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new);
> >  #define sctp_mid_skip(stream, type, sid, mid) \
> >  	((stream)->type[sid].mid = mid + 1)
> >  
> > +#define sctp_stream_in(asoc, sid) (&(asoc)->stream.in[sid])
> > +
> >  /*
> >   * Pointers to address related SCTP functions.
> >   * (i.e. things that depend on the address family.)
> > @@ -1386,6 +1388,7 @@ struct sctp_stream_in {
> >  		__u16 ssn;
> >  	};
> >  	__u32 fsn;
> > +	char pd_mode;
> >  };
> >  
> >  struct sctp_stream {
> > diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
> > index 231dc42..ce4f2aa 100644
> > --- a/include/net/sctp/ulpevent.h
> > +++ b/include/net/sctp/ulpevent.h
> > @@ -45,19 +45,29 @@
> >  /* A structure to carry information to the ULP (e.g. Sockets API) */
> >  /* Warning: This sits inside an skb.cb[] area.  Be very careful of
> >   * growing this structure as it is at the maximum limit now.
> > + *
> > + * sctp_ulpevent is saved in sk->cb(48 bytes), whose last 4 bytes
> > + * have been taken by sock_skb_cb, So here it has to use 'packed'
> > + * to make sctp_ulpevent fit into the rest 44 bytes.
> >   */
> >  struct sctp_ulpevent {
> >  	struct sctp_association *asoc;
> >  	struct sctp_chunk *chunk;
> >  	unsigned int rmem_len;
> > -	__u32 ppid;
> > +	union {
> > +		__u32 mid;
> > +		__u16 ssn;
> > +	};
> > +	union {
> > +		__u32 ppid;
> > +		__u32 fsn;
> > +	};
> >  	__u32 tsn;
> >  	__u32 cumtsn;
> >  	__u16 stream;
> > -	__u16 ssn;
> >  	__u16 flags;
> >  	__u16 msg_flags;
> > -};
> > +} __packed;
> >  
> What kind  of performance do you see before and after this patch?  I ask because
> it seems like the members between ppid through stream are going to be misaligned
> (not on a 4 byte boundary), now that you've made this structure packed.

It shouldn't be misaligned because the __u16 ssn field is wrapped on a union
with __u32 mid, causing the next field to be aligned on the largest member,
which is __u32.

FWIW, before:
struct sctp_ulpevent {
        struct sctp_association *  asoc;                 /*     0     8 */
        struct sctp_chunk *        chunk;                /*     8     8 */
        unsigned int               rmem_len;             /*    16     4 */
        __u32                      ppid;                 /*    20     4 */
        __u32                      tsn;                  /*    24     4 */
        __u32                      cumtsn;               /*    28     4 */
        __u16                      stream;               /*    32     2 */
        __u16                      ssn;                  /*    34     2 */
        __u16                      flags;                /*    36     2 */
        __u16                      msg_flags;            /*    38     2 */

        /* size: 40, cachelines: 1, members: 10 */
        /* last cacheline: 40 bytes */
};

and after:
struct sctp_ulpevent {
        struct sctp_association *  asoc;                 /*     0     8 */
        struct sctp_chunk *        chunk;                /*     8     8 */
        unsigned int               rmem_len;             /*    16     4 */
        union {
                __u32              mid;                  /*           4 */
                __u16              ssn;                  /*           2 */
        };                                               /*    20     4 */
        union {
                __u32              ppid;                 /*           4 */
                __u32              fsn;                  /*           4 */
        };                                               /*    24     4 */
        __u32                      tsn;                  /*    28     4 */
        __u32                      cumtsn;               /*    32     4 */
        __u16                      stream;               /*    36     2 */
        __u16                      flags;                /*    38     2 */
        __u16                      msg_flags;            /*    40     2 */

        /* size: 42, cachelines: 1, members: 10 */
        /* last cacheline: 42 bytes */
};

  Marcelo
