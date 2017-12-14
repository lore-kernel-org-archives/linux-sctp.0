From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 14 Dec 2017 21:04:22 +0000
Subject: Re: [PATCH 2/4] sctp: Add ip option support
Message-Id: <20171214210422.GQ3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171127193121.2666-1-richard_c_haines@btinternet.com>
	<20171212160800.GE3532@localhost.localdomain>
	<CAHC9VhR+WoO3UtdXLp+9mQ=c=avpEQ5-W8vTkEWfxXH1EkUS8A@mail.gmail.com>
	<20171212215638.GH3532@localhost.localdomain>
	<CAHC9VhQ5iQsXum6NVkL-qdzu=bxVcaOscPjTSVufLzRbW_1_Pw@mail.gmail.com>
In-Reply-To: <CAHC9VhQ5iQsXum6NVkL-qdzu=bxVcaOscPjTSVufLzRbW_1_Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, Dec 12, 2017 at 05:24:46PM -0500, Paul Moore wrote:
> On Tue, Dec 12, 2017 at 4:56 PM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > On Tue, Dec 12, 2017 at 04:33:03PM -0500, Paul Moore wrote:
> >> On Tue, Dec 12, 2017 at 11:08 AM, Marcelo Ricardo Leitner
> >> <marcelo.leitner@gmail.com> wrote:
> >> > Hi Richard,
> >> >
> >> > On Mon, Nov 27, 2017 at 07:31:21PM +0000, Richard Haines wrote:
> >> > ...
> >> >> --- a/net/sctp/socket.c
> >> >> +++ b/net/sctp/socket.c
> >> >> @@ -3123,8 +3123,10 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
> >> >>
> >> >>       if (asoc) {
> >> >>               if (val = 0) {
> >> >> +                     struct sctp_af *af = sp->pf->af;
> >> >>                       val = asoc->pathmtu;
> >> >> -                     val -= sp->pf->af->net_header_len;
> >> >> +                     val -= af->ip_options_len(asoc->base.sk);
> >> >> +                     val -= af->net_header_len;
> >> >>                       val -= sizeof(struct sctphdr) +
> >> >>                                       sizeof(struct sctp_data_chunk);
> >> >>               }
> >> >
> >> > Right below here there is a call to sctp_frag_point(). That function
> >> > also needs this tweak.
> >> >
> >> > Yes, we should simplify all these calculations. I have a patch to use
> >> > sctp_frag_point on where it is currently recalculating it on
> >> > sctp_datamsg_from_user(), but probably should include other places as
> >> > well.
> >>
> >> FYI: Richard let me know he is occupied with another project at the
> >> moment and likely won't be able to do another respin until next week
> >> at the earliest.
> >
> > Okay, thanks. I can do a follow-up patch if it helps.
> 
> I'll leave that up to you, I think your comments are pretty
> straightforward and should be easy for Richard to incorporate, and
> there is a lot to be said for including the fix in the original patch,
> but if you would prefer to send a separate patch I think that's fine
> too.

This patchset conflicts with the stream schedulers patchset (on
sctp.h) and will also conflict with the stream interleaving patchsets
from Xin (other files).

I rebased the patchset upon current crypto tree but the last patchset
on stream interleaving is still to be accepted via net-next.

I'm unsure on how to proceed here. Please advise.

Thanks,
Marcelo
