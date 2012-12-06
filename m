From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 06 Dec 2012 19:14:20 +0000
Subject: Re: Possible SCTP peer receive window bug
Message-Id: <20121206191420.GC17192@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Dec 06, 2012 at 03:42:20PM +0000, Jamie Parsons wrote:
> Hi Neil and Vlad,
> 
> I've reproed the problem on Fedora 17 with a 3.6.9-2.fc17.x86_64 kernel.  I've placed the trace and tcpdump in the ftp directory, they are named Fedora17.txt and Fedora17.pcap respectively.  I've also placed some systemtap trace (stap.txt) along with the system tap script (rwnd_stap) in the ftp directory.  
> 
> There is still a bug in the system tap script as the exit value of functions is always returned as the same as the entry value to functions.  The output may still be of some use to you though.
> 
> Let me know if there is anything else you need (or if you spot what the stap script bug is).
> 
> Thanks,
> 
> Jamie 
> 
Jamie, thanks for the info.  I figured out the problem with my stap script -
basically just an older version of systemtap that had a bug.  Anywho, regarding
your stap output, yes, I think its useful - or rather its interesting.  The
output of sctp_packet_append_chunk is always like this:
sctp_packet_append_chunk input asoc = 0xffff880216137800 peer rwnd = 1236
sctp_packet_append_chunk input asoc = 0xffff880216137800 peer rwnd = 1236
sctp_packet_append_chunk reduces asoc 0xffff880216137800 peer rwnd to 1236

That is to say we always appear to get two input probe triggers, and a single
output probe trigger.  Not sure if thats some buffering problem in systemtap or
indicative of something else. If it were something else Id start by guessing
that we're getting parallel accesses to the same association from 2 different
contexts, but from what I can see, lock_sock and friends protects all of our
access paths properly at the top and bottom of the stack (save for the ootb
case, which is only triggered if we don't find an association in sctp_rcv.

About the only thing that jumps out at me in that receive path is the case in
which sk_bound_dev_if != af->skb_iif(skb).  If we fall into that case, even if
we did find an assocation, we move to using the ctl_sock to process the chunk,
but we may end up using the transport that was found during the association
lookup.  If that were to occur, we would have two contexts not sharing the same
socket lock, but sharing a transport pointer, that could lead to double access
of the same association.

Unfortunately, since we're only using a single interface here, I don't quite see
how that can happen.  Vlad, do you have any thoughts?

Regards
Neil

> -----Original Message-----
> From: Neil Horman [mailto:nhorman@tuxdriver.com] 
> Sent: 06 December 2012 14:04
> To: Vlad Yasevich
> Cc: Jamie Parsons; Peter Brittain; linux-sctp@vger.kernel.org
> Subject: Re: Possible SCTP peer receive window bug
> 
> On Wed, Dec 05, 2012 at 12:11:02PM -0500, Vlad Yasevich wrote:
> > On 12/05/2012 11:30 AM, Neil Horman wrote:
> > >On Tue, Dec 04, 2012 at 09:58:35AM -0500, Neil Horman wrote:
> > >>On Tue, Dec 04, 2012 at 01:34:54PM +0000, Jamie Parsons wrote:
> > >>>Hi Neil and Vlad,
> > >>>
> > >>>I've spoken to IT services and they can install the Fedora 17 OS on a box for me.  Is that recent enough a kernel to repro the issue on?
> > >>>
> > >>>Thanks,
> > >>>
> > >>>Jamie
> > >>>
> > >>Yes, it is I think.  Vlad and I have also discussed this and we 
> > >>think a systemtap script might be in order here so we can better 
> > >>track what the rwnd value is doing as your test case progresses.  
> > >>I'm sorry I've not gotten that to you yet, but I'm working on it.
> > >>Neil
> > >>
> > >
> > >
> > >So, I have to apologize, but systemtap kinda sucks to work with.  Its 
> > >not working yet, but I wanted to post this too you in case you have 
> > >better systemtap skills than I do.  Regardless this stap script is 
> > >generall the thing we want to run and should give us a fairly good 
> > >view (when it works) of whats happening with an associations peer rwnd value in the stack.
> > >
> > >Best
> > >Neil
> > >
> > >
> > >probe module("sctp").function("sctp_assoc_update").return {
> > >	printf("sctp_assoc_update updates asoc %p peer rwnd to %d\n", $asoc, 
> > >$asoc->peer->rwnd); }
> > >
> > >
> > >probe module("sctp").function("sctp_retransmit_mark") {
> > >	printf("sctp_retransmit_mark increases asoc %p peer rwnd to %d\n", 
> > >$asoc, $q->asoc->peer->rwnd); }
> > >
> > 
> > shouldn't the above be ".return"?  Otherwise, we are triggered at 
> > function start.  might be worth a try to probe both start and end and 
> > see what the diff.
> > 
> > >probe module("sctp").function("sctp_outq_sack") {
> > >	printf("sctp_outq_sack updates asoc %p peer rwnd to %d\n", $q->asoc, 
> > >$q->asoc->peer->rwnd); }
> > >
> > 
> > Same here...
> > 
> Yeah, it should be a .return, thanks.  We could definately do it at the start and end as well if you'd like, it might be handy.  Unfortunately, the major problem I'm running into at the moment, is that stap is telling me that $q isn't accessible at the start and end of the function, which makes no sense to me.
> I'm trying to get up with Will Cohen to help me sort that particular mess out.
> 
> Neil
> 
> > -vlad
> > 
> > >probe module("sctp").function("sctp_packet_append_data").return {
> > >	printf("sctp_packet_append_data reduces asoc %p peer rwnd to %d\n", 
> > >$asoc, $asoc->peer->rwnd); }
> > >
> > >probe module("sctp").function("sctp_process_init").return {
> > >	printf("sctp_process_init updates assoc %p peer rwnd to %d\n", 
> > >$asoc, $asoc->peer->rwnd); }
> > >
> > >
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
