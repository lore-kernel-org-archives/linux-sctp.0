From: Dave Jones <davej@codemonkey.org.uk>
Date: Thu, 13 Jul 2017 14:56:56 +0000
Subject: Re: sctp refcount bug.
Message-Id: <20170713145656.q3mvzohpzmg2mawe@codemonkey.org.uk>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170713143639.kbfqyasw4z4kjzsf@codemonkey.org.uk>
 <20170713143834.GU18138@localhost.localdomain>
In-Reply-To: <20170713143834.GU18138@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Thu, Jul 13, 2017 at 11:38:34AM -0300, Marcelo Ricardo Leitner wrote:
 > On Thu, Jul 13, 2017 at 10:36:39AM -0400, Dave Jones wrote:
 > > Hit this on Linus' current tree.
 > > 
 > > 
 > > refcount_t: underflow; use-after-free.
 > 
 > Any tips on how to reproduce this?

Only seen it once so far. Will see if I can narrow it down if it
reproduces.  It took ~12 hours of fuzzing to find overnight.

	Dave

