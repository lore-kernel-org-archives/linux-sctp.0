From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 22 Sep 2017 11:33:48 +0000
Subject: Re: PMTU discovery behaviour
Message-Id: <20170922113348.GA24088@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
In-Reply-To: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Sep 22, 2017 at 12:05:30PM +0300, Peter Salin wrote:
> 2017-09-21 18:24 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> > On Thu, Sep 21, 2017 at 03:41:51PM +0300, Peter Salin wrote:
> >> 2017-09-21 14:01 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> >> > On Wed, Sep 20, 2017 at 02:02:45PM +0300, Peter Salin wrote:
> >> >> 2017-09-19 20:09 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> >> >> > On Mon, Sep 11, 2017 at 03:44:57PM +0300, Peter Salin wrote:
> >> >> >> Hi,
> >> >> >>
> >> >> >> I encountered some strange PMTUD related behaviour that I need help in
> >> >> >> understanding.
> >> >> >>
> >> >> >> Setup:
> >> >> >>
> >> >> >> +-----------+        +---+        +--------+
> >> >> >> | 10.0.0.10 |--------| X |--------|10.0.0.3|
> >> >> >> +-----------+        +---+        +--------+
> >> >> >>
> >> >> >> A one to many socket is setup at 10.0.0.10. Two instances of the
> >> >> >> lksctp sctp_darn applications are ran at 10.0.0.3 listening to ports
> >> >> >> 8001 and 8002. 10.0.0.3 was also setup to generate ICMP frag needed
> >> >> >> messages for incoming messages over 600 bytes. This same issue also
> >> >> >> occurs also when a router on the path was setup to generate the ICMP
> >> >> >> message instead.
> >> >> >>
> >> >> >> Test 1:
> >> >> >> Two associations were connected from 10.0.0.10 to 10.0.0.3, one to
> >> >> >> port 8001 and another one to 8002. Then a too large message was sent
> >> >> >> on the association to 8001, triggering ICMP generation. When checking
> >> >> >> the MTU reported in spinfo_mtu field of SCTP_GET_PEER_ADDR_INFO, the
> >> >> >> association now reports 600. The association to 8002 reports 1500
> >> >> >> until traffic is sent on it, at which point it also adjusts to 600
> >> >> >> which I think makes sense since the destination IP is the same. When
> >> >> >> reopening the associations, the value of 600 would be remembered for
> >> >> >> about 10 min, which I also think makes sense since
> >> >> >> net.ipv4.route.mtu_expires is 600.
> >> >> >>
> >> >> >> Test 2:
> >> >> >> Again the same two associations were connected to 10.0.0.3, but in
> >> >> >> addition an attempt to connect a third association to a non-existing
> >> >> >> IP was done, this attempt fails with timeout after a while. After
> >> >> >> that, again an ICMP triggering large message was sent to 8001. Now the
> >> >> >> behaviour is different from before. The association to 8001 reports a
> >> >> >> spinfo_mtu of 600, but only for a brief moment, it does not stay at
> >> >> >> 600 for 10 minutes. In addition the spinfo_mtu of the association to
> >> >> >> 8002 never changes, it stays at the original 1500.
> >> >> >>
> >> >> >> The only difference between the two tests is the attempt to connect to
> >> >> >> a non-responding IP at the beginning of test 2. Any ideas why the
> >> >> >> behaviour changes, is this a bug or is there some other reason for
> >> >> >> this?
> >> >> >>
> >> >> >> I have attached the sample application used for reproducing this.
> >> >> >>
> >> >> >> BR,
> >> >> >> -Peter
> >> >> >>
> >> >> > Hey, apologies for the delay on this, I've had it in my reader for days and kept
> >> >> > meaning to respond, but kept getting sidetracked.
> >> >> >
> >> >> > First glance, this sounds incorrect.  Each association (or rather each
> >> >> > transport) maintains its own mtu, and the association reflects the mtu of the
> >> >> > active transport. Given that each transport holds its own dst cache entry, I
> >> >> > have a hard time seeing how one transports mtu changes might leak to another
> >> >> >
> >> >> > But thats not really whats happening here.  By your description, the active
> >> >> > transport on the established association isn't updating its pathmtu, which
> >> >> > should happen in response to receiving the ICMP_FRAG_NEEDED message.
> >> >> >
> >> >> > I know you've provided the reproducer bellow, and I appreciate that, but I don't
> >> >> > have the cycles to set this up at the moment.  Could you tell me if, during the
> >> >> > second test, after you attempt to connect to the fake ip address and then send
> >> >> > the large message that should trigger the frag needed message, does said large
> >> >> > message get retransmitted and eventually arrive at the peer host?  If so, that
> >> >> > suggests that the sctp stack:
> >> >> >
> >> >> > a) receives the frag needed message
> >> >> > and
> >> >> > b) resends the packet at the lower frag point
> >> >> >
> >> >> > That in turn suggests we just have some internal reporting error in which we
> >> >> > don't update the associations pmtu with the active transports
> >> >> >
> >> >> > Let me know the answer to that question and it will give me some places to start
> >> >> > looking
> >> >> > Neil
> >> >> >
> >> >> Thanks for responding. In response to your question, the first large
> >> >> message does get retransmitted without the Don't Fragment bit set. I
> >> >> modified the test a bit to also send further messages after the first
> >> >> one. Those messages are indeed fragmented according to the limit of
> >> >> the ICMP message. I have attached a PCAP trace and SCTP debug logs in
> >> >> case that helps here.
> >> >>
> >> >> I also tried sending a large message on the other association after
> >> >> the large message on the first association had been sent. For test 2
> >> >> that message was not fragmented even though the ICMP was already
> >> >> received for the first assoc. After the second assoc also received an
> >> >> ICMP it adjusted to use the lower MTU for subsequent messages. In the
> >> >> case of test 1, sending a large message on the second assoc would auto
> >> >> fragment already on the first message.
> >> >>
> >> >> Also, after stopping and rerunning test 2 the MTU would always be
> >> >> reset at 1500, whereas in test 1 the lower limit would still be in
> >> >> effect for a new run. So it seems like in test 2 the lower MTU is only
> >> >> known within each association, where as in test 1 the lower MTU also
> >> >> gets stored deeper down?
> >> >>
> >> >> BR,
> >> >> -Peter
> >> >>
> >> > So, from what I can see, your included tcpdump only shows the first part of what
> >> > you are describing.  That is to say that it sends a large data chunk on an
> >> > association that gets an ICMP frag needed response, after which the pmtu is
> >> > lowered and smaller message fragments are sent, which is good (i.e. working as
> >> > designed).
> >> >
> >> > I don't see anything in the tcpdump relating to the remainder of your test,
> >> > showing failed fragmentation.  Can you include that please?
> >> >
> >> > Neil
> >> Yes, please find attached traces that include sending on the other
> >> association after receiving the first ICMP.
> >>
> >
> >
> > Thank you.  So tell me if I'm missing something here, but I think this trace
> > contradicts what you describe above.  Some specifics:
> >
> > 1) I observe two assocations in this trace:
> >         a) An association with index 0, who's init chunk is in frame 1
> >         b) An association with index 1, whos init chunk is in frame 5
> >         Note that I can toggle between these association flows with the display
> > filter of:
> >         sctp.assoc_index = 1
> >         or
> >         sctp.assoc_index = 0
> >         in wireshark
> >
> >
> > 2) In both flows, I can observe that a large chunk is sent:
> >         a) in assoc index 0, the over-mtu chunk is in frame 9
> >         b) in assoc index 1, the over-mtu chunk is in frame 16
> >
> > 3) Subsequent to each data chunk in (2), we get an icmp unreach (frag needed
> > message)
> >         a) in assoc index 0, the icmp is in frame 10
> >         b) in assoc index 1, the icmp is in frame 17
> >
> > 4) Subsequent to (3), all DATA chunks appear to get limited to an appropriate
> > size for the path mtu as specified in the respective icmp from (3), and
> > oversized datagrams are appropriately fragmented.
> >
> >
> > Please let me know if I'm missing something, but this trace shows everything to
> > be working as normal.
> >
> > Neil
> 
> I would have expected the second ICMP to not be needed as I thought
> both assocs are on the same transport.
Oh, I'm sorry, that may be where the conflict is here.  Each association creates
its own transport objects, even if they share endpoint addresses.  Given that
the transport object holds its own unique dst entry, which is where the pmtu
value is derived from, each association needs to go through the pmtu scaling
process.  Perhaps this is where the confusion lies?

> 
> I have now attached traces for both tests so that you can compare them
> side-by-side and see what I am after here. I have run each test twice
> in the traces to be able to show the two key differences here:
> 
> 1) In test 1, the first large message sent on the second assoc (frame
> 22) is already limited correctly in size and no second ICMP is needed
> like in test 2.
> 
> (Here test 1 behaviour looked ok to me since I thought both assocs are
> on the same transport and therefore the MTU would be synced to both
> assocs. There seems to be some locally sent ICMP message in frame 16,
> perhaps this has to do with the syncing?)
> 
> 2) When rerunning test 1, the previously found out MTU value is
> remembered and no new ICMPs are needed (frame 52). This is not the
> case for test 2.
> 
> (Again here test 1 made sense to me since I thougth the MTU would be
> cached and only forgotten after 10 minutes
> (net.ipv4.route.mtu_expires).
> 
> Please note that in the test application the only difference between
> test 1 and test 2 is the attempt to connect a third assoc to a
> non-responding IP in test 2. Yet the behaviour of the stack is very
> different between the two tests.
> 
> I am new to SCTP, but to me the behaviour shown in test 1 looked more
> like what I would have expected. In any case I don't understand why
> the behaviour is so different between these two cases, so I hope we
> can find some explanation for that.
> 
Ok, I'll take a look at these later today and compare.

Neil


