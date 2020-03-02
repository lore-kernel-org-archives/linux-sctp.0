From: Harald Welte <laforge@gnumonks.org>
Date: Mon, 02 Mar 2020 13:47:43 +0000
Subject: Re: Expected SCTP DATA chunk per second performance
Message-Id: <20200302134743.GP43827@nataraja>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200302093532.GE43827@nataraja>
In-Reply-To: <20200302093532.GE43827@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Michael,

On Mon, Mar 02, 2020 at 02:28:26PM +0100, Michael Tuexen wrote:

> I consider it a bug. 

Agreed.

> Nagle normally is implemented by not sending small packets.
> From the numbers you provided, I guess the SCTP packets are about 1500 bytes. But
> I guess Linux has an MTU on the loopback interface which is much larger.

Actually, it depends on the type of sender code I use.  With Eclipse TITAN IPL4asp
(my ultimate target for writing the tests), the packets indeed are pnly 1500 bytes
in size.

When using the small C program attached, I'm seeing ~34 kByte sized IP
packets on loopback, but only at 500-510 DATA chunks per second overall
rate.

When disabling NAGLE ('client -d' of the attached program), I'm getting
much higher throughput, but there is no single IP packet with more than
a single DATA chunk inside at all anymore.  The latter is expected on
the one hand side (every syscall goes all the way to build a packet and
send it), but given at the high sender rate I would have expected that
every so often multiple DATA chunks arrive from userspace before a
packet has been sent (socket send buffer)?  In any case, no complaints
in this case.

Also interesting: With the application code (TITAN) in place, I am
seeing higher DATA chunk throughput over actual Ethernet than I'm seeing
over loopback.

I'd appreciate any feedback from the lksctp hackers here if I should
open a bugzilla issue about the poor performance with Nagle.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
======================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
