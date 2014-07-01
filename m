From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 01 Jul 2014 11:20:01 +0000
Subject: Re: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <20140701112001.GA7322@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140628190435.AF72.327CAA51@tspi.com.ph>
In-Reply-To: <20140628190435.AF72.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jul 01, 2014 at 03:48:32PM +0800, Winston V. Tizon wrote:
> On Mon, 30 Jun 2014 08:30:20 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > How are you determining which transport is getting used to send the HEARTBEAT
> > ACK?  Are you looking at the chunks destination IP address?  Looking at
> > sctp_outq_flush in RHEL6 it appears we should always use the inbound transport
> > to send the response, which is the correct thing to do. Sometimes however, while
> > the destination ip address is correct, funny routing tables can lead to a single
> > source address getting selected.
> > 
> > Neil
> 
> Thanks for the reply Neil.
> 
> We've just performed test to check if Multihoming Heartbeat ACK Behavior 
> I've mentioned is related to routing table configuration or 
> SCTP Primary IP address setting. Please see below test information and results.
> 
> "Test case1" (Set the primary in "172.168.39.2")
> 
> [client]
> # sctp_darn -H 172.168.39.2 -B 172.168.39.3 -P 9099 -h 172.168.39.4 -p 
> 9099 -s
> 
> [server]
> # sctp_darn -H 172.168.39.4 -B 172.168.39.5 -P 9099 -l
> 
> [result]
> 172.168.39.2(client) 172.168.39.4(server) INIT
> 172.168.39.4(server) 172.168.39.2(client) INIT_ACK
> 172.168.39.2(client) 172.168.39.4(server) COOKIE_ECHO
> 172.168.39.4(server) 172.168.39.2(client) COOKIE_ACK
> 172.168.39.4(server) 172.168.39.2(client) HB
> 172.168.39.2(client) 172.168.39.4(server) HB_ACK
> 172.168.39.4(server) 172.168.39.3(client) HB
> 172.168.39.2(client) 172.168.39.4(server) HB_ACK     (***)
> 172.168.39.2(client) 172.168.39.4(server) DATA
> 172.168.39.4(server) 172.168.39.2(client) SACK
> 
> 
> "Test case2" (Set the primary in "172.168.39.3")
> 
> [client]
> # sctp_darn -H 172.168.39.3 -B 172.168.39.2 -P 9099 -h 172.168.39.4 -p 
> 9099 -s
> 
> [server]
> # sctp_darn -H 172.168.39.4 -B 172.168.39.5 -P 9099 -l
> 
> [result]
> 172.168.39.3(client) 172.168.39.4(server) INIT
> 172.168.39.4(server) 172.168.39.3(client) INIT_ACK
> 172.168.39.3(client) 172.168.39.4(server) COOKIE_ECHO
> 172.168.39.4(server) 172.168.39.3(client) COOKIE_ACK
> 172.168.39.4(server) 172.168.39.3(client) HB
> 172.168.39.3(client) 172.168.39.4(server) HB_ACK
> 172.168.39.4(server) 172.168.39.2(client) HB
> 172.168.39.3(client) 172.168.39.4(server) HB_ACK     (***)
> 172.168.39.3(client) 172.168.39.4(server) DATA 
> 172.168.39.4(server) 172.168.39.3(client) SACK
> 
> 
> Based on results, SCTP kernel always choose Primary IP address so I think
> this is not related to routing table configuration problems. 
> 
> (***) -> Based on SCTP RFC4960, expected behavior is secondary IP address
>          should be used as path in sending the HB_ACK.
> 
Actually, its quite the opposite, this confirms that the sctp protocol is
functioning normally.  RFC 4960 says this about HB_ACK's:

3.3.6.  Heartbeat Acknowledgement (HEARTBEAT ACK) (5)

   An endpoint should send this chunk to its peer endpoint as a response
   to a HEARTBEAT chunk (see Section 8.3).  A HEARTBEAT ACK is always
   sent to the source IP address of the IP datagram containing the
   HEARTBEAT chunk to which this ack is responding.

The only thing that a peer has to do regarding a HB frame is sent an HB_ACK to
the source ip address of the corresponding HB frame (in this case172.168.39.4),
which we do my recording the inbound transport that the HB frame arrived on.
The source address selection is made during L3 packet routing, which, according
to sctp_transport_route is made by querying the route tables.

The only thing thats a bit odd is the fact your not taking what is likely the
selected source address from the default route.  That usually indicates that
you're using path mtu features, and you're routing based on a locally selected
source and destination address.

The point however is, that a transport is only defined by a destination address
within an association, not by a source and a destination, the source address
selection is made by the local peer, and should not be relevant to the peer
receiving the data.

Neil

