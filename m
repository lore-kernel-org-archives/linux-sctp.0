From: Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 25 Jun 2017 12:06:28 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <20170625120628.GA25158@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jun 23, 2017 at 04:33:15PM -0300, Marcelo Ricardo Leitner wrote:
> On Fri, Jun 23, 2017 at 03:14:33PM -0400, Neil Horman wrote:
> > On Wed, Jun 21, 2017 at 09:53:44PM -0400, Neil Horman wrote:
> > > On Wed, Jun 21, 2017 at 03:53:13PM -0300, Marcelo Ricardo Leitner wrote:
> > > > On Wed, Jun 21, 2017 at 08:27:14AM -0400, Neil Horman wrote:
> > > > > On Tue, Jun 20, 2017 at 04:21:45PM -0300, Marcelo Ricardo Leitner wrote:
> > > > > > On Tue, Jun 20, 2017 at 03:00:46PM -0400, Neil Horman wrote:
> > > > > > > On Tue, Jun 20, 2017 at 12:41:47PM -0300, Marcelo Ricardo Leitner wrote:
> > > > > > ...
> > > > > > > > Maybe by extending sctp_peeloff_arg_t to have a flags attribute in
> > > > > > > > there, we can allow the application to specify it and feed into
> > > > > > > > get_unused_fd_flags() call in sctp_getsockopt_peeloff() instead, or even
> > > > > > > > just overload the sd, which is currently an output-only value, to
> > > > > > > > contain flags as the patch below. (We probably should add some sanity
> > > > > > > > checking in there, though)
> > > > > > > > 
> > > > > > > Thinking about this some more, I'm a bit hesitant to change the
> > > > > > > sctp_peeloff_arg_t, since thats exposed to user space.  Instead, what if we use
> > > > > > 
> > > > > > +1
> > > > > > 
> > > > > > > the sd value in the peeloff arg to fetch the close_on_exec flag in the new fd?
> > > > > > > Something like this (untested) patch:
> > > > > > 
> > > > > > Yes. :-) That's similar to what I proposed, though you used peeloff.sd
> > > > > > to find the old fd and copy the flag from it and I used it as a pure
> > > > > > 'flags' field instead.
> > > > > > 
> > > > > > I'm still not comfortable on hardwiring this copy. What if the
> > > > > > application doesn't want to inherit the flag?
> > > > > > accept() calls accept4(... , flags=0)
> > > > > > dup2() calls dup3(... , flags=0)
> > > > > > I don't see this direct inheritance anywhere else.
> > > > > > 
> > > > > I agree, but this strikes me as something of a unique situation.  In alternate
> > > > > cases of creating a new file descriptor within the same process as a clone of an
> > > > > existing fd, we have dup/dup2 and dup3, with the former having defined behavior
> > > > > of not copying the cloexec and nonblock flags, and the latter allowing them to
> > > > > be explicitly specified for the new fd.
> > > > > 
> > > > > 	In SCTP, we're creating a new fd, but have no express mechanism for
> > > > > defining the new flags.  We could, as you say, add a flags field to the
> > > > > peeloff_param_arg_t to provide that, but that has userspace ABI ramifications,
> > > > > and makes programs less portable.
> > > > > 
> > > > > 	Perhaps a new socket option SCTP_SOCKOPT_PEELOFF_FLAGS, and
> > > > > corresponding lksctp-tools library function sctp_peeloff_flags, which accepts
> > > > > the new fd's cloexec and nonblock flags as an argument?  That way at least, we
> > > > > could define the origional peeloff behavior as not copying the flags, and allow
> > > > > people to opt into the non-standard functions if they need it.  That would be in
> > > > > keeping with how dup/dup2/dup3 were developed.
> > > > > 
> > > > > Thoughts?
> > > > > Neil
> > > > 
> > > > That works for me.
> > > > 
> > > > We can't rely on using peeloff.sd to carry the flags because the
> > > > application may not have initialized it. It may be a variable in the
> > > > stack on which application simply did peeloff.asoc = X and we would be
> > > > working on unitialized data, so it's not safe.
> > > > 
> > > > On Andreas' idea to have a sctp_peeloff2_arg_t, it's also complicated
> > > > because the application is allowed to use a bigger-than-needed buffer
> > > > and in such cases it would lead us to the same situation as above.
> > > > 
> > > > So yes, I also think that the new SCTP_SOCKOPT_PEELOFF_FLAGS is the best
> > > > way out here.
> > > > 
> > > > Cheers,
> > > > Marcelo
> > > > 
> > > > 
> > > I'll work up the patch tomorrow
> > > Neil
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > Ok, sorry for the delay.  I tested this patch out with the lksctp test suite to
> > validate that the traditional peeloff path works, but I don't have the userspace
> > code written to test the peeloff_flags path.  Andreas, if you could validate
> > that, I would appreciate it.  I'm not real thrilled with the export of the
> > set_close_on_exec function, but I'm not sure I like using the internal function
> > any better.  Either way, Andreas, if it works for you, I'll propose it
> > officially and we can go from there.
> 
> What about exposing a flags arg on sctp_getsockopt_peeloff_common()?
> Then I guess you don't need such post-processing as you can pass it to
> get_unused_fd_flags() directly.
> 
>   Marcelo
> 
Yeah, that makes sense, and then default the flags to 0 on
sctp_getsockopt_peelof.  Andreas, can you please test the patch as-is right now,
just to make sure the path with flags set works properly, and I'll clean this up
in parallel while you do that ahead of official submission?

Thanks
Neil

> > 
> > Neil
> > 
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index 1c2972e..a4521da 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -807,6 +807,7 @@ void set_close_on_exec(unsigned int fd, int flag)
> >  		__clear_close_on_exec(fd, fdt);
> >  	spin_unlock(&files->file_lock);
> >  }
> > +EXPORT_SYMBOL(set_close_on_exec);
> >  
> >  bool get_close_on_exec(unsigned int fd)
> >  {
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index ced9d8b..6217ff8 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -121,6 +121,7 @@ typedef __s32 sctp_assoc_t;
> >  #define SCTP_RESET_STREAMS	119
> >  #define SCTP_RESET_ASSOC	120
> >  #define SCTP_ADD_STREAMS	121
> > +#define SCTP_SOCKOPT_PEELOFF_FLAGS 122
> >  
> >  /* PR-SCTP policies */
> >  #define SCTP_PR_SCTP_NONE	0x0000
> > @@ -978,6 +979,11 @@ typedef struct {
> >  	int sd;
> >  } sctp_peeloff_arg_t;
> >  
> > +typedef struct {
> > +	sctp_peeloff_arg_t p_arg;
> > +	unsigned flags;
> > +} sctp_peeloff_flags_arg_t;
> > +
> >  /*
> >   *  Peer Address Thresholds socket option
> >   */
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 7b6e20e..f210394 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -4933,20 +4933,12 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
> >  }
> >  EXPORT_SYMBOL(sctp_do_peeloff);
> >  
> > -static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
> > +static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *peeloff, struct file **newfile)
> >  {
> > -	sctp_peeloff_arg_t peeloff;
> >  	struct socket *newsock;
> > -	struct file *newfile;
> >  	int retval = 0;
> >  
> > -	if (len < sizeof(sctp_peeloff_arg_t))
> > -		return -EINVAL;
> > -	len = sizeof(sctp_peeloff_arg_t);
> > -	if (copy_from_user(&peeloff, optval, len))
> > -		return -EFAULT;
> > -
> > -	retval = sctp_do_peeloff(sk, peeloff.associd, &newsock);
> > +	retval = sctp_do_peeloff(sk, peeloff->associd, &newsock);
> >  	if (retval < 0)
> >  		goto out;
> >  
> > @@ -4957,25 +4949,90 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
> >  		goto out;
> >  	}
> >  
> > -	newfile = sock_alloc_file(newsock, 0, NULL);
> > -	if (IS_ERR(newfile)) {
> > +	*newfile = sock_alloc_file(newsock, 0, NULL);
> > +	if (IS_ERR(*newfile)) {
> >  		put_unused_fd(retval);
> >  		sock_release(newsock);
> > -		return PTR_ERR(newfile);
> > +		retval = PTR_ERR(*newfile);
> > +		*newfile = NULL;
> > +		return retval;
> >  	}
> >  
> >  	pr_debug("%s: sk:%p, newsk:%p, sd:%d\n", __func__, sk, newsock->sk,
> >  		 retval);
> > +	
> > +	peeloff->sd = retval;
> > +out:
> > +	return retval;
> > +}
> > +
> > +static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
> > +{
> > +	sctp_peeloff_arg_t peeloff;
> > +	struct file *newfile = NULL;
> > +	int retval = 0;
> > +
> > +	if (len < sizeof(sctp_peeloff_arg_t))
> > +		return -EINVAL;
> > +	len = sizeof(sctp_peeloff_arg_t);
> > +	if (copy_from_user(&peeloff, optval, len))
> > +		return -EFAULT;
> > +
> > +	retval = sctp_getsockopt_peeloff_common(sk, &peeloff, &newfile);
> > +	if (retval < 0)
> > +		goto out;
> >  
> >  	/* Return the fd mapped to the new socket.  */
> >  	if (put_user(len, optlen)) {
> > -		fput(newfile);
> > +		if (newfile)
> > +			fput(newfile);
> >  		put_unused_fd(retval);
> >  		return -EFAULT;
> >  	}
> > -	peeloff.sd = retval;
> > +
> >  	if (copy_to_user(optval, &peeloff, len)) {
> > -		fput(newfile);
> > +		if (newfile)
> > +			fput(newfile);
> > +		put_unused_fd(retval);
> > +		return -EFAULT;
> > +	}
> > +	fd_install(retval, newfile);
> > +out:
> > +	return retval;
> > +}
> > +
> > +static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len, char __user *optval, int __user *optlen)
> > +{
> > +	sctp_peeloff_flags_arg_t peeloff;
> > +	struct file *newfile = NULL;
> > +	int retval = 0;
> > +
> > +	if (len < sizeof(sctp_peeloff_flags_arg_t))
> > +		return -EINVAL;
> > +	len = sizeof(sctp_peeloff_flags_arg_t);
> > +	if (copy_from_user(&peeloff, optval, len))
> > +		return -EFAULT;
> > +
> > +	retval = sctp_getsockopt_peeloff_common(sk, &peeloff.p_arg, &newfile);
> > +	if (retval < 0)
> > +		goto out;
> > +
> > +	set_close_on_exec(peeloff.p_arg.sd, !!(peeloff.flags & SOCK_CLOEXEC));
> > +
> > +	if (peeloff.flags & SOCK_NONBLOCK)
> > +		newfile->f_flags |= O_NONBLOCK;
> > +
> > +	/* Return the fd mapped to the new socket.  */
> > +	if (put_user(len, optlen)) {
> > +		if (newfile)
> > +			fput(newfile);
> > +		put_unused_fd(retval);
> > +		return -EFAULT;
> > +	}
> > +
> > +	if (copy_to_user(optval, &peeloff, len)) {
> > +		if (newfile)
> > +			fput(newfile);
> >  		put_unused_fd(retval);
> >  		return -EFAULT;
> >  	}
> > @@ -6758,6 +6815,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
> >  	case SCTP_SOCKOPT_PEELOFF:
> >  		retval = sctp_getsockopt_peeloff(sk, len, optval, optlen);
> >  		break;
> > +	case SCTP_SOCKOPT_PEELOFF_FLAGS:
> > +		retval = sctp_getsockopt_peeloff_flags(sk, len, optval, optlen);
> > +		break;
> >  	case SCTP_PEER_ADDR_PARAMS:
> >  		retval = sctp_getsockopt_peer_addr_params(sk, len, optval,
> >  							  optlen);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
