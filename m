From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 23 Oct 2012 13:16:08 +0000
Subject: Re: [PATCH] Make hmac algorithm selection for cookie generation dynamic
Message-Id: <20121023131608.GA23738@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1350661926-8312-1-git-send-email-nhorman@tuxdriver.com>
 <20121023.023254.1960160564751660622.davem@davemloft.net>
In-Reply-To: <20121023.023254.1960160564751660622.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, netdev@vger.kernel.org

On Tue, Oct 23, 2012 at 02:32:54AM -0400, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Fri, 19 Oct 2012 11:52:06 -0400
> 
> > Currently sctp allows for the optional use of md5 of sha1 hmac algorithms to
> > generate cookie values when establishing new connections via two build time
> > config options.  Theres no real reason to make this a static selection.  We can
> > add a sysctl that allows for the dynamic selection of these algorithms at run
> > time, with the default value determined by the corresponding crypto library
> > config options.  It saves us two needless configuration settings and enables the
> > freedom for administrators to select which algorithm a particular system uses.
> > This comes in handy when, for example running a system in FIPS mode, where use
> > of md5 is disallowed, but SHA1 is permitted.
> > 
> > Note: This new sysctl has no corresponding socket option to select the cookie
> > hmac algorithm.  I chose not to implement that intentionally, as RFC 6458
> > contains no option for this value, and I opted not to pollute the socket option
> > namespace.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Neil, please use appropriate subject prefixes in your patch
> submissions.  In this case "sctp: " would have been appropriate.
> 
Crap, sorry, Dave, I should know better.  Completely slipped my mind.

Neil

> Vlad, this patch looks fine to me, but I'd like you to review
> it too before I apply it.
> 
> Thanks.
> 
