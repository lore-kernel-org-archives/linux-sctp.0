From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 06 Dec 2012 14:03:48 +0000
Subject: Re: Possible SCTP peer receive window bug
Message-Id: <20121206140347.GA17192@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Dec 05, 2012 at 12:11:02PM -0500, Vlad Yasevich wrote:
> On 12/05/2012 11:30 AM, Neil Horman wrote:
> >On Tue, Dec 04, 2012 at 09:58:35AM -0500, Neil Horman wrote:
> >>On Tue, Dec 04, 2012 at 01:34:54PM +0000, Jamie Parsons wrote:
> >>>Hi Neil and Vlad,
> >>>
> >>>I've spoken to IT services and they can install the Fedora 17 OS on a box for me.  Is that recent enough a kernel to repro the issue on?
> >>>
> >>>Thanks,
> >>>
> >>>Jamie
> >>>
> >>Yes, it is I think.  Vlad and I have also discussed this and we think a
> >>systemtap script might be in order here so we can better track what the rwnd
> >>value is doing as your test case progresses.  I'm sorry I've not gotten that to
> >>you yet, but I'm working on it.
> >>Neil
> >>
> >
> >
> >So, I have to apologize, but systemtap kinda sucks to work with.  Its not
> >working yet, but I wanted to post this too you in case you have better systemtap
> >skills than I do.  Regardless this stap script is generall the thing we want to
> >run and should give us a fairly good view (when it works) of whats happening
> >with an associations peer rwnd value in the stack.
> >
> >Best
> >Neil
> >
> >
> >probe module("sctp").function("sctp_assoc_update").return {
> >	printf("sctp_assoc_update updates asoc %p peer rwnd to %d\n", $asoc, $asoc->peer->rwnd);
> >}
> >
> >
> >probe module("sctp").function("sctp_retransmit_mark") {
> >	printf("sctp_retransmit_mark increases asoc %p peer rwnd to %d\n", $asoc, $q->asoc->peer->rwnd);
> >}
> >
> 
> shouldn't the above be ".return"?  Otherwise, we are triggered at
> function start.  might be worth a try to probe both start and end
> and see what the diff.
> 
> >probe module("sctp").function("sctp_outq_sack") {
> >	printf("sctp_outq_sack updates asoc %p peer rwnd to %d\n", $q->asoc, $q->asoc->peer->rwnd);
> >}
> >
> 
> Same here...
> 
Yeah, it should be a .return, thanks.  We could definately do it at the start
and end as well if you'd like, it might be handy.  Unfortunately, the major
problem I'm running into at the moment, is that stap is telling me that $q isn't
accessible at the start and end of the function, which makes no sense to me.
I'm trying to get up with Will Cohen to help me sort that particular mess out.

Neil

> -vlad
> 
> >probe module("sctp").function("sctp_packet_append_data").return {
> >	printf("sctp_packet_append_data reduces asoc %p peer rwnd to %d\n", $asoc, $asoc->peer->rwnd);
> >}
> >
> >probe module("sctp").function("sctp_process_init").return {
> >	printf("sctp_process_init updates assoc %p peer rwnd to %d\n", $asoc, $asoc->peer->rwnd);
> >}
> >
> >
> 
> 
