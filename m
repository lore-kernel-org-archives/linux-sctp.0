From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 19 Feb 2010 16:18:56 +0000
Subject: Re: [RFC 1/2] sctp: convert hash list to RCU
Message-Id: <20100219081856.79ba7cf8@nehalam>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100219055520.223027612@vyatta.com>
	<20100219055628.436258223@vyatta.com>
	<20100219155825.GA6778@linux.vnet.ibm.com>
In-Reply-To: <20100219155825.GA6778@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paulmck@linux.vnet.ibm.com
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Fri, 19 Feb 2010 07:58:25 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Feb 18, 2010 at 09:55:21PM -0800, Stephen Hemminger wrote:
> > This patch converts existing SCTP hash list to using RCU
> > rather than reader/writer lock. Also, get rid of no longer used
> > locking wrappers.
> > 
> > In future, the SCTP hash locking should be broken out from the
> > hash structure because of the wasted space for the hash locks
> > and associated holes. A single lock per hashlist is sufficient
> > now that RCU is used.
> > 
> > Compile tested only. I can't think of an SCTP stress application.
> > 
> > P.s: Some janitor ought to go through and remove the locking
> > macros here.
> 
> One question below about what looks to be mixing of RCU and RCU-bh
> read-side critical sections while waiting only for RCU grace periods.
> Unless I am missing something, this can result in memory corruption.
> 

Thanks, I copied the original locking which was broken there as well.


-- 
