From: "Doug Graham" <dgraham@nortel.com>
Date: Wed, 29 Jul 2009 16:07:12 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <20090729160711.GD29475@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jul 29, 2009 at 11:19:08AM -0400, Vlad Yasevich wrote:
> >>  7 2.000205    10.0.0.15     10.0.0.11         SCTP     DATA
> >>  8 2.000501    10.0.0.11     10.0.0.15         SCTP     SACK DATA
> >>  9 2.200484    10.0.0.15     10.0.0.11         SCTP     SACK
> > This is what I would expect.
>
> Hmm... time to re-read 6.1 and 6.2...
> [...]
> Since we received only 1 packet so far, the SACK is delayed.  The implementers
> have focused on section 6.2, but seemed to have ignored the following text
> from 6.1:
>
>    Before an endpoint transmits a DATA chunk, if any received DATA
>    chunks have not been acknowledged (e.g., due to delayed ack), the
>    sender should create a SACK and bundle it with the outbound DATA
>    chunk, as long as the size of the final SCTP packet does not exceed
>    the current MTU.  See Section 6.2.
>
> Looks like BSD does this and linux doesn't appear to.  Linux has been doing this
> since the beginning...
>
> Doug, can you regenerate you patch with proper commit comment and sign-off
> (according to Documentations/SubmittingPatches).

I just sent a patch, but please keep in mind that I am not by any means
an expert on this code.  I've tested my patch only under conditions
where no packet loss was occurring, so I can not vouch for its behaviour
when losses do occur, nor do I know how it will interact with features
that I haven't used during testing.  However, to the best of knowledge,
this patch does correctly implement the intended sematics of RFC 4960.

--Doug.
