From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 21 May 2018 15:51:27 +0000
Subject: Re: [PATCH net-next] sctp: add support for SCTP_REUSE_PORT sockopt
Message-Id: <20180521155127.GB5489@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <be8e672439406e6c8b838321d63aa109b9620f4c.1526715880.git.lucien.xin@gmail.com>
 <20180521005059.GA15233@neilslaptop.think-freely.org>
 <20180521015404.GI5488@localhost.localdomain>
 <20180521113939.GA17593@hmswarspite.think-freely.org>
 <4918BFA7-18F9-4125-A7F5-2A603C692A14@fh-muenster.de>
 <20180521134857.GC17593@hmswarspite.think-freely.org>
 <43A7D2C9-DFCE-4ADA-9ABB-B7ACD78C210B@fh-muenster.de>
In-Reply-To: <43A7D2C9-DFCE-4ADA-9ABB-B7ACD78C210B@fh-muenster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Tuexen <tuexen@fh-muenster.de>
Cc: Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Mon, May 21, 2018 at 04:09:31PM +0200, Michael Tuexen wrote:
> > On 21. May 2018, at 15:48, Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > On Mon, May 21, 2018 at 02:16:56PM +0200, Michael Tuexen wrote:
> >>> On 21. May 2018, at 13:39, Neil Horman <nhorman@tuxdriver.com> wrote:
> >>> 
> >>> On Sun, May 20, 2018 at 10:54:04PM -0300, Marcelo Ricardo Leitner wrote:
> >>>> On Sun, May 20, 2018 at 08:50:59PM -0400, Neil Horman wrote:
> >>>>> On Sat, May 19, 2018 at 03:44:40PM +0800, Xin Long wrote:
> >>>>>> This feature is actually already supported by sk->sk_reuse which can be
> >>>>>> set by SO_REUSEADDR. But it's not working exactly as RFC6458 demands in
> >>>>>> section 8.1.27, like:
> >>>>>> 
> >>>>>> - This option only supports one-to-one style SCTP sockets
> >>>>>> - This socket option must not be used after calling bind()
> >>>>>>   or sctp_bindx().
> >>>>>> 
> >>>>>> Besides, SCTP_REUSE_PORT sockopt should be provided for user's programs.
> >>>>>> Otherwise, the programs with SCTP_REUSE_PORT from other systems will not
> >>>>>> work in linux.
> >>>>>> 
> >>>>>> This patch reuses sk->sk_reuse and works pretty much as SO_REUSEADDR,
> >>>>>> just with some extra setup limitations that are neeeded when it is being
> >>>>>> enabled.
> >>>>>> 
> >>>>>> "It should be noted that the behavior of the socket-level socket option
> >>>>>> to reuse ports and/or addresses for SCTP sockets is unspecified", so it
> >>>>>> leaves SO_REUSEADDR as is for the compatibility.
> >>>>>> 
> >>>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >>>>>> ---
> >>>>>> include/uapi/linux/sctp.h |  1 +
> >>>>>> net/sctp/socket.c         | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>> 2 files changed, 49 insertions(+)
> >>>>>> 
> >>>>> A few things:
> >>>>> 
> >>>>> 1) I agree with Tom, this feature is a complete duplication of the SK_REUSEPORT
> >>>>> socket option.  I understand that this is an implementation of the option in the
> >>>>> RFC, but its definately a duplication of a feature, which makes several things
> >>>>> really messy.
> >>>>> 
> >>>>> 2) The overloading of the sk_reuse opeion is a bad idea, for several reasons.
> >>>>> Chief among them is the behavioral interference between this patch and the
> >>>>> SO_REUSEADDR socket level option, that also sets this feature.  If you set
> >>>>> sk_reuse via SO_REUSEADDR, you will set the SCTP port reuse feature regardless
> >>>>> of the bind or 1:1/1:m state of the socket.  Vice versa, if you set this socket
> >>>>> option via the SCTP_PORT_REUSE option you will inadvertently turn on address
> >>>>> reuse for the socket.  We can't do that.
> >>>> 
> >>>> Given your comments, going a bit further here, one other big
> >>>> implication is that a port would never be able to be considered to
> >>>> fully meet SCTP standards regarding reuse because a rogue application
> >>>> may always abuse of the socket level opt to gain access to the port.
> >>>> 
> >>>> IOW, the patch allows the application to use such restrictions against
> >>>> itself and nothing else, which undermines the patch idea.
> >>>> 
> >>> Agreed.
> >>> 
> >>>> I lack the knowledge on why the SCTP option was proposed in the RFC. I
> >>>> guess they had a good reason to add the restriction on 1:1/1:m style.
> >>>> Does the usage of the current imply in any risk to SCTP sockets? If
> >>>> yes, that would give some grounds for going forward with the SCTP
> >>>> option.
> >>>> 
> >>> I'm also not privy to why the sctp option was proposed, though I expect that the
> >>> lack of standardization of SO_REUSEPORT probably had something to do with it.
> >>> As for the reasoning behind restriction to only 1:1 sockets, if I had to guess,
> >>> I would say it likely because it creates ordering difficulty at the application
> >>> level.
> >>> 
> >>> CC-ing Michael Tuxen, who I believe had some input on this RFC.  Hopefully he
> >>> can shed some light on this.
> >> Dear all,
> >> 
> >> the reason this was added is to have a specified way to allow a system to
> >> behave like a client and server making use of the INIT collision.
> >> 
> >> For 1-to-many style sockets you can do this by creating a socket, binding it,
> >> calling listen on it and trying to connect to the peer.
> >> 
> >> For 1-to-1 style sockets you need two sockets for it. One listener and one
> >> you use to connect (and close it in case of failure, open a new one...).
> >> 
> >> It was not clear if one can achieve this with SO_REUSEPORT and/or SO_REUSEADDR
> >> on all platforms. We left that unspecified.
> >> 
> >> I hope this makes the intention clearer.
> >> 
> > I think it makes the intention clearer yes, but it unfortunately does nothing in
> > my mind to clarify how the implementation should best handle the potential
> > overlap in functionality.  What I see here is that we have two functional paths
> > (the SO_REUSEPORT path and the SCTP_PORT_REUSE path), which may or may not
> > (depending on the OS implementation achieve the same functional goal (allowing
> > multiple sockets to share a port while allowing one socket to listen and the
> > other connect to a remote peer).  If both implementations do the same thing on a
> > given platform, we can either just alias one to another and be done, but if they
> > don't then we either have to implement both paths, and ensure that the
> > SO_REUSEPORT path is a no-op/error return for SCTP sockets, or that each path
> > implements a distinct feature set that is cleaarly documented.
> > 
> > That said, I think we may be in luck.  Looking at the connect and listen paths,
> > it appears to me that:
> > 
> > 1) Sockets ignore SO_REUSEPORT in the connect and listen paths (save for any
> > autobinding) so it would appear that the intent of the SCTP rfc can be honored
> > via SO_REUSEPORT on linux.  
> > 
> > 2) SO_REUSEPORT prevents changing state after a bind has occured, so we can honr
> > that part of the SCTP RFC.
> > 
> > The only missing part is the restriction that SCTP_REUSE_PORT has which is
> > unaccounted for is that 1:M sockets aren't allowed to enable port reuse.
> > However, I think the implication from Michaels description above is that port
> > reuse on a 1:M socket is implicit because a single socket can connect and listen
> > in that use case, rather than there being a danger to doing so.
> > 
> > As such, I would propose that we implement this socket option by simply setting
> > the sk->sk_reuseport field in the sock structure, and document the fact that
> > linux does not restrict port reuse from 1:M sockets.
> > 
> > Thoughts?
> Sounds acceptable to me...

+1

> 
> Best regards
> Michael
> > Neil
> > 
> 


