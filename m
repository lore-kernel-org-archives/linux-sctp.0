From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 24 Dec 2013 13:37:56 +0000
Subject: Re: [PATCH v4 0/2] sctp: Consolidate and ratelimit deprecation warnings
Message-Id: <20131224133756.GA10477@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <1387805383-21500-1-git-send-email-nhorman@tuxdriver.com>
 <1387839316.1635.8.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1387839316.1635.8.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 10:55:16PM +0000, Ben Hutchings wrote:
> On Mon, 2013-12-23 at 08:29 -0500, Neil Horman wrote:
> > The SCTP protocol has several deprecation warnings in its setsockopt path that
> > can be triggered by unprivlidged users.  Since these are not ratelimited, we can
> > spam the logs quite easily here.  Since these are all deprecation warnings, and
> > that type of warning isn't uncommon in the rest of the kernel, lets make a
> > common pr_warn_deprecated macro to produce somewhat generalized ratelimited
> > deprecation warnings easily
> [...]
> 
> No objection to these changes, but I think deprecation warnings should
> log at least the command name and maybe also the pid of the caller.
> 
I didn't change the contents of the strings in this patch, I just wanted to
avoid log spamming, but I think adding caller pid/name is a good idea.  I'll do
that in a followon patch after the holidays
Neil

> Ben.
> 
> -- 
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
> 
> 
