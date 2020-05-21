From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Thu, 21 May 2020 15:37:29 +0000
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
Message-Id: <20200521153729.GB74252@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
In-Reply-To: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Christoph Hellwig <hch@lst.de>

On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:

I wish we could split this patch into multiple ones. Like, one for
each sockopt, but it doesn't seem possible. It's tough to traverse
trough 5k lines long patch. :-(

> Since SCTP rather abuses getsockopt() to perform operations and uses
> the user buffer to select the association to get values from
> the sctp_getsockopt() has to do a Read-Modify-Write on the user buffer.
> 
> An on-stack buffer is used for short requests this allows the length
> check for simple getsockopt requests to be done by the wrapper.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> 
> --
> 
> While this patch might make it easier to export the functionality
> to other kernel modules, it doesn't make that change.
> 
> Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> It is also the only getsockopt() that wants to return a buffer
> and an error code. It is also definitely abusing getsockopt().

It should have been a linear buffer. The secondary __user access is
way worse than having the application to do another allocation. But
too late..

> 
> The SCTP_SOCKOPT_PEELOFF getsockopt() (another abuse) also wants to
> return a positive value and a buffer (containing the same value) on
> success.

Unnecessary, agree, but too late for changing that.

> 
> Both these stop the sctp_getsockopt_xxx() functions returning
> 'error or length'.
> 
> There is also real fubar of SCTP_GET_LOCAL_ADDRS which has to
> return the wrong length 'for historic compatibility'.
> Although I'm not sure how portable that makes applications.
> 
> Reduces the code by about 800 lines and 8k bytes (x86-64).
> Most of the changed lines are replacing x.y with x->y and
> simplifying error paths.

This cleanup is something that I've been longing for a while now.
Avoiding these repetitive user space handling is very welcomed.
Also, I think this is pretty much aligned with Christoph's goal as
well and can make the patches in his series easier/cleaner.

Other than the comments here, this patch LGTM.

> 
> Passes 'sparse' and at least some options work.

Assuming a v2 is coming, to appease the buildbot :)

...
> +static int sctp_setsockopt(struct sock *sk, int level, int optname,
> +			   char __user *u_optval, unsigned int optlen)
> +{
> +	u64 param_buf[8];
> +	int retval = 0;
> +	void *optval;
> +
> +	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
> +
> +	/* I can hardly begin to describe how wrong this is.  This is
> +	 * so broken as to be worse than useless.  The API draft
> +	 * REALLY is NOT helpful here...  I am not convinced that the
> +	 * semantics of setsockopt() with a level OTHER THAN SOL_SCTP
> +	 * are at all well-founded.
> +	 */
> +	if (level != SOL_SCTP) {
> +		struct sctp_af *af = sctp_sk(sk)->pf->af;
> +		return af->setsockopt(sk, level, optname, u_optval, optlen);
> +	}
> +
> +	if (optlen < sizeof (param_buf)) {
> +		if (copy_from_user(&param_buf, u_optval, optlen))
> +			return -EFAULT;
> +		optval = param_buf;
> +	} else {
> +		if (optlen > USHRT_MAX)
> +			optlen = USHRT_MAX;

There are functions that can work with and expect buffers larger than
that, such as sctp_setsockopt_auth_key:
@@ -3693,10 +3588,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));

and sctp_setsockopt_reset_streams:
        /* srs_number_streams is u16, so optlen can't be bigger than this. */
        optlen = min_t(unsigned int, optlen, USHRT_MAX +
                                             sizeof(__u16) * sizeof(*params));

Need to cope with those here.

> +		optval = memdup_user(u_optval, optlen);
> +		if (IS_ERR(optval))
> +			return PTR_ERR(optval);
> +	}
> +
> +	retval = kernel_sctp_setsockopt(sk, optname, optval, optlen);
> +	if (optval != param_buf)
> +		kfree(optval);
> +
>  	return retval;
>  }
>  
...
> +static int sctp_getsockopt(struct sock *sk, int level, int optname,
> +			   char __user *u_optval, int __user *u_optlen)
> +{
> +	u64 param_buf[8];
> +	int retval = 0;
> +	void *optval;
> +	int len, optlen;
> +
> +	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
> +
> +	/* I can hardly begin to describe how wrong this is.  This is
> +	 * so broken as to be worse than useless.  The API draft
> +	 * REALLY is NOT helpful here...  I am not convinced that the
> +	 * semantics of getsockopt() with a level OTHER THAN SOL_SCTP
> +	 * are at all well-founded.
> +	 */
> +	if (level != SOL_SCTP) {
> +		struct sctp_af *af = sctp_sk(sk)->pf->af;
> +
> +		retval = af->getsockopt(sk, level, optname, u_optval, u_optlen);
> +		return retval;
> +	}
> +
> +	if (get_user(len, u_optlen))
> +		return -EFAULT;
> +
> +	if (len < 0)
> +		return -EINVAL;
> +
> +	/* Many options are RMW so we must read in the user buffer.
> +	 * For safetly we need to initialise it to avoid leaking
> +	 * kernel data - the copy does this as well.
> +	 * To simplify the processing of simple options the buffer length
> +	 * check is repeated after the request is actioned.
> +	 */
> +	if (len < sizeof (param_buf)) {
> +		/* Zero first bytes to stop KASAN complaining. */
> +		param_buf[0] = 0;
> +		if (copy_from_user(&param_buf, u_optval, len))
> +			return -EFAULT;
> +		optval = param_buf;
> +	} else {
> +		if (len > USHRT_MAX)
> +			len = USHRT_MAX;

This limit is not present today for sctp_getsockopt_local_addrs()
calls (there may be others).  As is, it will limit it and may mean
that it can't dump all addresses.  We have discussed this and didn't
come to a conclusion on what is a safe limit to use here, at least not
on that time.
