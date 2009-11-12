From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Thu, 12 Nov 2009 17:16:52 +0000
Subject: Re: [Lksctp-developers] [PATCH 2/3] sctp: fix integer overflow when setting the autoclose timer
Message-Id: <20091112171652.GS10897@shell.iptel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4AFC37DD.8090605@hp.com>
In-Reply-To: <4AFC37DD.8090605@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Nov 12, 2009 at 12:05, Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
> 
> 
> Andrei Pelinescu-Onciul wrote:
> > On Nov 12, 2009 at 11:29, Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
> >>
> >> Andrei Pelinescu-Onciul wrote:
> >>> When setting the autoclose timeout in jiffies there is a possible
> >>> integer overflow if the value in seconds is very large
> >>> (e.g. for 2^22 s with HZ24). The problem appears even on
> >>> 64-bit due to the integer promotion rules. The fix is just a cast
> >>>  to unsigned long.
> >>>
> >>> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
> >>> ---
> >>>  net/sctp/associola.c |    2 +-
> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> >>> index 525864b..7f69f4d 100644
> >>> --- a/net/sctp/associola.c
> >>> +++ b/net/sctp/associola.c
> >>> @@ -166,7 +166,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
> >>>  	asoc->timeouts[SCTP_EVENT_TIMEOUT_HEARTBEAT] = 0;
> >>>  	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
> >>>  	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] > >>> -		sp->autoclose * HZ;
> >>> +		(unsigned long)sp->autoclose * HZ;
> >>>  
> >>>  	/* Initilizes the timers */
> >>>  	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)
> >> This becomes unnecessary with Patch 3.
> > 
> > I don't think so. Patch 3 makes sure 
> > sp->autoclose <= (MAX_SCHEDULE_TIMEOUT / HZ).
> > On 64 bits this is always true, because autoclose is u32,
> > MAX_SCHEDULE_TIMEOUT is LONG_MAX (2^63-1) and HZ <= 1024, so on 64 bits
> > patch 3 will not do anything and sp->autoclose * HZ can still overflow
> > an int.
> > E.g.: autoclose= 2^22, HZ24.
> > 2^22 < (2^63-1)/1024 => patch 3 does not change autoclose
> > However  2^22 * 1024 = 2^32 which is > UINT_MAX =>
> > asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] will be set to
> > (uint)2^32 = 0!
> > 
> 
> Ok.  So, we'll change patch 3 to do:
> 
> if (sp->autoclose * HZ > MAX_SCHEDULE_TIMEOUT)
> 	sp->autoclose = MAX_SCHEDULE_TIMEOUT/HZ;

It will still not work on 64 bits (always true) and it will also won't work
anymore on 32 bits (e.g. on 32 bits: 2^22 * 1024 > 2^31-1 it's false
 and henve autoclose won't be fixed).

If you want to do it from sctp_setsockopt_autoclose() you would have
 to add another  condition, something like:

/* 32 bits: */
if ((sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
...

/* 64 bits hack */
if (sp->autoclose > (UINT_MAX / HZ))
    sp->autoclose = UINT_MAX / HZ;

but in this case you'll reduce the maximum interval on 64 bits for no
good reason.

The  (unsigned long) cast in the patch above (sctp_association_init()),
solves the problem on 64 bits, has no performance impact, allows for
larger timeouts on 64 bits  and is more elegant (well at least from my
point of view).

Andrei
