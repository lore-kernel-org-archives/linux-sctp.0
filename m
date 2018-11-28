From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 28 Nov 2018 02:08:38 +0000
Subject: Re: [PATCH net] sctp: always set frag_point on pmtu change
Message-Id: <20181128020838.GJ3601@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181118204736.7178-1-jakub.audykowicz@gmail.com>
 <CADvbK_fj6iauj2COg7gASLMMzD85c9e4pzVMt4Tz4kmHxHMUWA@mail.gmail.com>
 <b4bddea8-6fc4-b235-3cf6-8d1f3e72e97e@gmail.com>
In-Reply-To: <b4bddea8-6fc4-b235-3cf6-8d1f3e72e97e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, network dev <netdev@vger.kernel.org>

On Tue, Nov 27, 2018 at 11:18:02PM +0100, Jakub Audykowicz wrote:
> On 2018-11-19 08:20, Xin Long wrote:
> 
> > On Mon, Nov 19, 2018 at 5:49 AM Jakub Audykowicz
> > <jakub.audykowicz@gmail.com> wrote:
> >> Calling send on a connected SCTP socket results in kernel panic if
> >> spp_pathmtu was configured manually before an association is established
> >> and it was not reconfigured to another value once the association is
> >> established.
> >>
> >> Steps to reproduce:
> >> 1. Set up a listening SCTP server socket.
> >> 2. Set up an SCTP client socket.
> >> 3. Configure client socket using setsockopt SCTP_PEER_ADDR_PARAMS with
> >>     spp_pathmtu set to a legal value (e.g. 1000) and
> >>     SPP_PMTUD_DISABLE set in spp_flags.
> >> 4. Connect client to server.
> >> 5. Send message from client to server.
> >>
> >> At this point oom-killer is invoked, which will eventually lead to:
> >> [    5.197262] Out of memory and no killable processes...
> >> [    5.198107] Kernel panic - not syncing: System is deadlocked on memory
> >>
> >> Commit 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
> >> introduces sctp_assoc_update_frag_point, but this function is not called
> >> in this case, causing frag_point to be zero:
> >>  void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)
> >>  {
> >> -       if (asoc->pathmtu != pmtu)
> >> +       if (asoc->pathmtu != pmtu) {
> >>                 asoc->pathmtu = pmtu;
> >> +               sctp_assoc_update_frag_point(asoc);
> >> +       }
> >>
> >> In this scenario, on association establishment, asoc->pathmtu is already
> >> 1000 and pmtu will be as well. Before this commit the frag_point was being
> >> correctly set in the scenario described. Moving the call outside the if
> >> block fixes the issue.
> >>
> >> I will be providing a separate patch to lksctp-tools with a simple test
> >> reproducing this problem ("func_tests: frag_point should never be zero").
> >>
> >> I have also taken the liberty to introduce a sanity check in chunk.c to
> >> set the frag_point to a non-negative value in order to avoid chunking
> >> endlessly (which is the reason for the eventual panic).
> >>
> >> Fixes: 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
> >> Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> >> ---
> >>  include/net/sctp/constants.h |  3 +++
> >>  net/sctp/associola.c         | 13 +++++++------
> >>  net/sctp/chunk.c             |  6 ++++++
> >>  3 files changed, 16 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
> >> index 8dadc74c22e7..90316fab6f04 100644
> >> --- a/include/net/sctp/constants.h
> >> +++ b/include/net/sctp/constants.h
> >> @@ -293,6 +293,9 @@ enum { SCTP_MAX_GABS = 16 };
> >>                                          */
> >>  #define SCTP_DEFAULT_MINSEGMENT 512    /* MTU size ... if no mtu disc */
> >>
> >> +/* An association's fragmentation point should never be non-positive */
> >> +#define SCTP_FRAG_POINT_MIN 1
> >> +
> >>  #define SCTP_SECRET_SIZE 32            /* Number of octets in a 256 bits. */
> >>
> >>  #define SCTP_SIGNATURE_SIZE 20         /* size of a SLA-1 signature */
> >> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> >> index 6a28b96e779e..44d71a1af62e 100644
> >> --- a/net/sctp/associola.c
> >> +++ b/net/sctp/associola.c
> >> @@ -1431,13 +1431,14 @@ void sctp_assoc_update_frag_point(struct sctp_association *asoc)
> >>
> >>  void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)
> >>  {
> >> -       if (asoc->pathmtu != pmtu) {
> >> -               asoc->pathmtu = pmtu;
> >> -               sctp_assoc_update_frag_point(asoc);
> >> -       }
> >> +       pr_debug("%s: before asoc:%p, pmtu:%d, frag_point:%d\n",
> >> +               __func__, asoc, asoc->pathmtu, asoc->frag_point);
> >> +
> >> +       asoc->pathmtu = pmtu;
> >> +       sctp_assoc_update_frag_point(asoc);
> >>
> >> -       pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
> >> -                asoc->pathmtu, asoc->frag_point);
> >> +       pr_debug("%s: after asoc:%p, pmtu:%d, frag_point:%d\n",
> >> +               __func__, asoc, asoc->pathmtu, asoc->frag_point);
> >>  }
> > The idea was whenever asoc->pathmtu changes,  frag_point should
> > be updated, but we missed one place in sctp_association_init().
> >
> > Another issue is after 4-shakehand, the client's asoc->intl_enable
> > may be changed from 0 to 1, which means the frag_point should
> > also be updated, since [1]:
> >
> > void sctp_assoc_update_frag_point(struct sctp_association *asoc)
> > {
> >         int frag = sctp_mtu_payload(sctp_sk(asoc->base.sk), asoc->pathmtu,
> >                                     sctp_datachk_len(&asoc->stream)); <--- [1]
> >
> > So one fix for both issues is:
> >
> > diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> > index 0a78cdf..19d596d 100644
> > --- a/net/sctp/stream_interleave.c
> > +++ b/net/sctp/stream_interleave.c
> > @@ -1327,4 +1327,5 @@ void sctp_stream_interleave_init(struct
> > sctp_stream *stream)
> >         asoc = container_of(stream, struct sctp_association, stream);
> >         stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
> >                                        : &sctp_stream_interleave_0;
> > +       sctp_assoc_update_frag_point(asoc);
> >  }
> >
> >
> >>  /* Update the association's pmtu and frag_point by going through all the
> >> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> >> index ce8087846f05..9f0e64ddbd9c 100644
> >> --- a/net/sctp/chunk.c
> >> +++ b/net/sctp/chunk.c
> >> @@ -190,6 +190,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> >>         /* This is the biggest possible DATA chunk that can fit into
> >>          * the packet
> >>          */
> >> +       if (asoc->frag_point < SCTP_FRAG_POINT_MIN) {
> >> +               pr_warn("%s: asoc:%p->frag_point is less than allowed (%d<%d)",
> >> +                       __func__, asoc, asoc->frag_point, SCTP_FRAG_POINT_MIN);
> >> +               pr_warn("forcing minimum value to avoid chunking endlessly");
> >> +               asoc->frag_point = SCTP_FRAG_POINT_MIN;
> >> +       }
> >>         max_data = asoc->frag_point;
> > This won't happen if we sync frag_point on time like the above.
> 
> I know a better fix has been proposed and acked already but I would like to 
> follow this up a bit. I still think there is some value to the changes in this 

Any time. :-)

> patch. First of all, I am not sure the if statement in sctp_assoc_set_pmtu is 
> of any practical benefit. I assume its intention is optimization, but I'm 
> skeptical. Originally it made little sense, since it's not like assigning the 
> same value would be incorrect or costly. Upon introducing 

Agree. In SCTP stack usually we are not worried by the effects of a
single assignment, especially in control path.

> sctp_assoc_update_frag_point I can see the if being of more use since it is 
> theoretically useless to call this function if MTU is the same, but as it 
> turns out it might still be useful at what I would estimate to be a negligible 
> cost. I propose to do away with this if block.

Now it is more about consistency. If it is already set to a
value and the user sets it again, there should be no behavioral
difference.  We don't want users calling the same function multiple
times for it to "really stick" or so, for example.

The if in there, then, now serves to protect it from this.

> 
> As for the code in chunk, I'm not too proud of this hacky workaround, but 
> I still think there should be some way to avoid chunking endlessly and running 
> OOM if the configuration is wrong (here due to an implementation oversight), 
> a last-ditch fail-safe of sorts. How do you guys think this could be 

Good point.

> accomplished?

Considering that the idea is for sctp_datamsg_from_user to just
consume asoc->frag_point, we can add this check right at the end of
sctp_assoc_update_frag_point. So that we will always set it to a sane
value, no matter what, and warn if it is bogus, for whatever reason.
This way it will also warn right when it got set to a bad value.

Something like (just a draft):

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 685c7ef11eb4..128a4dd609f3 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1427,8 +1427,15 @@ void sctp_assoc_update_frag_point(struct sctp_association *asoc)
 
 	frag = min_t(int, frag, SCTP_MAX_CHUNK_LEN -
 				sctp_datachk_len(&asoc->stream));
+	frag = SCTP_TRUNC4(frag);
 
-	asoc->frag_point = SCTP_TRUNC4(frag);
+	if (frag < SCTP_FRAG_POINT_MIN) {
+		pr_warn_ratelimited("%s: asoc:%p frag_point is less than allowed (%d < %d). Forcing to the minimum value.",
+				    __func__, asoc, asoc->frag_point, SCTP_FRAG_POINT_MIN);
+		frag = SCTP_FRAG_POINT_MIN;
+	}
+
+	asoc->frag_point = frag;
 }
 
 void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)

Note that it should have only 1 pr_warn_ratelimited (no line breaks)
and be rate limited because the application could exploit this to
trigger endless warnings and having it logged multiple times won't
help.

Thanks,
  Marcelo
