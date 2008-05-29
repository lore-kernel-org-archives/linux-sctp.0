From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 29 May 2008 23:51:37 +0000
Subject: Re: receiver window questions
Message-Id: <20080529235137.GA22989@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, May 29, 2008 at 11:50:56AM -0400, Vlad Yasevich wrote:
> Neil Horman wrote:
> >On Thu, May 29, 2008 at 11:06:11AM -0400, Vlad Yasevich wrote:
> 
> I think this is hitting a condition where the receiver buffer is exhausted 
> prior
> to rwnd.  We generally mark the TSN as received prior to attempting an 
> internal allocation to carry the data.  Thus, if this allocation fails, 
> we'll continue
> reporting the tsn as received and move the cum-tsn if appropriate.
> 
> We've been trying to figure out what the correct way to solve this 
> condition is
> and so far haven't come up with a workable solution.
> 
You're right it does sound like that.  You know, I haven't visited that code
since we rewrote the receive buffer management code to expand according to
available memory with the sk_mem_schedule api.  Do you think this could be as
simple as removing this drop point?

Neil

