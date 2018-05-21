From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 21 May 2018 01:54:04 +0000
Subject: Re: [PATCH net-next] sctp: add support for SCTP_REUSE_PORT sockopt
Message-Id: <20180521015404.GI5488@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <be8e672439406e6c8b838321d63aa109b9620f4c.1526715880.git.lucien.xin@gmail.com>
 <20180521005059.GA15233@neilslaptop.think-freely.org>
In-Reply-To: <20180521005059.GA15233@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Sun, May 20, 2018 at 08:50:59PM -0400, Neil Horman wrote:
> On Sat, May 19, 2018 at 03:44:40PM +0800, Xin Long wrote:
> > This feature is actually already supported by sk->sk_reuse which can be
> > set by SO_REUSEADDR. But it's not working exactly as RFC6458 demands in
> > section 8.1.27, like:
> > 
> >   - This option only supports one-to-one style SCTP sockets
> >   - This socket option must not be used after calling bind()
> >     or sctp_bindx().
> > 
> > Besides, SCTP_REUSE_PORT sockopt should be provided for user's programs.
> > Otherwise, the programs with SCTP_REUSE_PORT from other systems will not
> > work in linux.
> > 
> > This patch reuses sk->sk_reuse and works pretty much as SO_REUSEADDR,
> > just with some extra setup limitations that are neeeded when it is being
> > enabled.
> > 
> > "It should be noted that the behavior of the socket-level socket option
> > to reuse ports and/or addresses for SCTP sockets is unspecified", so it
> > leaves SO_REUSEADDR as is for the compatibility.
> > 
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  1 +
> >  net/sctp/socket.c         | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 49 insertions(+)
> > 
> A few things:
> 
> 1) I agree with Tom, this feature is a complete duplication of the SK_REUSEPORT
> socket option.  I understand that this is an implementation of the option in the
> RFC, but its definately a duplication of a feature, which makes several things
> really messy.
> 
> 2) The overloading of the sk_reuse opeion is a bad idea, for several reasons.
> Chief among them is the behavioral interference between this patch and the
> SO_REUSEADDR socket level option, that also sets this feature.  If you set
> sk_reuse via SO_REUSEADDR, you will set the SCTP port reuse feature regardless
> of the bind or 1:1/1:m state of the socket.  Vice versa, if you set this socket
> option via the SCTP_PORT_REUSE option you will inadvertently turn on address
> reuse for the socket.  We can't do that.

Given your comments, going a bit further here, one other big
implication is that a port would never be able to be considered to
fully meet SCTP standards regarding reuse because a rogue application
may always abuse of the socket level opt to gain access to the port.

IOW, the patch allows the application to use such restrictions against
itself and nothing else, which undermines the patch idea.

I lack the knowledge on why the SCTP option was proposed in the RFC. I
guess they had a good reason to add the restriction on 1:1/1:m style.
Does the usage of the current imply in any risk to SCTP sockets? If
yes, that would give some grounds for going forward with the SCTP
option.

> 
> Its a bit frustrating, since SO_REUSEPORT is widely available on multiple
> operating systems, but isn't standard (AFAIK).  I would say however, given the
> prevalence of the socket level option, we should likely advocate for the removal
> of the sctp specific option, or at the least implement and document it as being

Is it possible, to remove/deprecate an option once it is published on a RFC?

> an alias for SO_REUSEPORT
> 
> 
> As this stands however, its a NACK from me.
> 
> Neil
> 
