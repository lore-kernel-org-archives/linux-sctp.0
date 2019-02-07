From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 07 Feb 2019 14:44:38 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190207144438.GB23613@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <c13067c0-f127-50a0-9ae0-4be7f0399c0d@arista.com>
 <20190206210723.GD13621@localhost.localdomain>
 <20190206212316.GD16887@hmswarspite.think-freely.org>
 <a21b3ca1-fb51-99cd-4979-62a8c6476cd7@arista.com>
In-Reply-To: <a21b3ca1-fb51-99cd-4979-62a8c6476cd7@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julien Gomes <julien@arista.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, vyasevich@gmail.com, lucien.xin@gmail.com

On Wed, Feb 06, 2019 at 01:48:42PM -0800, Julien Gomes wrote:
> 
> 
> On 2/6/19 1:23 PM, Neil Horman wrote:
> > On Wed, Feb 06, 2019 at 07:07:23PM -0200, Marcelo Ricardo Leitner wrote:
> >> On Wed, Feb 06, 2019 at 12:48:38PM -0800, Julien Gomes wrote:
> >>>
> >>>
> >>> On 2/6/19 12:37 PM, Marcelo Ricardo Leitner wrote:
> >>>> On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> >>>>> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> >>>>> structures longer than the current definitions.
> >>>>>
> >>>>> This should prevent unjustified setsockopt() failures due to struct
> >>>>> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> >>>>> binaries that should be compatible, but were built with later kernel
> >>>>> uapi headers.
> >>>>
> >>>> Not sure if we support backwards compatibility like this?
> >>>>
> >>>> My issue with this change is that by doing this, application will have
> >>>> no clue if the new bits were ignored or not and it may think that an
> >>>> event is enabled while it is not.
> >>>>
> >>>> A workaround would be to do a getsockopt and check the size that was
> >>>> returned. But then, it might as well use the right struct here in the
> >>>> first place.
> >>>>
> >>>> I'm seeing current implementation as an implicitly versioned argument:
> >>>> it will always accept setsockopt calls with an old struct (v4.11 or
> >>>> v4.12), but if the user tries to use v3 on a v1-only system, it will
> >>>> be rejected. Pretty much like using a newer setsockopt on an old
> >>>> system.
> >>>
> >>> With the current implementation, given sources that say are supposed to
> >>> run on a 4.9 kernel (no use of any newer field added in 4.11 or 4.12),
> >>> we can't rebuild the exact same sources on a 4.19 kernel and still run
> >>> them on 4.9 without messing with structures re-definition.
> >>
> >> Maybe what we want(ed) here then is explicit versioning, to have the 3
> >> definitions available. Then the application is able to use, say struct
> >> sctp_event_subscribe, and be happy with it, while there is struct
> >> sctp_event_subscribe_v2 and struct sctp_event_subscribe_v3 there too.
> >>
> >> But it's too late for that now because that would break applications
> >> already using the new fields in sctp_event_subscribe.
> >>
> > Yeah, I'm not supportive of codifying that knoweldge in the kernel.  If we were
> > to support bi-directional versioning, I would encode it into lksctp-tools rather
> > than the kernel.
> 
> I'm not sure that forcing a library on users is a good reason to break UAPI.
> 
Thats a misleading statement.  We've never supported running newer applications
on older kernels, and no one is forcing anyone to use the lksctp-tools library,
I was only suggesting that, if we were to support this compatibility, that might
be a place to offer it.

Its also worth noting that we have precident for this.  If you look at the git
log, this particular structure has been extended about 6 times in the life of
sctp.

> > 
> >>>
> >>> I understand your point, but this still looks like a sort of uapi
> >>> breakage to me.
> >>
> >> Not disagreeing. I really just don't know how supported that is.
> >> Willing to know so I can pay more attention to this on future changes.
> >>
> >> Btw, is this the only occurrence?
> >>
> > No, I think there are a few others (maybe paddrparams?)
> > 
> >>>
> >>>
> >>> I also had another way to work-around this in mind, by copying optlen
> >>> bytes and checking that any additional field (not included in the
> >>> "current" kernel structure definition) is not set, returning EINVAL in
> >>> such case to keep a similar to current behavior.
> >>> The issue with this is that I didn't find a suitable (ie not totally
> >>> arbitrary such as "twice the existing structure size") upper limit to
> >>> optlen.
> >>
> >> Seems interesting. Why would it need that upper limit to optlen?
> >>
> > I think the thought was to differentiate between someone passing a legit larger
> > structure from a newer UAPI, from someone just passing in a massive
> > inappropriately sized buffer (even if the return on both is the same).
> > 
> >> Say struct v1 had 4 bytes, v3 now had 12. The user supplies 12 bytes
> >> to the kernel that only knows about 4 bytes. It can check that (12-4)
> >> bytes in the end, make sure no bit is on and use only the first 4.
> >>
> >> The fact that it was 12 or 200 shouldn't matter, should it? As long as
> >> the (200-4) bytes are 0'ed, only the first 4 will be used and it
> >> should be ok, otherwise EINVAL. No need to know how big the current
> >> current actually is because it wouldn't be validating that here: just
> >> that it can safely use the first 4 bytes.
> >>
> > I'm less than excited about making the kernel check an unbounded user space
> > buffer, thats seems like a potential DOS attack from an unpriviledged user to
> > me.  I'm also still hung up on the notion that, despite how we do this, this
> > patch is going into the latest kernel, so it will only work on a kernel that
> > already understands the most recent set of subscriptions.  It would work if we,
> > again someday in the future extended this struct, someone built against that
> > newer UAPI, and then tried to run it on a kernel that had this patch.
> 
> The patch is going into the latest, but can also be backported on future
> stables.
> I don't think "not fixing it because it's not fixed yet" is a good
> reason to keep things the way they are. But maybe that's just me.
> Given that the structure has already been extended several times, there
> is pretty much nothing to keep this from happening again and again.
> 
Also misleading, as it assumes that we're not intentionally doing this.  I get
wanting to support running applications built for newer kernels on older
kernels, but thats just not something that we do, and to say thats broken is
misleading.  Older applications are required to run on newer kernels, but not
vice versa, which is what you are asking for.  

And yes, this patch can be backported to older stable kernels, but by that same
token, so can the patches that extend the struct, which would also fix the
problem, while supporting the newer features, which seems to me to be the better
solution for applications which are looking for that support.


> > 
> > FWIW, there is an existing implied method to determine the available
> > subscription events. sctp_getsockopt_events does clamp the size of the output
> > buffer, and returns that information in the optlen field via put_user.  An
> > application that was build against UAPIs from 4.19 could pass in the 4.19
> > sctp_event_subscribe struct to sctp_getsockopt_events, and read the output
> > length, whcih would inform the application of the events that the kernel is
> > capable of reporting, and limit itself to only using those events.  Its not a
> > perfect solution, but its direct, understandable and portable.
> > 
> > Neil
> > 
> >>>
> >>>>
> >>>>>
> >>>>> Signed-off-by: Julien Gomes <julien@arista.com>
> >>>>> ---
> >>>>>  net/sctp/socket.c | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >>>>> index 9644bdc8e85c..f9717e2789da 100644
> >>>>> --- a/net/sctp/socket.c
> >>>>> +++ b/net/sctp/socket.c
> >>>>> @@ -2311,7 +2311,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
> >>>>>  	int i;
> >>>>>  
> >>>>>  	if (optlen > sizeof(struct sctp_event_subscribe))
> >>>>> -		return -EINVAL;
> >>>>> +		optlen = sizeof(struct sctp_event_subscribe);
> >>>>>  
> >>>>>  	if (copy_from_user(&subscribe, optval, optlen))
> >>>>>  		return -EFAULT;
> >>>>> -- 
> >>>>> 2.20.1
> >>>>>
> >>>
> >>
> 
> -- 
> Julien Gomes
> 
