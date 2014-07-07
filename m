From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 07 Jul 2014 11:41:32 +0000
Subject: Re: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <20140707114132.GA30021@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140628190435.AF72.327CAA51@tspi.com.ph>
In-Reply-To: <20140628190435.AF72.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 04, 2014 at 06:33:32PM +0800, Winston V. Tizon wrote:
> On Tue, 1 Jul 2014 07:20:01 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> > Actually, its quite the opposite, this confirms that the sctp protocol is
> > functioning normally.  RFC 4960 says this about HB_ACK's:
> > 
> > 3.3.6.  Heartbeat Acknowledgement (HEARTBEAT ACK) (5)
> > 
> >    An endpoint should send this chunk to its peer endpoint as a response
> >    to a HEARTBEAT chunk (see Section 8.3).  A HEARTBEAT ACK is always
> >    sent to the source IP address of the IP datagram containing the
> >    HEARTBEAT chunk to which this ack is responding.
> > 
> > The only thing that a peer has to do regarding a HB frame is sent an HB_ACK to
> > the source ip address of the corresponding HB frame (in this case172.168.39.4),
> > which we do my recording the inbound transport that the HB frame arrived on.
> > The source address selection is made during L3 packet routing, which, according
> > to sctp_transport_route is made by querying the route tables.
> > 
> > The only thing thats a bit odd is the fact your not taking what is likely the
> > selected source address from the default route.  That usually indicates that
> > you're using path mtu features, and you're routing based on a locally selected
> > source and destination address.
> > 
> > The point however is, that a transport is only defined by a destination address
> > within an association, not by a source and a destination, the source address
> > selection is made by the local peer, and should not be relevant to the peer
> > receiving the data.
> > 
> > Neil
> > 
> TO: Neil, Daniel, Michael
> 
> Thank you very much for your answers. I misunderstood the SCTP RFC statement 
> regarding reply Chunks in a multi-homed association. I thought reply 
> chunks should be sent always to the same path from where DATA or Control 
> chunks were received.
> 
> I'm sorry if I haven't explained yet the other details of our problem using 
> the following  "Environment Setup" below.
> 
This is a bit of a strange setup.  Multiple subnets on the same L2 switch
without vlans can lead to strange behaviors.  Its also a bit strange that you
have a single interface with what must be multiple ip addresses on each of two
router interfaces.

>     CLIENT                        SERVER     
>  172.168.39.91                172.168.40.93  
>  +-----------+    +------+    +-----------+  
>  |       eth0|----|  L2  |----|eth0       |  
>  |           |    +------+    |           |  
>  |           |       |        |           |  
>  |           |  +----------+  |           |  
>  |           |  |    L3    |  |           |  
>  |           |  +----------+  |           |  
>  |           |       |        |           |  
>  |           |    +------+    |           |  
>  |       eth1|----|  L2  |----|eth1       |  
>  +-----------+    +------+    +-----------+  
>  172.168.39.92                172.168.40.94  
> 
> Our problem goes like this. Normal sequence is shown in "[NORMAL]" sequence.
> While our problem started when we've performed "[ABNORMAL]"sequence below.
> 
> [NORMAL]
> 
>       SERVER           L2 and L3         CLIENT      
> Secondary Primary           |      Primary Secondary 
>     |        |              |          |       |     
>     |        |              |          |       |     
>     |        |INIT-INIT_ACK |          |       |     
>     |        |<-------------|--------->|       |     
>     |        |COOKIE_ECHO-COOKIE_ACK   |       |     
>     |        |              |          |       |     
>     |        |<-------------|--------->|       |     
>     |        |HB/HB_ACK     |          |       |     
>     |        |              |          |       |     
>     |<-------|--------------|----------|       |     
>     |        |              |       HB |       |     
>     |        |--------------|--------->|       |     
>     |        |HB_ACK        |          |       |     
>     |        |        :     |          |       |     
>     |        |        :     |          |       |     
> 
> [ABNORMAL]
> 
>       SERVER           L2 and L3         CLIENT
> Secondary Primary           |      Primary Secondary 
>     |        |              |          |       |     
>     |        |              |          |       |     
>     |        |INIT-INIT_ACK |          |       |     
>     |        |<-------------|--------->|       |     
>     |        |COOKIE_ECHO-COOKIE_ACK   |       |     
>     |        |              |          |       |     
>     |        |<-------------|--------->|       |     
>     |        |HB/HB_ACK     |          |       |     
>     |        |              |          |       |     
>     |<-------|--------------|----------|       |     
>     |        |              |       HB |       |     
>     |        |---->X        |          |       |     
>     |        |HB_ACK        |          |       |     
>     |        |        :     |          |       |     
>     |<-------|--------------|----------|       |     
>                   ABORT
>     
> X  -> LAN cable unplug, cannot send HB_ACK to Client
> 

Exctly what cable was it that got unplugged here?  In your configuration above,
if the primary ip cable got pulled, then the server system would have updated
its route table and the secondary ip address would get used.  If the link to the
router of the client got pulled though, theres no real hope here.  Also, what
inspired the ABORT here?  I presume the timer ran out on the client and it sent
an ABORT because it didn't receive the HBACK in a timely fashion?

> Based on what happened in our environment, the Client sent ABORT chunk to 
> Secondary IP address of Server causing this path to be closed. 
> 
> We don't want this to happen in our environment.
> 
> It would be of great help to us if you have any idea on how we could 
> solve question #3 below.
> 
> [Question]
> 3. Is there a solution to force Server to use its Secondary path in 
>    sending the HEARTBEAT_ACK chunk to Client's primary?   
> 
Yes, but its the same solution that all SCTP traffic uses, which is to say that
it relies on the routing tables.  If the primary interface on the sending host
goes down, then the route table will expire all routes associated with that
path, and sctp will pick a new one (the mechanics are that
sctp_transport_dst_check will fail, another routing table lookup will occur, and
a route will be cloned that contains the secondary address as the saddr
variable).  That said, if you're not pulling the interface cable (i.e. if you're
pulling the cable to the router, or the client system), then the server has no
way to know that the route using the primary source is unreachable, and will
continue to use it.

SCTP is fault tolerant over multiple network paths, but that comes with the
limitation that SCTP needs to be aware of path failures in a timely fashion.
You're setup doesn't really allow for that.

I would suggest one of two things:

1) Convert your setup to have each client and server interface be on a separate
subnet.  That way the client and server primary addresses are reachable via L2
only, as are the secondary addresses.  This will make path failure easier to
detect.

2) Use the bonding driver to do failover between your interfacs.  That gives you
a single path, but the failover detection is handled at L2 rather than L3, which
is faster and more reliable for local failures like link drops (and can be made
more robust with ip monitoring).  If you want L3 failover capabilities, then I
sugggest looking into the possibility of vrrp on your router.

Neil

> 
> 
