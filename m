From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 11 Dec 2017 18:28:12 +0000
Subject: Re: [PATCH net] sctp: make sure stream nums can match optlen in sctp_setsockopt_reset_streams
Message-Id: <20171211182812.GC18284@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <a6c86b9cb13c2b6e2ed2539c028557a6b1a713ef.1512891651.git.lucien.xin@gmail.com>
 <20171211145434.GB18284@hmswarspite.think-freely.org>
 <20171211153639.GA3532@localhost.localdomain>
In-Reply-To: <20171211153639.GA3532@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, syzkaller@googlegroups.com

On Mon, Dec 11, 2017 at 01:36:39PM -0200, Marcelo Ricardo Leitner wrote:
> Hi,
> 
> On Mon, Dec 11, 2017 at 09:54:34AM -0500, Neil Horman wrote:
> > On Sun, Dec 10, 2017 at 03:40:51PM +0800, Xin Long wrote:
> > > Now in sctp_setsockopt_reset_streams, it only does the check
> > > optlen < sizeof(*params) for optlen. But it's not enough, as
> > > params->srs_number_streams should also match optlen.
> > > 
> > > If the streams in params->srs_stream_list are less than stream
> > > nums in params->srs_number_streams, later when dereferencing
> > > the stream list, it could cause a slab-out-of-bounds crash, as
> > > reported by syzbot.
> > > 
> > > This patch is to fix it by also checking the stream numbers in
> > > sctp_setsockopt_reset_streams to make sure at least it's not
> > > greater than the streams in the list.
> > > 
> > > Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
> > > Reported-by: Dmitry Vyukov <dvyukov@google.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/sctp/socket.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > index 014847e..dbf140d 100644
> > > --- a/net/sctp/socket.c
> > > +++ b/net/sctp/socket.c
> > > @@ -3891,13 +3891,17 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
> > >  	struct sctp_association *asoc;
> > >  	int retval = -EINVAL;
> > >  
> > > -	if (optlen < sizeof(struct sctp_reset_streams))
> > > +	if (optlen < sizeof(*params))
> > >  		return -EINVAL;
> > >  
> > Is this going to work in all corner cases?  IIRC struct
> > sctp_reset_stream has variable length array at the end of it, and so
> > sizeof(struct sctp_reset_streams) returns just the size of the
> > struct, while sizeof(*params) returns the size of the entire object
> > (including the array elements).  If a user space task allocates a
> 
> I don't think it can include the array elements as such information
> can't be passed from the application to the kernel other than via
> optlen parameter. There is no metadata around the struct that could
> allow that, and sizeof() is a constant, it can't be assuming different
> values in runtime.
> 
> Cheers,
> Marcelo
>% 
Yup, you're right, its fine.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> > static memory block to hold this struct and the array, and passes it
> > in with a shorter optlen (if for example, they do not intend to use
> > all the array elements), this will cause a failure, where no failure
> > is truly warranted.  It seems the correct check to me should be the
> > origional sizeof(struct sctp_reset_streams) check, and the below
> > check to ensure that there are at least the same number of array
> > elements available as indicated in srs_nuber_streams.
> > 
> > Regards
> > Neil
> > 
> > >  	params = memdup_user(optval, optlen);
> > >  	if (IS_ERR(params))
> > >  		return PTR_ERR(params);
> > >  
> > > +	if (params->srs_number_streams * sizeof(__u16) >
> > > +	    optlen - sizeof(*params))
> > > +		goto out;
> > > +
> > >  	asoc = sctp_id2assoc(sk, params->srs_assoc_id);
> > >  	if (!asoc)
> > >  		goto out;
> > > -- 
> > > 2.1.0
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
