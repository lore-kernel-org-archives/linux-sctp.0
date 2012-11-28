From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 28 Nov 2012 20:55:08 +0000
Subject: Re: Possible SCTP peer receive window bug
Message-Id: <20121128205508.GC4697@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Nov 28, 2012 at 10:50:53AM -0500, Vlad Yasevich wrote:
> Hi Neil
> 
> I've been looking at this one as well.
> 
Awesome, thanks!

> On 11/28/2012 10:28 AM, Neil Horman wrote:
> >On Tue, Nov 27, 2012 at 02:42:47PM +0000, Jamie Parsons wrote:
> >>Thanks Neil,
> >>
> >>That would be great.
> >>
> >>Jamie
> >>
> >Ok, so a few thoughts:
> >
> >1) I didn't read closely enough in your description below.  You're using a RHEL6
> >kernel.  This list is meant for upstream sctp development.  I'll gladly help you
> >as best as I can, but you're going to want to reproduce this on an more recent
> >upstream kernel.  You should also open a support call with Red Hat, we can use
> >what we determine from testing here to tell if a backport of code to that kernel
> >is needed
> 
> Just glanced at rhel6 code base and it seem to have all the restart patches.
> 
I agree, I didn't see anything out of place.

> >
> >2) I see where your connection fails
> >and you send a new INIT chunk (frame 1797), after which you start seeing lots of
> >HEARTBEAT frames get sent periodically (suggesting that you've really cranked
> >down the hbinterval sysctl. Not sure why you've done that, but you likely want
> >to back it off somewhat, as it generates unneeded traffic.
> 
> I don't have access to tcpdump, but in the case of association
> restart, there would be some HB to verify the transports.  Not sure
> how many you see in the capture.
> 
There are HB's, lots of them, suggesting a significant reduction in the
transport hb interval (haven't done an exact measurement yet).  The odd thing
is, I only see one transport, and the single INIT/INIT-ACK/COOKIE/COOKIE-ACK
cycle I see in the tcpdump halfway through, is on the same ip's/ports as frames
prior to it, suggesting that its not a new connection or transport startup, but
rather its being seen as a duplicate INIT chunk.

> >
> >3) One thing that does jump out at me is the fact that the INIT chunk in frame
> >1797, is being made from and too the same src and dst addresses and to the same
> >src/dst ports, indicating this is not an esblishing of a new transport in the
> >association (the typical failover case), but rather its going to be handled as a
> >duplicate INIT.  I'm wondering if perhaps we don't loose some information in the
> >duplicate INIT handling proces, that leads to a few bytes getting dropped from
> >the receive window.
> 
> It seems from the description that an association restart (duplicate
> case A) is what the setup is trying to achieve.  My guess is that
> during a fault, all addresses from the old systems are migrated to a
> new one and association is restarted.
> 
ok, that makes some sense.

> Looking at this case, peer.rwnd should get replaced by what's in the
> cookie of the restarted association.  Also, any buffered outgoing
> data that may impact peer.rwnd is discarded as well so we should
> start with an empty outqueue.
> 
Are you sure about that?  sctp_process_init is called from
sctp_sf_do_unexpected_init, and that appears to be what sets peer.rwnd, not the
information found in the cookie that gets echoed back to us.  Perhaps thats the
problem here?
  
> Jamie,  do you get a ASSOCIATION_RESTART event when you force the
> failover?  Can you grab SCTP_STATUS right after this event and check
> the sstat_rwnd?
> 
+1

> Thanks
> -vlad
> 
Thanks Vlad!
Neil

> >
> >Can you please do the following:
> >1) Provide the complete output of the SCTP_STATUS socket option when you
> >encounter the issue above
> >
> >2) Try to recreate this on a recent upstream kernel  (the head of the net-next
> >tree would be great).
> >
> >3) Describe in more detail how you force the failover event to occur, and what
> >sort of failover paths exist between Peer A and the Linux box (your description
> >below suggests there is only one path between the two)
> >
> >Also, you should open a support ticket with Red Hat, as they will be able to
> >support this kernel for you (I work for Red Hat, and if we do find a bug here,
> >we'll need a support ticket to backport it for you).
> >
> >Thanks
> >Neil
> >
> >>-----Original Message-----
> >>From: Neil Horman [mailto:nhorman@tuxdriver.com]
> >>Sent: 27 November 2012 14:38
> >>To: Jamie Parsons
> >>Cc: linux-sctp@vger.kernel.org; Peter Brittain
> >>Subject: Re: Possible SCTP peer receive window bug
> >>
> >>On Tue, Nov 27, 2012 at 11:05:03AM +0000, Jamie Parsons wrote:
> >>>Hi Neil,
> >>>
> >>>The FTP server is ftp.uk.metaswitch.com.
> >>>username:  linux-sctp
> >>>password:  8RyJ97Th
> >>>
> >>>You will only be able to access it from 99.127.245.201.
> >>>
> >>>The tcpdump file is called 9932filter.pcap
> >>>
> >>>My test setup is as follows:
> >>>
> >>>___________               ___________               ____________
> >>>|          |              |  Linux  |               |           |
> >>>| Peer A   |--------------|   Box   |---------------|  Peer B   |
> >>>|__________|              |_________|               |___________|
> >>>
> >>>
> >>>Peer A and Peer B are using the Linux box as a pipe to send ISDN messages between themselves.  The ISDN messages are sent over SCTP connections from one peer to the linux box, the linux box then forwards them over another SCTP connection to the other peer.  There are multiple SCTP connections between the linux box and both Peer A and Peer B, each of the SCTP connections uses a different port on the linux box.  Peer A is the box which fails over.
> >>>
> >>>The tcpdump which I have placed in the FTP directory was gathered on the linux box and filtered on the port so that only contains packets for one particular SCTP connection between Peer A and the linux box.
> >>>
> >>>In the tcpdump the IP addresses are as follows:
> >>>Peer A: 10.249.59.1
> >>>linux box: 10.224.191.1
> >>>
> >>>Peer A fails over at 12:20:59.
> >>>The linux box stops sending messages at 12:21:24.
> >>>
> >>>The kernel version on the linux box (obtained using uname -a) is 2.6.32-279.9.1.el6.x86_64.  If there is something more specific you want could you tell me how to get it?
> >>>
> >>>Thanks for your help,
> >>>
> >>>Jamie
> >>>
> >>Thank you, I'm not at my home system at the moment, but I've downloaded the pcap file and will look at it in depth tonight.
> >>Neil
> >>
> >>>-----Original Message-----
> >>>From: Neil Horman [mailto:nhorman@tuxdriver.com]
> >>>Sent: 26 November 2012 20:11
> >>>To: Jamie Parsons
> >>>Cc: linux-sctp@vger.kernel.org; Peter Brittain
> >>>Subject: Re: Possible SCTP peer receive window bug
> >>>
> >>>On Mon, Nov 26, 2012 at 05:27:47PM +0000, Jamie Parsons wrote:
> >>>>Hi Neil,
> >>>>
> >>>>Could you send me your IP address so that I can give you access to an FTP server?
> >>>>
> >>>>Thanks,
> >>>>
> >>>>Jamie
> >>>>
> >>>99.127.245.201
> >>>Neil
> >>>
> >>>>-----Original Message-----
> >>>>From: Neil Horman [mailto:nhorman@tuxdriver.com]
> >>>>Sent: 26 November 2012 15:28
> >>>>To: Jamie Parsons
> >>>>Cc: linux-sctp@vger.kernel.org; Peter Brittain
> >>>>Subject: Re: Possible SCTP peer receive window bug
> >>>>
> >>>>On Mon, Nov 26, 2012 at 01:31:57PM +0000, Jamie Parsons wrote:
> >>>>>Hi,
> >>>>>
> >>>>>My name is Jamie Parsons.  I am working on a test tool that uses lksctp (lksctp-tools.x86_64 on a Linux box with a 2.6.32-279.9.1.el6.x86_64 kernel) to drive the SCTP interface on one of our products and I think I may have found a bug with the peer receive window size.
> >>>>>
> >>>>>Having looked at this kernel maintainers list (http://lxr.linux.no/#linux+v3.6.7/MAINTAINERS) I believe that you are the people I should contact to report a bug.  If not, please let me know who I should be talking to instead.
> >>>>>
> >>>>>If you are the correct people, can you please look at the detailed
> >>>>>description below?  I think that the issue may be some problem to do with data structures not being reinitialized correctly after receiving an unexpected INIT.
> >>>>>
> >>>>>I've had a quick look at recent check ins for the kernel and couldn't see anything which was obviously a fix for this bug.  Would you be able to help debugging/fixing this issue?  I'm happy to repro it to get any diagnostics required.
> >>>>>
> >>>>>Thanks for your help,
> >>>>>
> >>>>>Jamie
> >>>>>
> >>>>>=====================
> >>>>>
> >>>>>__TEST SETUP__
> >>>>>I've set up an SCTP connection between a Linux box and a fault tolerant peer.  I collect wireshark snoop from the Linux box throughout the test and periodically poll the Linux kernel for SCTP_STATUS using getsockopt() .
> >>>>>
> >>>>>After letting it run cleanly for a few minutes, I then deliberately induce a fault on the peer to make it failover.  The peer then restarts the connection by sending an INIT to the Linux box (as covered by section 5.2.2 of RFC 4960).
> >>>>>
> >>>>>__SYMPTOMS__
> >>>>>Initially, the peer is advertising a receive window of 2000 (I check this by looking at sctp.sack_a_rwnd in wireshark).  I can check that the Linux SCTP agrees with this value by doing a getsockopt for SCTP_STATUS and checking the value of sstat_rwnd.  At this stage there is no problem, the SCTP stack reports a value of 2000 with a slight deviation if there is some unacked data outstanding.  All good so far!
> >>>>>
> >>>>>After failing over, the wireshark trace still shows that the peer
> >>>>>is advertising a receive window of 2000.  However, if I now check the peer receive window through the Linux SCTP stack as above, it reports a consistently lower value (of 916 in my last run) again with slight deviation if there are unacked packets.
> >>>>>
> >>>>>At this point I stop sending any data from the Linux box, and wait a couple of minutes to ensure that the send buffer is emptied and all packets have been acked.  The last SACK sent by the peer has a receive window value of 2000 but the SCTP stack is still reporting a value of 916 with no packets unacked.
> >>>>>
> >>>>>The problem is compounded by the fact that the SCTP association now can't be brought down from the Linux side.  I have set SO_LINGER 'on' with a time of 0.  If I call shutdown(SCK, SHUT_RDWR) before a failover then I can see the Linux box send an ABORT in the wireshark trace to tear down the association.
> >>>>>
> >>>>>If I call shutdown(SCK, SHUT_RDWR) after the peer has failed over then no ABORT message is sent.  Using SCTP_STATUS on getsockopt I can see that the stack is in state 5 (PENDING_SHUTDOWN) and stays there indefinitely, which means it is waiting for packets to be acked.  This is despite the fact that it reports a value of 0 for unacked packets.
> >>>>>
> >>>>Can you provide a diagram of your network setup, a link to someplace I can see your tcpdump, and the specific kernel version that you're using?
> >>>>Neil
> >>>>
> >>>>>
> >>>>>--
> >>>>>To unsubscribe from this list: send the line "unsubscribe linux-sctp"
> >>>>>in the body of a message to majordomo@vger.kernel.org More
> >>>>>majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>>
> >>>>
> >>>
> >>
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
