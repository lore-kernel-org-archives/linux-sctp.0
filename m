From: Peter Salin <peter.salin@gmail.com>
Date: Tue, 19 Sep 2017 12:14:12 +0000
Subject: Re: PMTU discovery behaviour
Message-Id: <CAH9vUQu3p4p6w98=jDVff0CqnywPMCrWAZf8Ygh7-8YRgr_ogg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
In-Reply-To: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

2017-09-11 15:41 GMT+03:00 Peter Salin <peter.salin@gmail.com>:
> Hi,
>
> I encountered some strange PMTUD related behaviour that I need help in
> understanding.
>
> Setup:
>
> +-----------+        +---+        +--------+
> | 10.0.0.10 |--------| X |--------|10.0.0.3|
> +-----------+        +---+        +--------+
>
> A one to many socket is setup at 10.0.0.10. Two instances of the lksctp
> sctp_darn applications are ran at 10.0.0.3 listening to ports 8001 and 8002.
> 10.0.0.3 was also setup to generate ICMP frag needed messages for incoming
> messages over 600 bytes. This same issue also occurs also when a router on
> the path was setup to generate the ICMP message instead.
>
> Test 1:
> Two associations were connected from 10.0.0.10 to 10.0.0.3, one to port 8001
> and another one to 8002. Then a too large message was sent on the
> association to 8001, triggering ICMP generation. When checking the MTU
> reported in spinfo_mtu field of SCTP_GET_PEER_ADDR_INFO, the association now
> reports 600. The association to 8002 reports 1500 until traffic is sent on
> it, at which point it also adjusts to 600 which I think makes sense since
> the destination IP is the same. When reopening the associations, the value
> of 600 would be remembered for about 10 min, which I also think makes sense
> since net.ipv4.route.mtu_expires is 600.
>
> Test 2:
> Again the same two associations were connected to 10.0.0.3, but in addition
> an attempt to connect a third association to a non-existing IP was done,
> this attempt fails with timeout after a while. After that, again an ICMP
> triggering large message was sent to 8001. Now the behaviour is different
> from before. The association to 8001 reports a spinfo_mtu of 600, but only
> for a brief moment, it does not stay at 600 for 10 minutes. In addition the
> spinfo_mtu of the association to 8002 never changes, it stays at the
> original 1500.
>
> The only difference between the two tests is the attempt to connect to a
> non-responding IP at the beginning of test 2. Any ideas why the behaviour
> changes, is this a bug or is there some other reason for this?
>
> I have attached the sample application used for reproducing this.

Hi,

Any input on this? Is this the right forum for this?

BR,
-Peter
