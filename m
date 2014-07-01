From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 01 Jul 2014 12:47:02 +0000
Subject: Re: [PATCH net-next 2/3] net: sctp: Optimise the way 'sctp_arg_t' values are initialised
Message-Id: <20140701124702.GH7322@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D17269789@AcuExch.aculab.com>
 <20140701113207.GC7322@hmsreliant.think-freely.org>
 <063D6719AE5E284EB5DD2968C1650D6D1726A9D7@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726A9D7@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: Network Development <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>

On Tue, Jul 01, 2014 at 12:34:26PM +0000, David Laight wrote:
> From: Neil Horman [mailto:nhorman@tuxdriver.com]
> > On Mon, Jun 30, 2014 at 01:01:07PM +0000, David Laight wrote:
> > > Even if memset() is inlined (as on x86) using it to zero the union
> > > generates a memory word write of zero, followed by a write of the
> > > smaller field, and then a read of the word.
> > > As well as being a lot of instructions the sequence is unlikely to
> > > be optimised by the store-load forward hardware so will be slow.
> > >
> > > Instead allocate a field of the union that is the same size as the
> > > entire union and write a zero value to it. The compiler will then
> > > generate the required value in a register.
> > >
> > > Signed-off-by: David Laight <david.laight@aculab.com>
> > > ---
> > >  include/net/sctp/command.h | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
> > > index 020eb95..5fcd1a7 100644
> > > --- a/include/net/sctp/command.h
> > > +++ b/include/net/sctp/command.h
> > > @@ -118,6 +118,7 @@ typedef enum {
> > >  #define SCTP_MAX_NUM_COMMANDS 18
> > >
> > >  typedef union {
> > > +	void *zero_all;	/* Set to NULL to clear the entire union */
> > >  	__s32 i32;
> > >  	__u32 u32;
> > >  	__be32 be32;
> > > @@ -154,7 +155,7 @@ typedef union {
> > >  static inline sctp_arg_t	\
> > >  SCTP_## name (type arg)		\
> > >  { sctp_arg_t retval;\
> > > -  memset(&retval, 0, sizeof(sctp_arg_t));\
> > > +  retval.zero_all = NULL;\
> > >    retval.elt = arg;\
> > >    return retval;\
> > >  }
> > > @@ -191,7 +192,7 @@ static inline sctp_arg_t SCTP_NOFORCE(void)
> > >  static inline sctp_arg_t SCTP_NULL(void)
> > >  {
> > >  	sctp_arg_t retval;
> > > -	memset(&retval, 0, sizeof(sctp_arg_t));
> > > +	retval.zero_all = NULL;
> > >  	return retval;
> > >  }
> > >
> > > @@ -212,7 +213,6 @@ typedef struct {
> > >   */
> > >  static inline int sctp_init_cmd_seq(sctp_cmd_seq_t *seq)
> > >  {
> > > -	memset(seq, 0, sizeof(sctp_cmd_seq_t));
> > >  	return 1;		/* We always succeed.  */
> > >  }
> > >
> > > --
> > > 1.8.1.2
> > >
> > I get the advantage here, but this seems a bit rickety to me, in that it relies
> > on the size of the union never being more than sizeof(void *) bytes long.  I
> > understand thats not likely to happen, but its not the sort of thing we're
> > likely to notice if it does.
> > 
> > That said, I'd almost make the argument that we don't need to do this zeroing at
> > all.  A while back I fixed a few outlier cases where we accidentally read a
> > union member which we didn't set, so now we shouldn't have any type punning
> > going on here.  It should be sufficient to just set the field you want, and
> > leave it at that.
> 
> On a 'big endian' system reading a wrong-sized member won't give the correct
> value anyway.
> 
> One benefit of zeroing the union is that diagnostic traces (added for debug)
> will give sane values regardless of the member printed.
> OTOH no such traces actually exist.
> 
> With the patch, the generated code on amd64 is probably almost exactly
> the same as that without the zeroing. The same is probable true for most LE
> systems.
> I haven't looked at how gcc handles the union on BE systems - but it is
> likely to be a lot better if it isn't zeroed at all (or if all the fields
> are the size of the union).
> 
> 	David
>  
Is it worth considering making a slab cache out of this?  We could amortize the
cost of the zeroing then by doing it per slab, and then we wouldn't have to
worry about making sure we always zero the largest element.
Neil

> 
> 
> 
