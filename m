From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 11 Feb 2019 17:05:42 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190211170542.GF10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <20190209.151217.175627323493244750.davem@davemloft.net>
 <20190210124616.GG13621@localhost.localdomain>
 <20190211150432.GA13525@hmswarspite.think-freely.org>
In-Reply-To: <20190211150432.GA13525@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, julien@arista.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com, lucien.xin@gmail.com

On Mon, Feb 11, 2019 at 10:04:32AM -0500, Neil Horman wrote:
> On Sun, Feb 10, 2019 at 10:46:16AM -0200, Marcelo Ricardo Leitner wrote:
> > On Sat, Feb 09, 2019 at 03:12:17PM -0800, David Miller wrote:
> > > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Date: Wed, 6 Feb 2019 18:37:54 -0200
> > > 
> > > > On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> > > >> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> > > >> structures longer than the current definitions.
> > > >> 
> > > >> This should prevent unjustified setsockopt() failures due to struct
> > > >> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> > > >> binaries that should be compatible, but were built with later kernel
> > > >> uapi headers.
> > > > 
> > > > Not sure if we support backwards compatibility like this?
> > > 
> > > What a complete mess we have here.
> > > 
> > > Use new socket option numbers next time, do not change the size and/or
> > > layout of existing socket options.
> > 
> > What about reusing the same socket option, but defining a new struct?
> > Say, MYSOCKOPT supports struct mysockopt, struct mysockopt2, struct
> > mysockopt3...
> > 
> > That way we have a clear definition of the user's intent.
> > 
> Thats possible, but I think thats pretty equivalaent to what daves saying, in
> that he wants us to identify all the sizes of this struct and the git history
> and act on them accordingly.  Having internal versions of the struct seems like
> a fine way to get there, but I think we need to consider how we got to this
> situations before we go down the implementation path.

I was more referring to future stuff, but yes. I find it a bit easier
to handle than having to switch the sockopt too and so far I couldn't
find drawbacks to it.

That is, when using a new sockopt, we could accept a buffer larger
than the needed, but I'm not considering that as a valid point
anymore. Putting this compatibility aside for a moment, that pretty
much means the user doesn't know what it wants and so we also don't.

> 
> > > 
> > > This whole thread, if you read it, is basically "if we compatability
> > > this way, that breaks, and if we do compatability this other way oh
> > > shit this other thing doesn't work."
> > > 
> > > I think we really need to specifically check for the difference sizes
> > > that existed one by one, clear out the part not given by the user, and
> > > backport this as far back as possible in a way that in the older kernels
> > > we see if the user is actually trying to use the new features and if so
> > > error out.
> > 
> > I'm afraid clearing out may not be enough, though seems it's the best
> > we can do so far. If the struct is allocated but not fully initialized
> > via a memset, but by setting its fields one by one, the remaining new
> > fields will be left uninitinialized.
> > 
> 
> I'm not sure this even makes sense.  Currently (as I understood it), the issue
> we are facing is the one in which an application is built against a newer kernel
> and run on an older one, the implication there being that the application will
> pass in a buffer that is larger than what the kernel expects.  In that
> situation, clearing isn't needed, all thats needed (I think), is a memcmp of the
> space between the sizeof(kernel struct version), and sizeof(userspace struct
> version) to see if any bits are non-zero.  If they are, we error out, otherwise,
> we ignore the space and move forward as though that overage doesn't exist.

That's exactly what I tried to mean. :-)

> 
> Mind you, I'm not (yet) advocating for that approach, just trying to clarify
> whats needed.

Ok.

> > > 
> > > Which, btw, is terrible behavior.  Newly compiled apps should work on
> > > older kernels if they don't try to use the new features, and if they
> > 
> > One use case here is: a given distro is using kernel X and app Foo is
> > built against it. Then upgrades to X+1, Foo is patched to fix an issue
> > and is rebuilt against X+1. The user upgrades Foo package but for
> > whatever reason, doesn't upgrade kernel or reboot the system. Here,
> > Foo doesn't work anymore until the new kernel is also running.
> > 
> Yes, thats the use case that we're trying to address.
> 
> > > can the ones that want to try to use the new features should be able
> > > to fall back when that feature isn't available in a non-ambiguous
> > > and precisely defined way.
> > > 
> > > The fact that the use of the new feature is hidden in the new
> > > structure elements is really rotten.
> > > 
> > > This patch, at best, needs some work and definitely a longer and more
> > > detailed commit message.
> > 
> FWIW, before we decide on a course of action, I think I need to point out that,
> over the last 10 years, we've extended this structure 6 times, in the following
> commits:
> 0f3fffd8ab1db
> 7e8616d8e7731
> e1cdd553d482c
> 35ea82d611da5
> c95129d127c6d
> b444153fb5a64
> 
> The first two I believe were modifications during a period when sctp was
> actually getting integrated to the kernel, but the last 4 were definately done
> during more recent development periods and wen't in without any commentary about
> the impact to UAPI compatibility.  The check for optlen > sizeof(struct
> sctp_event_subscribe) was made back in 2008, and while not spelled out, seems
> pretty clearly directed at enforcing compatibility with older appliations, not
> compatibility with newer applications running on older kernels.
> 
> I really worry about situations in which we need to support applications
> expecting features that the running kernel doesn't have.  In this particular
> situation it seems like a fixable thing, but I could envision situations in
> which we just can't do it, and I don't want to set that expectation when we
> can't consistently meet it.
> 
> So, if the consensus is that we need to support applications built on newer
> kernels, but run on older kernels (and I'd like to get verbal consensus on

Yes from my side.

> that), then we need to identify a method to fix this.  I'm still hesitant to
> do anything that involves us accepting any size buffer over the kernel expected
> size, as that puts us in a position to have to read large amounts of user data
> (i.e. possible DOS), and just picking an arbitrary large number to limit the
> buffer size seems wrong.  What if, on receipt of a structure from a newer kernel
> (implying a size larger than what the kernel expects), we clamp optlen to the
> kernel size, and put_user it back to the application?  i.e. we don't check any

We can't do that on setsockopt calls, as optlen is R/O there.
Returning > 0 is not specified on setsockopt(2).

> data above and beyond what the the kernel knows about, but we use the optlen as
> an indicator to user space that not all the data was processed?  That allows the
> kernel to ignore the overage safely, and while its not in the socket api
> extension RFC, its not violating anything, and is something we can document in
> the sctp(7) man page as a linux only behavior.
> 
> Thoughts?
> Neil

I also need to dig deeper on this, but in general what if we draw
a line based on the current implementation:
- Current struct is X bytes long
- Patch current and older kernels to accept up to X bytes, as long as
  the trailing bytes are zeroed. Otherwise, EINVAL.
  X may be a magic number for old kernel, but this way we avoid
  unbounded buffers and the limit is not random.
- On further changes, create a new, explicitly versioned struct.
  Older kernels will EINVAL if this new struct is used, which is
  expected.
  Newer kernels will then have to cope with the different
  sizes/structs accordingly.


  Marcelo
