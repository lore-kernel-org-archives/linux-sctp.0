From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 04 Dec 2018 20:59:57 +0000
Subject: Re: [PATCH net] sctp: frag_point sanity check
Message-Id: <20181204205957.GB11247@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181204192741.35357-1-jakub.audykowicz@gmail.com>
 <20181204193946.GC31778@hmswarspite.think-freely.org>
 <20181204195202.GA11247@localhost.localdomain>
 <20181204205633.GD31778@hmswarspite.think-freely.org>
In-Reply-To: <20181204205633.GD31778@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jakub Audykowicz <jakub.audykowicz@gmail.com>, linux-sctp@vger.kernel.org, vyasevich@gmail.com, davem@davemloft.net, netdev@vger.kernel.org

On Tue, Dec 04, 2018 at 03:56:33PM -0500, Neil Horman wrote:
> On Tue, Dec 04, 2018 at 05:52:02PM -0200, Marcelo Ricardo Leitner wrote:
> > On Tue, Dec 04, 2018 at 02:39:46PM -0500, Neil Horman wrote:
> > > On Tue, Dec 04, 2018 at 08:27:41PM +0100, Jakub Audykowicz wrote:
> > > > If for some reason an association's fragmentation point is zero,
> > > > sctp_datamsg_from_user will try to endlessly try to divide a message
> > > > into zero-sized chunks. This eventually causes kernel panic due to
> > > > running out of memory.
> > > > 
> > > > Although this situation is quite unlikely, it has occurred before as
> > > > reported. I propose to add this simple last-ditch sanity check due to
> > > > the severity of the potential consequences.
> > > > 
> > > > Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> > > > ---
> > > >  include/net/sctp/sctp.h | 5 +++++
> > > >  net/sctp/chunk.c        | 6 ++++++
> > > >  net/sctp/socket.c       | 3 +--
> > > >  3 files changed, 12 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> > > > index ab9242e51d9e..2abbc15824af 100644
> > > > --- a/include/net/sctp/sctp.h
> > > > +++ b/include/net/sctp/sctp.h
> > > > @@ -620,4 +620,9 @@ static inline bool sctp_transport_pmtu_check(struct sctp_transport *t)
> > > >  	return false;
> > > >  }
> > > >  
> > > > +static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
> > > > +{
> > > > +	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
> > > > +}
> > > > +
> > > >  #endif /* __net_sctp_h__ */
> > > > diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> > > > index ce8087846f05..d5b91bc8a377 100644
> > > > --- a/net/sctp/chunk.c
> > > > +++ b/net/sctp/chunk.c
> > > > @@ -191,6 +191,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > > >  	 * the packet
> > > >  	 */
> > > >  	max_data = asoc->frag_point;
> > > > +	if (unlikely(!max_data)) {
> > > > +		max_data = sctp_min_frag_point(sctp_sk(asoc->base.sk),
> > > > +					       sctp_datachk_len(&asoc->stream));
> > > > +		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%d)",
> > > > +				    __func__, asoc, max_data);
> > > > +	}
> > > >  
> > > >  	/* If the the peer requested that we authenticate DATA chunks
> > > >  	 * we need to account for bundling of the AUTH chunks along with
> > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > index bf618d1b41fd..b8cebd5a87e5 100644
> > > > --- a/net/sctp/socket.c
> > > > +++ b/net/sctp/socket.c
> > > > @@ -3324,8 +3324,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
> > > >  		__u16 datasize = asoc ? sctp_datachk_len(&asoc->stream) :
> > > >  				 sizeof(struct sctp_data_chunk);
> > > >  
> > > > -		min_len = sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
> > > > -					   datasize);
> > > > +		min_len = sctp_min_frag_point(sp, datasize);
> > > >  		max_len = SCTP_MAX_CHUNK_LEN - datasize;
> > > >  
> > > >  		if (val < min_len || val > max_len)
> > > > -- 
> > > > 2.17.1
> > > > 
> > > > 
> > > Why not just prevent the frag point from ever going below
> > > SCTP_DEFAULT_MINSEGMENT in the first place in sctp_assoc_update_frag_point?
> > > Something like:
> > > 
> > > asoc->frag_point = SCTP_TRUNC4(frag) < SCTP_DEFAILT_MINSEGMENT) ? \
> > > SCTP_DEFAILT_MINSEGMENT : SCTP_TRUNC4(frag);
> > > 
> > > Should do the trick I would think
> > > Neil
> > 
> > This is in the light of "sctp: update frag_point when
> > stream_interleave is set".
> > 
> > Because of
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg256575.html
> > This wouldn't have helped because sctp_assoc_update_frag_point()
> > didn't get called. The issue is not that the calc issued a bad value,
> > but that it wasn't done.
> >  
> >   Marcelo
> > 
> Ah, thank you for the clarification.
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 

Cool!

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
