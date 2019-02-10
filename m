From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 10 Feb 2019 20:15:59 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190210201559.GE10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <20190209.151217.175627323493244750.davem@davemloft.net>
 <20190210124616.GG13621@localhost.localdomain>
In-Reply-To: <20190210124616.GG13621@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: julien@arista.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, lucien.xin@gmail.com

On Sun, Feb 10, 2019 at 10:46:16AM -0200, Marcelo Ricardo Leitner wrote:
> On Sat, Feb 09, 2019 at 03:12:17PM -0800, David Miller wrote:
> > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Date: Wed, 6 Feb 2019 18:37:54 -0200
> > 
> > > On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> > >> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> > >> structures longer than the current definitions.
> > >> 
> > >> This should prevent unjustified setsockopt() failures due to struct
> > >> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> > >> binaries that should be compatible, but were built with later kernel
> > >> uapi headers.
> > > 
> > > Not sure if we support backwards compatibility like this?
> > 
> > What a complete mess we have here.
> > 
> > Use new socket option numbers next time, do not change the size and/or
> > layout of existing socket options.
> 
> What about reusing the same socket option, but defining a new struct?
> Say, MYSOCKOPT supports struct mysockopt, struct mysockopt2, struct
> mysockopt3...
> 
> That way we have a clear definition of the user's intent.
> 
> > 
> > This whole thread, if you read it, is basically "if we compatability
> > this way, that breaks, and if we do compatability this other way oh
> > shit this other thing doesn't work."
> > 
> > I think we really need to specifically check for the difference sizes
> > that existed one by one, clear out the part not given by the user, and
> > backport this as far back as possible in a way that in the older kernels
> > we see if the user is actually trying to use the new features and if so
> > error out.
> 
> I'm afraid clearing out may not be enough, though seems it's the best
> we can do so far. If the struct is allocated but not fully initialized
> via a memset, but by setting its fields one by one, the remaining new
> fields will be left uninitinialized.

Need to clarify the "clearing out", I think it was meant differently.
It was more about on how to ensure that the 16-bytes long of the v3
supplied to a v1-only kernel is compatible with the 12-bytes long v1.
The kernel would have to check the trailing 4 bytes after v1-size and
make sure they are all zeroed in order for the old kernel to accept it
as a v1. But, as I said above, there are situations that this will not
be enough.

> 
> > 
> > Which, btw, is terrible behavior.  Newly compiled apps should work on
> > older kernels if they don't try to use the new features, and if they
> 
> One use case here is: a given distro is using kernel X and app Foo is
> built against it. Then upgrades to X+1, Foo is patched to fix an issue
> and is rebuilt against X+1. The user upgrades Foo package but for
> whatever reason, doesn't upgrade kernel or reboot the system. Here,
> Foo doesn't work anymore until the new kernel is also running.
> 
> > can the ones that want to try to use the new features should be able
> > to fall back when that feature isn't available in a non-ambiguous
> > and precisely defined way.
> > 
> > The fact that the use of the new feature is hidden in the new
> > structure elements is really rotten.
> > 
> > This patch, at best, needs some work and definitely a longer and more
> > detailed commit message.
> 

We have issues on read path too. 52ccb8e90c0a ("[SCTP]: Update
SCTP_PEER_ADDR_PARAMS socket option to the latest api draft.")
extended struct sctp_paddrparams and its getsockopt goes with:

sctp_getsockopt_peer_addr_params()
...
        if (len < sizeof(struct sctp_paddrparams))
                return -EINVAL;
        len = sizeof(struct sctp_paddrparams);

By then, we didn't have the /uapi/ folder yet. There may other cases.
