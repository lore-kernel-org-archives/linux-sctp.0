From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 13 Jul 2017 14:38:34 +0000
Subject: Re: sctp refcount bug.
Message-Id: <20170713143834.GU18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170713143639.kbfqyasw4z4kjzsf@codemonkey.org.uk>
In-Reply-To: <20170713143639.kbfqyasw4z4kjzsf@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Thu, Jul 13, 2017 at 10:36:39AM -0400, Dave Jones wrote:
> Hit this on Linus' current tree.
> 
> 
> refcount_t: underflow; use-after-free.

Any tips on how to reproduce this?

  Marcelo
