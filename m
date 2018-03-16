From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 16 Mar 2018 23:33:07 +0000
Subject: Re: sctp: use proc_remove_subtree()
Message-Id: <20180316233307.GK30522@ZenIV.linux.org.uk>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180314204621.GY30522@ZenIV.linux.org.uk>
 <20180314205119.GZ30522@ZenIV.linux.org.uk>
 <20180316.124415.427695020359988885.davem@davemloft.net>
In-Reply-To: <20180316.124415.427695020359988885.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Fri, Mar 16, 2018 at 12:44:15PM -0400, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Wed, 14 Mar 2018 20:51:19 +0000
> 
> > On Wed, Mar 14, 2018 at 08:46:21PM +0000, Al Viro wrote:
> >> use proc_remove_subtree() for subtree removal, both on setup failure
> >> halfway through and on teardown.  No need to make simple things
> >> complex...
> > 
> > ... and sctp_dbg_objcnt_exit() can be removed as well - remove_proc_subtree()
> > will get that sucker automatically.  Either a trivial addition, or equally
> > trivial followup...
> 
> Please add it to this patch and resubmit.

Done...
