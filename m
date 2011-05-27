From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 27 May 2011 17:42:13 +0000
Subject: Re: [PATCH] sctp: fixed missing fixup of sctp_local_addr_free
Message-Id: <20110527174213.GB4764@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1306517820-4793-1-git-send-email-nhorman@tuxdriver.com>
 <20110527.134004.1654129007987862831.davem@davemloft.net>
In-Reply-To: <20110527.134004.1654129007987862831.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org

On Fri, May 27, 2011 at 01:40:04PM -0400, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Fri, 27 May 2011 13:37:00 -0400
> 
> > commit 1231f0baa547a541a7481119323b7f964dda4788  Converted sctp to use
> > kfree_rcu from sctp_local_addr_free but missed this one call point.  Fix it up
> > accordingly.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> This has been fixed for several days now.
> 
> If you're using the net-next-2.6 tree, don't, when it's not active
> it's just a dummy tree for Stephen Rothwell to pull into -next
> and it will be rebuilt as soon as the merge window is over.
> 
Ok, copy that, thanks

