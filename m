From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 21 Jun 2017 12:27:14 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <20170621122714.GA13220@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jun 20, 2017 at 04:21:45PM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Jun 20, 2017 at 03:00:46PM -0400, Neil Horman wrote:
> > On Tue, Jun 20, 2017 at 12:41:47PM -0300, Marcelo Ricardo Leitner wrote:
> ...
> > > Maybe by extending sctp_peeloff_arg_t to have a flags attribute in
> > > there, we can allow the application to specify it and feed into
> > > get_unused_fd_flags() call in sctp_getsockopt_peeloff() instead, or even
> > > just overload the sd, which is currently an output-only value, to
> > > contain flags as the patch below. (We probably should add some sanity
> > > checking in there, though)
> > > 
> > Thinking about this some more, I'm a bit hesitant to change the
> > sctp_peeloff_arg_t, since thats exposed to user space.  Instead, what if we use
> 
> +1
> 
> > the sd value in the peeloff arg to fetch the close_on_exec flag in the new fd?
> > Something like this (untested) patch:
> 
> Yes. :-) That's similar to what I proposed, though you used peeloff.sd
> to find the old fd and copy the flag from it and I used it as a pure
> 'flags' field instead.
> 
> I'm still not comfortable on hardwiring this copy. What if the
> application doesn't want to inherit the flag?
> accept() calls accept4(... , flags=0)
> dup2() calls dup3(... , flags=0)
> I don't see this direct inheritance anywhere else.
> 
I agree, but this strikes me as something of a unique situation.  In alternate
cases of creating a new file descriptor within the same process as a clone of an
existing fd, we have dup/dup2 and dup3, with the former having defined behavior
of not copying the cloexec and nonblock flags, and the latter allowing them to
be explicitly specified for the new fd.

	In SCTP, we're creating a new fd, but have no express mechanism for
defining the new flags.  We could, as you say, add a flags field to the
peeloff_param_arg_t to provide that, but that has userspace ABI ramifications,
and makes programs less portable.

	Perhaps a new socket option SCTP_SOCKOPT_PEELOFF_FLAGS, and
corresponding lksctp-tools library function sctp_peeloff_flags, which accepts
the new fd's cloexec and nonblock flags as an argument?  That way at least, we
could define the origional peeloff behavior as not copying the flags, and allow
people to opt into the non-standard functions if they need it.  That would be in
keeping with how dup/dup2/dup3 were developed.

Thoughts?
Neil

>   Marcelo
> 
> > 
> > 
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index f16c8d9..6386ac4 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -4939,6 +4939,8 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
> >  	sctp_peeloff_arg_t peeloff;
> >  	struct socket *newsock;
> >  	struct file *newfile;
> > +	struct file *oldfile
> > +	unsigned flags = 0;
> >  	int retval = 0;
> >  
> >  	if (len < sizeof(sctp_peeloff_arg_t))
> > @@ -4951,8 +4953,17 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
> >  	if (retval < 0)
> >  		goto out;
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
> >  	/* Map the socket to an unused fd that can be returned to the user.  */
> > -	retval = get_unused_fd_flags(0);
> > +	retval = get_unused_fd_flags(flags);
> >  	if (retval < 0) {
> >  		sock_release(newsock);
> >  		goto out;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
