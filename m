From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 01 Aug 2013 11:48:59 +0000
Subject: Re: Association issue.
Message-Id: <20130801114859.GA5589@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
In-Reply-To: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Aug 01, 2013 at 03:52:50PM +0530, Vipul Singhania wrote:
> On Wed, Jul 31, 2013 at 6:41 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Wed, Jul 31, 2013 at 10:33:50AM +0530, Vipul Singhania wrote:
> >> Thanks for reply.
> >>
> >> There is no firewall in that network. This is just separate network.
> >> and I can say they are directly connected to each other using L1
> >> switch and no other connection to outside world.
> >>
> >> It was jut testing that I have giving public IP to one of interface in one host.
> >>
> >> - The association look like with public IP.
> >>
> >> sh-3.2# cat /proc/net/sctp/assocs
> >>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> >> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
> >> ffff8800089b0000 ffff8800335944c0 2   1   3  37916    3      516
> >>  0       0 10635 48520  7168  127.3.253.1 127.3.21.1 127.4.253.1
> >> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
> >>  7500   300   300   10    0    0        0
> >> ffff8800089b2000 ffff880033594000 2   1   3  50717    4      516
> >>  0       0 10634 60890  7169  127.3.253.1 127.3.21.1 127.4.253.1
> >> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
> >>  7500   300   300   10    0    0        0
> >>
> >> -----------------------------------------------------------------------------
> >> - But if I give private IP (10.1.1.1) this look like.
> >>
> >> sh-3.2# cat /proc/net/sctp/assocs
> >>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> >> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
> >> ffff88003c721800 ffff8800335944c0 2   1   3  22045    2        0
> >>  0       0  5674 47434  7169  127.3.253.1 127.3.21.1 127.4.253.1
> >> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
> >>    0    0        0
> >> ffff88003c720800 ffff880033594000 2   1   3  36124    1        0
> >>  0       0  5673 58513  7168  127.3.253.1 127.3.21.1 127.4.253.1
> >> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
> >>    0    0        0
> >>
> > I don't see any difference between the two environments here.  How exactly are
> > you 'giving' a private ip here?  Are you attempting an ADDIP operation?
> >
> 
> [Vipul] -- The difference which I can is the public IP 164.48.1.1 is
> there in association list. (Why & how this case in this list this I am
> not able to understand). however If I assign the IP 10.1.1.1/24 to my
> eth0 it doesn't come in this association.
> The IP address assignment is using ifconfig.
> 
Ok, so all your doing is specifying it on the interface, you're not explicitly
binding to it in whatever program you have.

> >>
> >> - I may be wrong but is it possible that when we do bind with on IP
> >> (and if multi homing is enabled) it'll build with all available
> >> interfaces?
> >>
> > The opposite in fact.  If you bind to a local address the association on that
> > socket will be creating using only the bound address, if you do not bind on a
> > local address (the autobind case), and multihoming is enabled, then all
> > available addresses will be used.
> >
> [Vipul] -- If this is the case one host is working as server and I am
> doing bind on that for IP 127.4.252.1 and the other host is always
> acting as client and in this I just do connect().
> So Client will bind with all IP addresses, in this case I am not clear
> why & how private IP is not coming for the accociation and why public
> IP is coming in this association?
Can you post the code that you are using to set up this connection?

> I have also tries with "echo "2" >
> /proc/sys/net/sctp/addr_scope_policy" which even doesn't allow the
> association with private IP. for both (private & public IP) the server
> receiver end receives the connection reset by peer.
> 
Can you provide a tcpdump of this as well?
Neil


> > Neil
> >
> 
> 
> -- 
> -=vipsy
> http://through-dlens.blogspot.in
> 
