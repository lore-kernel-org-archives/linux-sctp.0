From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 03 Jan 2013 19:06:56 +0000
Subject: Re: Config Loop
Message-Id: <20130103190656.GB6891@shamino.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <50E5AA59.3010109@inktank.com>
In-Reply-To: <50E5AA59.3010109@inktank.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jan 03, 2013 at 10:59:02AM -0600, Alex Elder wrote:
> On 01/03/2013 10:52 AM, Neil Horman wrote:
> > On Thu, Jan 03, 2013 at 09:57:13AM -0600, Alex Elder wrote:
> >> A commit added in the 3.8-rc1 merge window has resulted in
> >> my kernel config entering an infinite loop handling the
> >> "Default SCTP cookie HMAC encoding" option.
> >>
> >>     commit 0d0863b02002c25140a1b9e113b81211bcc780e8
> >>     sctp: Change defaults on cookie hmac selection
> >>
> >>     http://marc.info/?l=linux-netdev&m5553459303505
> >>
> >> The problem lies in my config file containing this line:
> >>
> >>     CONFIG_SCTP_HMAC_MD5=y
> >>
> >> I normally configure my kernel using fixed config file
> >> (occasionally updated) using (roughly) this:
> >>
> >>     yes "" | make oldconfig
> >>
> >> The result looks like this:
> >>
> >> . . .
> >>   DCCP connection probing (NET_DCCPPROBE) [M/n/?] m
> >> *
> >> * The SCTP Protocol (EXPERIMENTAL)
> >> *
> >> The SCTP Protocol (EXPERIMENTAL) (IP_SCTP) [M/y/?] m
> >>   SCTP: Association probing (NET_SCTPPROBE) [M/n/?] m
> >>   SCTP: Debug messages (SCTP_DBG_MSG) [N/y/?] n
> >>   SCTP: Debug object counts (SCTP_DBG_OBJCNT) [N/y/?] n
> >>   Default SCTP cookie HMAC encoding
> >>     1. Enable optional MD5 hmac cookie generation
> >> (SCTP_DEFAULT_COOKIE_HMAC_MD5) (NEW)
> >>     2. Enable optional SHA1 hmac cookie generation
> >> (SCTP_DEFAULT_COOKIE_HMAC_SHA1) (NEW)
> >>     3. Use no hmac alg in SCTP cookie generation
> >> (SCTP_DEFAULT_COOKIE_HMAC_NONE) (NEW)
> >>   choice[1-3?]:   Default SCTP cookie HMAC encoding
> >>     1. Enable optional MD5 hmac cookie generation
> >> (SCTP_DEFAULT_COOKIE_HMAC_MD5) (NEW)
> >>     2. Enable optional SHA1 hmac cookie generation
> >> (SCTP_DEFAULT_COOKIE_HMAC_SHA1) (NEW)
> >>     3. Use no hmac alg in SCTP cookie generation
> >> (SCTP_DEFAULT_COOKIE_HMAC_NONE) (NEW)
> >>   choice[1-3?]:   Default SCTP cookie HMAC encoding
> >> . . .  and so on.
> >>
> >> I find that I can correct this with the patch below.
> >> I expect others will bump into the same problem.  In
> >> particular, I notice my Ubuntu config files contain
> >> that same line.
> >>
> >> I don't know how best to handle this, but I thought
> >> I would report it in case someone has a good solution.
> >>
> > Thats odd.  It looks like your selection of a defaut value for the sctp cookie
> > hmac algorithm isn't taking at all.  I just added the old CONFIG_SCTP_HMAC_MD5=y
> > option to my config and used your:
> > yes "" | make oldconfig 
> > setup, and it worked fine for me.  And you say if you remove the old config
> > option first, you get no loop?
> 
> I say that when I apply the patch (below) there is no loop.
> 
> I noticed the loop with v3.8-rc1 and it's still happening
> with v3.8-rc2.  I've attached the working config I'm now
> using to this message.  The only difference between the
> looping one and the working one is that this:
>     CONFIG_SCTP_HMAC_MD5=y
> has been replaced with this:
>     CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
> 
Oh, I think I see what happened.  When I converted the Kconfig file to have a
choice statement, it created a conflict with your old config that the the config
mechanism didn't know how to resolve.  The Choice statement selects
CONFIG_SCTP_HMAC_MD5 as a default value, but your old config explicitly has
CONFIG_SCTP_HMAC_MD5 turned off.  Since your command:
yes "" | make oldconfig
just takes whatever the default value is, it tries to select
CONFIG_SCTP_HMAC_MD5, but since its already turned off, the config utilty
doesn't know what to do, so it responds by just asking you again what you want
the default to be.

I don't think theres actually a bug here, at least not one that we can do
anything about that won't result in other people complaining about the opposite
effect.  The old config you have, when applied to the latest kernel, puts you in
a situation where you have both hmac options already disabled, but you need to
select a default value for your hmac cookie generator (one of md5/sha1/none), so
selecting the default effectively creates a situation where you're asking the
config to have CONFIG_SCTP_HMAC_MD5 both on and off at the same time.

Things that could be done as I see it:

1) We could teach the config utility to recognize when options are disabled in
the old config and migrate the default away to the next in line that is not
already disabled

2) We could make the config utility override the old config value when the input
value input at the prompt conflicts with the old config

3) We could print a helpful message indicating that the conflict is taking place


Truthfully though I don't really like any of these a whole lot (save for the
third).  1 is unpleasant in my view as they change what would otherwise
be the default coded value silently, while 2 overrides the previously selected
configuration option.  Both of these may be completely unexpected by the user.


Option 3 seems reasonable to me, although I'm not sure its going to be that
useful.  I'm sorry this happened to you, but it seems like this is something
that will only occur very rarely if/when we convert a previously existing set of
options to a choice submenu.  Let me know if you have other thoughts.
Neil


