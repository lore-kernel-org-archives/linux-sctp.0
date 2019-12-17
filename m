From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 17 Dec 2019 12:33:29 +0000
Subject: Re: [PATCH net] sctp: fix memleak on err handling of stream initialization
Message-Id: <20191217123329.GH4444@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
 <20191217115513.GB730@hmswarspite.think-freely.org>
In-Reply-To: <20191217115513.GB730@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-sctp@vger.kernel.org

On Tue, Dec 17, 2019 at 06:55:13AM -0500, Neil Horman wrote:
> On Mon, Dec 16, 2019 at 10:01:16PM -0300, Marcelo Ricardo Leitner wrote:
> > syzbot reported a memory leak when an allocation fails within
> > genradix_prealloc() for output streams. That's because
> > genradix_prealloc() leaves initialized members initialized when the
> > issue happens and SCTP stack will abort the current initialization but
> > without cleaning up such members.
> > 
> > The fix here is to always call genradix_free() when genradix_prealloc()
> > fails, for output and also input streams, as it suffers from the same
> > issue.
> > 
> > Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> > Fixes: 2075e50caf5e ("sctp: convert to genradix")
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> >  net/sctp/stream.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index df60b5ef24cbf5c6f628ab8ed88a6faaaa422b6d..e0b01bf912b3f3cdbc3f713bcfa50868e4802929 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> >  		return 0;
> >  
> >  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> > -	if (ret)
> > +	if (ret) {
> > +		genradix_free(&stream->out);
> >  		return ret;
> > +	}
> >  
> >  	stream->outcnt = outcnt;
> >  	return 0;
> > @@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
> >  		return 0;
> >  
> >  	ret = genradix_prealloc(&stream->in, incnt, gfp);
> > -	if (ret)
> > +	if (ret) {
> > +		genradix_free(&stream->in);
> >  		return ret;
> > +	}
> >  
> >  	stream->incnt = incnt;
> >  	return 0;
> > -- 
> > 2.23.0
> > 
> > 
> As mentioned in the other thread, shouldn't genradix_prealloc clean this up
> internal to its function.  It seems odd having to free memory allocated on
> error.

Depends on how fatal you're considering that it is.  With the current
version of genradix_prealloc() there could be a place that attempted
to pre-allocate it, it failed, and then resumed later on. SCTP can't
do that, because right after this prealloc it will write to each
and every element in there, but someone could.

  Marcelo
