From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 05 Dec 2017 18:59:47 +0000
Subject: Re: [PATCH net-next 01/12] sctp: add stream interleave enable members and sockopt
Message-Id: <20171205185947.GG13341@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <20171205183540.GB10327@hmswarspite.think-freely.org>
In-Reply-To: <20171205183540.GB10327@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Tue, Dec 05, 2017 at 01:35:40PM -0500, Neil Horman wrote:
> On Tue, Dec 05, 2017 at 11:15:58PM +0800, Xin Long wrote:
> > This patch adds intl_enable in asoc and netns, and strm_interleave in
> > sctp_sock to indicate if stream interleave is enabled and supported.
> > 
> > netns intl_enable would be set via procfs, but that is not added yet
> > until all stream interleave codes are completely implemented; asoc
> > intl_enable will be set when doing 4-shakehands.
> > 
> Which patch did you implement the per-namespace proc file in?  I don't see it in
> the patch that you referenced above
> Neil
> 

It's in the next series. As the next one introduces the compatibility
needed for other extensions, which are already in the stack, it's
safer to not be able to enable it yet.

Xin, can you please post it as RFC too? So Neil can have a look at the
big picture here. Thanks

  Marcelo
