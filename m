From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Jun 2017 17:44:21 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <20170626174421.GA1625@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Mon, Jun 26, 2017 at 11:57:10AM +0200, Andreas Steinmetz wrote:
> A quick test with retrieving the flags with fcntl(F_GETFD/F_GETFL)
> after peeloff shows that your patch works. Good job!
>=20
> Am Sunday, den 25.06.2017, 08:06 -0400 schrieb Neil Horman:
> > On Fri, Jun 23, 2017 at 04:33:15PM -0300, Marcelo Ricardo Leitner
> > wrote:
> > > On Fri, Jun 23, 2017 at 03:14:33PM -0400, Neil Horman wrote:
> > > > On Wed, Jun 21, 2017 at 09:53:44PM -0400, Neil Horman wrote:
> > > > > On Wed, Jun 21, 2017 at 03:53:13PM -0300, Marcelo Ricardo
> > > > > Leitner wrote:
> > > > > > On Wed, Jun 21, 2017 at 08:27:14AM -0400, Neil Horman wrote:
> > > > > > > On Tue, Jun 20, 2017 at 04:21:45PM -0300, Marcelo Ricardo
> > > > > > > Leitner wrote:
> > > > > > > > On Tue, Jun 20, 2017 at 03:00:46PM -0400, Neil Horman
> > > > > > > > wrote:
> > > > > > > > > On Tue, Jun 20, 2017 at 12:41:47PM -0300, Marcelo
> > > > > > > > > Ricardo Leitner wrote:
> > > > > > > >=20
> > > > > > > > ...
> > > > > > > > > > Maybe by extending sctp_peeloff_arg_t to have a flags
> > > > > > > > > > attribute in
> > > > > > > > > > there, we can allow the application to specify it and
> > > > > > > > > > feed into
> > > > > > > > > > get_unused_fd_flags() call in
> > > > > > > > > > sctp_getsockopt_peeloff() instead, or even
> > > > > > > > > > just overload the sd, which is currently an output-
> > > > > > > > > > only value, to
> > > > > > > > > > contain flags as the patch below. (We probably should
> > > > > > > > > > add some sanity
> > > > > > > > > > checking in there, though)
> > > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > Thinking about this some more, I'm a bit hesitant to
> > > > > > > > > change the
> > > > > > > > > sctp_peeloff_arg_t, since thats exposed to user
> > > > > > > > > space.=A0=A0Instead, what if we use
> > > > > > > >=20
> > > > > > > > +1
> > > > > > > >=20
> > > > > > > > > the sd value in the peeloff arg to fetch the
> > > > > > > > > close_on_exec flag in the new fd?
> > > > > > > > > Something like this (untested) patch:
> > > > > > > >=20
> > > > > > > > Yes. :-) That's similar to what I proposed, though you
> > > > > > > > used peeloff.sd
> > > > > > > > to find the old fd and copy the flag from it and I used
> > > > > > > > it as a pure
> > > > > > > > 'flags' field instead.
> > > > > > > >=20
> > > > > > > > I'm still not comfortable on hardwiring this copy. What
> > > > > > > > if the
> > > > > > > > application doesn't want to inherit the flag?
> > > > > > > > accept() calls accept4(... , flags=3D0)
> > > > > > > > dup2() calls dup3(... , flags=3D0)
> > > > > > > > I don't see this direct inheritance anywhere else.
> > > > > > > >=20
> > > > > > >=20
> > > > > > > I agree, but this strikes me as something of a unique
> > > > > > > situation.=A0=A0In alternate
> > > > > > > cases of creating a new file descriptor within the same
> > > > > > > process as a clone of an
> > > > > > > existing fd, we have dup/dup2 and dup3, with the former
> > > > > > > having defined behavior
> > > > > > > of not copying the cloexec and nonblock flags, and the
> > > > > > > latter allowing them to
> > > > > > > be explicitly specified for the new fd.
> > > > > > >=20
> > > > > > > 	In SCTP, we're creating a new fd, but have no express
> > > > > > > mechanism for
> > > > > > > defining the new flags.=A0=A0We could, as you say, add a flags
> > > > > > > field to the
> > > > > > > peeloff_param_arg_t to provide that, but that has userspace
> > > > > > > ABI ramifications,
> > > > > > > and makes programs less portable.
> > > > > > >=20
> > > > > > > 	Perhaps a new socket option SCTP_SOCKOPT_PEELOFF_FLAGS,
> > > > > > > and
> > > > > > > corresponding lksctp-tools library function
> > > > > > > sctp_peeloff_flags, which accepts
> > > > > > > the new fd's cloexec and nonblock flags as an
> > > > > > > argument?=A0=A0That way at least, we
> > > > > > > could define the origional peeloff behavior as not copying
> > > > > > > the flags, and allow
> > > > > > > people to opt into the non-standard functions if they need
> > > > > > > it.=A0=A0That would be in
> > > > > > > keeping with how dup/dup2/dup3 were developed.
> > > > > > >=20
> > > > > > > Thoughts?
> > > > > > > Neil
> > > > > >=20
> > > > > > That works for me.
> > > > > >=20
> > > > > > We can't rely on using peeloff.sd to carry the flags because
> > > > > > the
> > > > > > application may not have initialized it. It may be a variable
> > > > > > in the
> > > > > > stack on which application simply did peeloff.asoc =3D X and we
> > > > > > would be
> > > > > > working on unitialized data, so it's not safe.
> > > > > >=20
> > > > > > On Andreas' idea to have a sctp_peeloff2_arg_t, it's also
> > > > > > complicated
> > > > > > because the application is allowed to use a bigger-than-
> > > > > > needed buffer
> > > > > > and in such cases it would lead us to the same situation as
> > > > > > above.
> > > > > >=20
> > > > > > So yes, I also think that the new SCTP_SOCKOPT_PEELOFF_FLAGS
> > > > > > is the best
> > > > > > way out here.
> > > > > >=20
> > > > > > Cheers,
> > > > > > Marcelo
> > > > > >=20
> > > > > >=20
> > > > >=20
> > > > > I'll work up the patch tomorrow
> > > > > Neil
> > > > >=20
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > linux-sctp" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at=A0=A0http://vger.kernel.org/majordomo-info=
.h
> > > > > tml
> > > > >=20
> > > >=20
> > > > Ok, sorry for the delay.=A0=A0I tested this patch out with the lksc=
tp
> > > > test suite to
> > > > validate that the traditional peeloff path works, but I don't
> > > > have the userspace
> > > > code written to test the peeloff_flags path.=A0=A0Andreas, if you
> > > > could validate
> > > > that, I would appreciate it.=A0=A0I'm not real thrilled with the
> > > > export of the
> > > > set_close_on_exec function, but I'm not sure I like using the
> > > > internal function
> > > > any better.=A0=A0Either way, Andreas, if it works for you, I'll
> > > > propose it
> > > > officially and we can go from there.
> > >=20
> > > What about exposing a flags arg on
> > > sctp_getsockopt_peeloff_common()?
> > > Then I guess you don't need such post-processing as you can pass it
> > > to
> > > get_unused_fd_flags() directly.
> > >=20
> > > =A0 Marcelo
> > >=20
> >=20
> > Yeah, that makes sense, and then default the flags to 0 on
> > sctp_getsockopt_peelof.=A0=A0Andreas, can you please test the patch as-=
is=20
> > right now,
> > just to make sure the path with flags set works properly, and I'll
> > clean this up
> > in parallel while you do that ahead of official submission?
> >=20
> > Thanks
> > Neil
> >=20
> > > >=20
> > > > Neil
> > > >=20
> > > >=20
> > > > diff --git a/fs/file.c b/fs/file.c
> > > > index 1c2972e..a4521da 100644
> > > > --- a/fs/file.c
> > > > +++ b/fs/file.c
> > > > @@ -807,6 +807,7 @@ void set_close_on_exec(unsigned int fd, int
> > > > flag)
> > > > =A0		__clear_close_on_exec(fd, fdt);
> > > > =A0	spin_unlock(&files->file_lock);
> > > > =A0}
> > > > +EXPORT_SYMBOL(set_close_on_exec);
> > > > =A0
> > > > =A0bool get_close_on_exec(unsigned int fd)
> > > > =A0{
> > > > diff --git a/include/uapi/linux/sctp.h
> > > > b/include/uapi/linux/sctp.h
> > > > index ced9d8b..6217ff8 100644
> > > > --- a/include/uapi/linux/sctp.h
> > > > +++ b/include/uapi/linux/sctp.h
> > > > @@ -121,6 +121,7 @@ typedef __s32 sctp_assoc_t;
> > > > =A0#define SCTP_RESET_STREAMS	119
> > > > =A0#define SCTP_RESET_ASSOC	120
> > > > =A0#define SCTP_ADD_STREAMS	121
> > > > +#define SCTP_SOCKOPT_PEELOFF_FLAGS 122
> > > > =A0
> > > > =A0/* PR-SCTP policies */
> > > > =A0#define SCTP_PR_SCTP_NONE	0x0000
> > > > @@ -978,6 +979,11 @@ typedef struct {
> > > > =A0	int sd;
> > > > =A0} sctp_peeloff_arg_t;
> > > > =A0
> > > > +typedef struct {
> > > > +	sctp_peeloff_arg_t p_arg;
> > > > +	unsigned flags;
> > > > +} sctp_peeloff_flags_arg_t;
> > > > +
> > > > =A0/*
> > > > =A0 *=A0=A0Peer Address Thresholds socket option
> > > > =A0 */
> > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > index 7b6e20e..f210394 100644
> > > > --- a/net/sctp/socket.c
> > > > +++ b/net/sctp/socket.c
> > > > @@ -4933,20 +4933,12 @@ int sctp_do_peeloff(struct sock *sk,
> > > > sctp_assoc_t id, struct socket **sockp)
> > > > =A0}
> > > > =A0EXPORT_SYMBOL(sctp_do_peeloff);
> > > > =A0
> > > > -static int sctp_getsockopt_peeloff(struct sock *sk, int len,
> > > > char __user *optval, int __user *optlen)
> > > > +static int sctp_getsockopt_peeloff_common(struct sock *sk,
> > > > sctp_peeloff_arg_t *peeloff, struct file **newfile)
> > > > =A0{
> > > > -	sctp_peeloff_arg_t peeloff;
> > > > =A0	struct socket *newsock;
> > > > -	struct file *newfile;
> > > > =A0	int retval =3D 0;
> > > > =A0
> > > > -	if (len < sizeof(sctp_peeloff_arg_t))
> > > > -		return -EINVAL;
> > > > -	len =3D sizeof(sctp_peeloff_arg_t);
> > > > -	if (copy_from_user(&peeloff, optval, len))
> > > > -		return -EFAULT;
> > > > -
> > > > -	retval =3D sctp_do_peeloff(sk, peeloff.associd, &newsock);
> > > > +	retval =3D sctp_do_peeloff(sk, peeloff->associd,
> > > > &newsock);
> > > > =A0	if (retval < 0)
> > > > =A0		goto out;
> > > > =A0
> > > > @@ -4957,25 +4949,90 @@ static int sctp_getsockopt_peeloff(struct
> > > > sock *sk, int len, char __user *optval
> > > > =A0		goto out;
> > > > =A0	}
> > > > =A0
> > > > -	newfile =3D sock_alloc_file(newsock, 0, NULL);
> > > > -	if (IS_ERR(newfile)) {
> > > > +	*newfile =3D sock_alloc_file(newsock, 0, NULL);
> > > > +	if (IS_ERR(*newfile)) {
> > > > =A0		put_unused_fd(retval);
> > > > =A0		sock_release(newsock);
> > > > -		return PTR_ERR(newfile);
> > > > +		retval =3D PTR_ERR(*newfile);
> > > > +		*newfile =3D NULL;
> > > > +		return retval;
> > > > =A0	}
> > > > =A0
> > > > =A0	pr_debug("%s: sk:%p, newsk:%p, sd:%d\n", __func__, sk,
> > > > newsock->sk,
> > > > =A0		=A0retval);
> > > > +=09
> > > > +	peeloff->sd =3D retval;
> > > > +out:
> > > > +	return retval;
> > > > +}
> > > > +
> > > > +static int sctp_getsockopt_peeloff(struct sock *sk, int len,
> > > > char __user *optval, int __user *optlen)
> > > > +{
> > > > +	sctp_peeloff_arg_t peeloff;
> > > > +	struct file *newfile =3D NULL;
> > > > +	int retval =3D 0;
> > > > +
> > > > +	if (len < sizeof(sctp_peeloff_arg_t))
> > > > +		return -EINVAL;
> > > > +	len =3D sizeof(sctp_peeloff_arg_t);
> > > > +	if (copy_from_user(&peeloff, optval, len))
> > > > +		return -EFAULT;
> > > > +
> > > > +	retval =3D sctp_getsockopt_peeloff_common(sk, &peeloff,
> > > > &newfile);
> > > > +	if (retval < 0)
> > > > +		goto out;
> > > > =A0
> > > > =A0	/* Return the fd mapped to the new socket.=A0=A0*/
> > > > =A0	if (put_user(len, optlen)) {
> > > > -		fput(newfile);
> > > > +		if (newfile)
> > > > +			fput(newfile);
> > > > =A0		put_unused_fd(retval);
> > > > =A0		return -EFAULT;
> > > > =A0	}
> > > > -	peeloff.sd =3D retval;
> > > > +
> > > > =A0	if (copy_to_user(optval, &peeloff, len)) {
> > > > -		fput(newfile);
> > > > +		if (newfile)
> > > > +			fput(newfile);
> > > > +		put_unused_fd(retval);
> > > > +		return -EFAULT;
> > > > +	}
> > > > +	fd_install(retval, newfile);
> > > > +out:
> > > > +	return retval;
> > > > +}
> > > > +
> > > > +static int sctp_getsockopt_peeloff_flags(struct sock *sk, int
> > > > len, char __user *optval, int __user *optlen)
> > > > +{
> > > > +	sctp_peeloff_flags_arg_t peeloff;
> > > > +	struct file *newfile =3D NULL;
> > > > +	int retval =3D 0;
> > > > +
> > > > +	if (len < sizeof(sctp_peeloff_flags_arg_t))
> > > > +		return -EINVAL;
> > > > +	len =3D sizeof(sctp_peeloff_flags_arg_t);
> > > > +	if (copy_from_user(&peeloff, optval, len))
> > > > +		return -EFAULT;
> > > > +
> > > > +	retval =3D sctp_getsockopt_peeloff_common(sk,
> > > > &peeloff.p_arg, &newfile);
> > > > +	if (retval < 0)
> > > > +		goto out;
> > > > +
> > > > +	set_close_on_exec(peeloff.p_arg.sd, !!(peeloff.flags &
> > > > SOCK_CLOEXEC));
> > > > +
> > > > +	if (peeloff.flags & SOCK_NONBLOCK)
> > > > +		newfile->f_flags |=3D O_NONBLOCK;
> > > > +
> > > > +	/* Return the fd mapped to the new socket.=A0=A0*/
> > > > +	if (put_user(len, optlen)) {
> > > > +		if (newfile)
> > > > +			fput(newfile);
> > > > +		put_unused_fd(retval);
> > > > +		return -EFAULT;
> > > > +	}
> > > > +
> > > > +	if (copy_to_user(optval, &peeloff, len)) {
> > > > +		if (newfile)
> > > > +			fput(newfile);
> > > > =A0		put_unused_fd(retval);
> > > > =A0		return -EFAULT;
> > > > =A0	}
> > > > @@ -6758,6 +6815,9 @@ static int sctp_getsockopt(struct sock *sk,
> > > > int level, int optname,
> > > > =A0	case SCTP_SOCKOPT_PEELOFF:
> > > > =A0		retval =3D sctp_getsockopt_peeloff(sk, len,
> > > > optval, optlen);
> > > > =A0		break;
> > > > +	case SCTP_SOCKOPT_PEELOFF_FLAGS:
> > > > +		retval =3D sctp_getsockopt_peeloff_flags(sk, len,
> > > > optval, optlen);
> > > > +		break;
> > > > =A0	case SCTP_PEER_ADDR_PARAMS:
> > > > =A0		retval =3D sctp_getsockopt_peer_addr_params(sk,
> > > > len, optval,
> > > > =A0							=A0=A0optlen
> > > > );
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-
> > > > sctp" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at=A0=A0http://vger.kernel.org/majordomo-info.h=
tm
> > > > l
> > > >=20
> --=20
> Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Thank you, can I ask you to test this one as well?  It contains the clean up
that Marcello asked for.

Best
Neil


commit 07fb73580c766905023caabc4ac6b221e047e1eb
Author: root <root@amd-pence-02.lab.bos.redhat.com>
Date:   Mon Jun 26 08:58:56 2017 -0400

    Add peeloff-flags socket option

diff --git a/fs/file.c b/fs/file.c
index 1c2972e..a4521da 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -807,6 +807,7 @@ void set_close_on_exec(unsigned int fd, int flag)
 		__clear_close_on_exec(fd, fdt);
 	spin_unlock(&files->file_lock);
 }
+EXPORT_SYMBOL(set_close_on_exec);
=20
 bool get_close_on_exec(unsigned int fd)
 {
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index ced9d8b..6217ff8 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -121,6 +121,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_RESET_STREAMS	119
 #define SCTP_RESET_ASSOC	120
 #define SCTP_ADD_STREAMS	121
+#define SCTP_SOCKOPT_PEELOFF_FLAGS 122
=20
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
@@ -978,6 +979,11 @@ typedef struct {
 	int sd;
 } sctp_peeloff_arg_t;
=20
+typedef struct {
+	sctp_peeloff_arg_t p_arg;
+	unsigned flags;
+} sctp_peeloff_flags_arg_t;
+
 /*
  *  Peer Address Thresholds socket option
  */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7b6e20e..7341053 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4933,20 +4933,12 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t i=
d, struct socket **sockp)
 }
 EXPORT_SYMBOL(sctp_do_peeloff);
=20
-static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *=
optval, int __user *optlen)
+static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_ar=
g_t *peeloff, struct file **newfile, unsigned flags)
 {
-	sctp_peeloff_arg_t peeloff;
 	struct socket *newsock;
-	struct file *newfile;
 	int retval =3D 0;
=20
-	if (len < sizeof(sctp_peeloff_arg_t))
-		return -EINVAL;
-	len =3D sizeof(sctp_peeloff_arg_t);
-	if (copy_from_user(&peeloff, optval, len))
-		return -EFAULT;
-
-	retval =3D sctp_do_peeloff(sk, peeloff.associd, &newsock);
+	retval =3D sctp_do_peeloff(sk, peeloff->associd, &newsock);
 	if (retval < 0)
 		goto out;
=20
@@ -4957,25 +4949,90 @@ static int sctp_getsockopt_peeloff(struct sock *sk,=
 int len, char __user *optval
 		goto out;
 	}
=20
-	newfile =3D sock_alloc_file(newsock, 0, NULL);
-	if (IS_ERR(newfile)) {
+	*newfile =3D sock_alloc_file(newsock, 0, NULL);
+	if (IS_ERR(*newfile)) {
 		put_unused_fd(retval);
 		sock_release(newsock);
-		return PTR_ERR(newfile);
+		retval =3D PTR_ERR(*newfile);
+		*newfile =3D NULL;
+		return retval;
 	}
=20
 	pr_debug("%s: sk:%p, newsk:%p, sd:%d\n", __func__, sk, newsock->sk,
 		 retval);
+=09
+	peeloff->sd =3D retval;
+
+	set_close_on_exec(peeloff->sd, !!(flags & SOCK_CLOEXEC));
+
+	if (flags & SOCK_NONBLOCK)
+		(*newfile)->f_flags |=3D O_NONBLOCK;
+out:
+	return retval;
+}
+
+static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *=
optval, int __user *optlen)
+{
+	sctp_peeloff_arg_t peeloff;
+	struct file *newfile =3D NULL;
+	int retval =3D 0;
+
+	if (len < sizeof(sctp_peeloff_arg_t))
+		return -EINVAL;
+	len =3D sizeof(sctp_peeloff_arg_t);
+	if (copy_from_user(&peeloff, optval, len))
+		return -EFAULT;
+
+	retval =3D sctp_getsockopt_peeloff_common(sk, &peeloff, &newfile, 0);
+	if (retval < 0)
+		goto out;
=20
 	/* Return the fd mapped to the new socket.  */
 	if (put_user(len, optlen)) {
-		fput(newfile);
+		if (newfile)
+			fput(newfile);
 		put_unused_fd(retval);
 		return -EFAULT;
 	}
-	peeloff.sd =3D retval;
+
 	if (copy_to_user(optval, &peeloff, len)) {
-		fput(newfile);
+		if (newfile)
+			fput(newfile);
+		put_unused_fd(retval);
+		return -EFAULT;
+	}
+	fd_install(retval, newfile);
+out:
+	return retval;
+}
+
+static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len, char __=
user *optval, int __user *optlen)
+{
+	sctp_peeloff_flags_arg_t peeloff;
+	struct file *newfile =3D NULL;
+	int retval =3D 0;
+
+	if (len < sizeof(sctp_peeloff_flags_arg_t))
+		return -EINVAL;
+	len =3D sizeof(sctp_peeloff_flags_arg_t);
+	if (copy_from_user(&peeloff, optval, len))
+		return -EFAULT;
+
+	retval =3D sctp_getsockopt_peeloff_common(sk, &peeloff.p_arg, &newfile, p=
eeloff.flags);
+	if (retval < 0)
+		goto out;
+
+	/* Return the fd mapped to the new socket.  */
+	if (put_user(len, optlen)) {
+		if (newfile)
+			fput(newfile);
+		put_unused_fd(retval);
+		return -EFAULT;
+	}
+
+	if (copy_to_user(optval, &peeloff, len)) {
+		if (newfile)
+			fput(newfile);
 		put_unused_fd(retval);
 		return -EFAULT;
 	}
@@ -6758,6 +6815,9 @@ static int sctp_getsockopt(struct sock *sk, int level=
, int optname,
 	case SCTP_SOCKOPT_PEELOFF:
 		retval =3D sctp_getsockopt_peeloff(sk, len, optval, optlen);
 		break;
+	case SCTP_SOCKOPT_PEELOFF_FLAGS:
+		retval =3D sctp_getsockopt_peeloff_flags(sk, len, optval, optlen);
+		break;
 	case SCTP_PEER_ADDR_PARAMS:
 		retval =3D sctp_getsockopt_peer_addr_params(sk, len, optval,
 							  optlen);
