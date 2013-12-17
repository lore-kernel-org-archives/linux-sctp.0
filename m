From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 17 Dec 2013 14:18:48 +0000
Subject: Re: [PATCH v2 1/2] printk: Add a pr_warn_deprecated macro
Message-Id: <20131217141848.GA8633@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
 <1387213605-27206-2-git-send-email-nhorman@tuxdriver.com>
 <1387216201.18217.58.camel@joe-AO722>
In-Reply-To: <1387216201.18217.58.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: linux-sctp@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Mon, Dec 16, 2013 at 09:50:01AM -0800, Joe Perches wrote:
> (adding Andrew Morton to cc's)
> 
> On Mon, 2013-12-16 at 12:06 -0500, Neil Horman wrote:
> > sctp has several points in its setsockopt path in which it issues deprecation
> > warnings.  It seems like it might be handy to macrotize such a warning so other
> > subsystems can use it easily
> []
> > diff --git a/include/linux/printk.h b/include/linux/printk.h
> []
> > @@ -336,6 +336,9 @@ extern asmlinkage void dump_stack(void) __cold;
> >  	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> >  /* no pr_cont_ratelimited, don't do that... */
> >  
> > +#define pr_warn_deprecated(fmt, ...)					\
> > +	pr_warn_ratelimited("Deprecated: " fmt, ##__VA_ARGS__)
> 
> Continuing the thread from:
> http://patchwork.ozlabs.org/patch/301738/
> 
> Making this a global kernel #define is different than
> using it in your subsystem.
> 
> I think this is very analogous to the FW_INFO/FW_WARN
> uses and maybe should just have a #define for the
> string "deprecated:" inserted as a constant.
> 
> ie: just using
> 
> 	pr_warn_once(DEPRECATED fmt, args...)
> or
> 	pr_warn_ratelimited(DEPRECATED fmt, args...)
> 
The define is a nice idea, but I'm not sure about the use of the once variant.
Multiple users may use multiple programs that trigger these deprecation
warnings, and we should probably warn on each of them to avoid masking the
others.

I'll work up a new patch set
Neil

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
