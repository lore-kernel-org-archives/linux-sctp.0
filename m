From: David Miller <davem@davemloft.net>
Date: Fri, 26 Dec 2008 19:15:32 +0000
Subject: Re: [PATCH net-next 1/5] sctp: Bring SCTP_MAXSEG socket option
Message-Id: <20081226.111532.190275285.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229737672-28328-3-git-send-email-vladislav.yasevich@hp.com>
	<20081225.165625.248148862.davem@davemloft.net>
	<49550E8E.6030607@hp.com>
In-Reply-To: <49550E8E.6030607@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 26 Dec 2008 12:04:14 -0500

> David Miller wrote:
> > From: Vlad Yasevich <vladislav.yasevich@hp.com>
> > Date: Fri, 19 Dec 2008 20:47:48 -0500
> > 
> >> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> >>
> >> Brings maxseg socket option set/get into line with the latest ietf socket
> >> extensions API draft, while maintaining backwards compatibility.
> >>
> >> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> >> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> > 
> > Applied.  But I really dislike this scheme used by the compat code.
> > Half-way initializing a structure and then depending upon the logic in
> > the rest of the function to make sure the rest of the struct (the
> > uninitialized part) is never accessed?
> > 
> > Give me a break, programming, auditing, and bug fixing is hard enough
> > as it is without sloppy code like this.
> 
> Yes, it sucks but the since the draft keeps breaking the ABI between revisions,
> it leaves us a between a rock (no support) and a hard place (crappy code).

In this specific case we could have simply memset() the on-stack
structure to zero and there would be no confusion about whether the
object is initialized in some way in all code paths.

Or, in the main initial conditional we could explicitly assign both
members of this structure in both branches.

This is not about the compatibility issues, it's about how this code
was written.


