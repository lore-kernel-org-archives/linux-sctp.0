From: Andreas Steinmetz <ast@domdv.de>
Date: Wed, 21 Jun 2017 10:13:56 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <1498040036.10887.6.camel@domdv.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Just as an idea:

Keep sctp_peeloff_arg_t as is.

Introduce sctp_peeloff2_arg_t with a flags field.

Decide in kernel space according to structure size if the "classic"
version or the "improved" version is used.

In case of the "classic" version keep the behaviour as is.

In case of the "improved" version set CLOEXEC/NONBLOCK according to the
flags set in userspace.

This way older applications that rely on current behavior are not
affected while new applications may use the improved model.
The userspace library should then present the new model with a
separate call, e.g. sctp_peeloff2.

Am Tuesday, den 20.06.2017, 16:21 -0300 schrieb Marcelo Ricardo
Leitner:
> On Tue, Jun 20, 2017 at 03:00:46PM -0400, Neil Horman wrote:
> > On Tue, Jun 20, 2017 at 12:41:47PM -0300, Marcelo Ricardo Leitner
> > wrote:
> 
> ...
> > > Maybe by extending sctp_peeloff_arg_t to have a flags attribute
> > > in
> > > there, we can allow the application to specify it and feed into
> > > get_unused_fd_flags() call in sctp_getsockopt_peeloff() instead,
> > > or even
> > > just overload the sd, which is currently an output-only value, to
> > > contain flags as the patch below. (We probably should add some
> > > sanity
> > > checking in there, though)
> > > 
> > 
> > Thinking about this some more, I'm a bit hesitant to change the
> > sctp_peeloff_arg_t, since thats exposed to user space.  Instead,
> > what if we use
> 
> +1
> 
> > the sd value in the peeloff arg to fetch the close_on_exec flag in
> > the new fd?
> > Something like this (untested) patch:
> 
> Yes. :-) That's similar to what I proposed, though you used
> peeloff.sd
> to find the old fd and copy the flag from it and I used it as a pure
> 'flags' field instead.
> 
> I'm still not comfortable on hardwiring this copy. What if the
> application doesn't want to inherit the flag?
> accept() calls accept4(... , flags=0)
> dup2() calls dup3(... , flags=0)
> I don't see this direct inheritance anywhere else.
> 
>   Marcelo
> 
> > 
> > 
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index f16c8d9..6386ac4 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -4939,6 +4939,8 @@ static int sctp_getsockopt_peeloff(struct
> > sock *sk, int len, char __user *optval
> >  	sctp_peeloff_arg_t peeloff;
> >  	struct socket *newsock;
> >  	struct file *newfile;
> > +	struct file *oldfile
> > +	unsigned flags = 0;
> >  	int retval = 0;
> >  
> >  	if (len < sizeof(sctp_peeloff_arg_t))
> > @@ -4951,8 +4953,17 @@ static int sctp_getsockopt_peeloff(struct
> > sock *sk, int len, char __user *optval
> >  	if (retval < 0)
> >  		goto out;
> >  
> > +	if (get_close_on_exec(peeloff.sd))
> > +		flags |= O_CLOEXEC;
> > +
> > +	oldfile = fget(peelof.sd);
> > +	if (oldfile) {
> > +		flags |= oldfile->f_flags & O_NONBLOCK;
> > +		fput(oldfile);
> > +	}
> > +
> >  	/* Map the socket to an unused fd that can be returned to
> > the user.  */
> > -	retval = get_unused_fd_flags(0);
> > +	retval = get_unused_fd_flags(flags);
> >  	if (retval < 0) {
> >  		sock_release(newsock);
> >  		goto out;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
