From: Tejun Heo <tj@kernel.org>
Date: Mon, 04 Feb 2013 16:37:16 +0000
Subject: Re: [PATCH 60/62] sctp: convert to idr_alloc()
Message-Id: <20130204163716.GB27963@mtj.dyndns.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-61-git-send-email-tj@kernel.org>
 <510FE042.8040503@gmail.com>
In-Reply-To: <510FE042.8040503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Mon, Feb 04, 2013 at 11:22:26AM -0500, Vlad Yasevich wrote:
> >+	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
> >+	if (ret >= 0) {
> 
> In SCTP, association id is not allowed to be 0, so we have to treat
> 0 as an error.

That condition is specified via @idr_low and 0 won't be returned.  If
your point is that the condition better be "ret > 0" for clarity, I
don't know.  At that point, we already requested an ID in the
acceptable range and testing whether the allocation succeeded or not
where failure will always be indicated by -errno.

We can surely add "if (ret = 0) ret = -EINVAL" but that would be a
completely dead path (should we add dead retry loop too?).  If we
don't add such code, the code would appear as silently ignoring error.

So, I think "ret >= 0" is better there.  Maybe we can throw in a
comment explaining idr_low never goes to zero.

BTW, this style of cyclic allocation is broken.  It's prone to -ENOSPC
failure after the first wrap around.  I think we need to implement
proper cyclic support in idr, but let's worry about that later.

Thanks.

-- 
tejun
