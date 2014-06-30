From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 30 Jun 2014 12:30:20 +0000
Subject: Re: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <20140630123020.GA15777@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140628190435.AF72.327CAA51@tspi.com.ph>
In-Reply-To: <20140628190435.AF72.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jun 30, 2014 at 04:58:36PM +0800, Winston V. Tizon wrote:
> TO: Mr. Borkmann
> 
> Good day!
> 
> Thank you very much for your quick reply.
> 
> I need to confirm if your environment there with
> 2 machines with 5 interfaces each have the same RHEL and
> LKSCTP versions with the ones we are using?
> 
> If you are using the latest RHEL and LKSCTP versions
> and HB-ACKS are doing fine there, we might think that 
> our older LKSCTP version has something to do with the 
> abnormal HB-ACK behavior.
> 
> Thanks,
> 
> W. Tizon
> 
How are you determining which transport is getting used to send the HEARTBEAT
ACK?  Are you looking at the chunks destination IP address?  Looking at
sctp_outq_flush in RHEL6 it appears we should always use the inbound transport
to send the response, which is the correct thing to do. Sometimes however, while
the destination ip address is correct, funny routing tables can lead to a single
source address getting selected.

Neil

> On Mon, 30 Jun 2014 10:24:09 +0200
> Daniel Borkmann <dborkman@redhat.com> wrote:
> 
> > On 06/28/2014 01:04 PM, Winston V. Tizon wrote:
> > > Hello everyone!
> > >
> > > We are having some issues regarding SCTP multihoming
> > > and we would like to ask your opinion on this matter.
> > > We have two RHEL6.4 (2.6.32-358.el6.x86_64, lksctp-tools
> > > -1.0.10-5(64 bit)) machines connected by two L2 switch
> > > and a L3 switch (please see "Environment Setup" below).
> > > When we execute SCTP connection (using multihoming) between
> > > the two machines, the following behavior occurred:
> > >
> > >        CLIENT           L2 and L3         SERVER
> > > Secondary Primary           |      Primary Secondary
> > >      |        |              |          |       |
> > >      |        |              |          |       |
> > >      |        |INIT-INIT_ACK |          |       |
> > >      |        |<-------------|--------->|       |
> > >      |        |COOKIE_ECHO-COOKIE_ACK   |       |
> > >      |        |              |          |       |
> > >      |        |<-------------|--------->|       |
> > >      |        |HB/HB_ACK     |          |       |
> > >      |        |              |          |       |
> > >      |<-------|--------------|----------|       |
> > >      |        |              |       HB |       |
> > >      |        |--------------|--------->|       |
> > >      |        |HB_ACK        |          |       |
> > >      |        |        :     |          |       |
> > >      |        |        :     |          |       |
> > >
> > > INIT/INIT_ACK handshake occurred in the primary
> > > path of both machines which is expected. When a
> > > Primary path sends HEARTBEAT to another Primary,
> > > HEARTBEAT_ACK was returned to the sender. But
> > > when a Primary path sends HEARTBEAT to a
> > > Secondary path, the HEARTBEAT_ACK chunk was sent
> > > by the Primary path. We expect that the
> > > HEARTBEAT_ACK would come from the Secondary.
> > >
> > > [Questions]
> > > 1. Is this a normal behavior with regards to SCTP multihoming?
> > 
> > So looking at the RFC, it says (RFC4960, 3.3.6. + 6.4.) ...
> > 
> >   An endpoint should send this chunk to its peer endpoint as a
> >   response to a HEARTBEAT chunk (see Section 8.3). A HEARTBEAT ACK
> >   is always sent to the source IP address of the IP datagram
> >   containing the HEARTBEAT chunk to which this ack is responding.
> > 
> >   [...]
> > 
> >   An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
> >   etc.) to the same destination transport address from which it
> >   received the DATA or control chunk to which it is replying. This
> >   rule should also be followed if the endpoint is bundling DATA chunks
> >   together with the reply chunk.
> > 
> > ... it would be more correct to reply via the same transport, imho.
> > I just checked upstream kernel with multihoming on 2 machines with
> > 5 interfaces each, and HB, HB-ACK replies seem to be fine there,
> > that is, HB-ACKs go via same transports.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
