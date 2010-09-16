From: Thomas Dreibholz <dreibh@iem.uni-due.de>
Date: Thu, 16 Sep 2010 10:43:06 +0000
Subject: Re: [PATCH] net: SCTP remote/local Denial of Service vulnerability description and fix
Message-Id: <201009161243.10710.dreibh@iem.uni-due.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <201009151001.59860.dreibh@iem.uni-due.de> <4C90D1E8.7000404@hp.com>
In-Reply-To: <4C90D1E8.7000404@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Martin Becke <martin.becke@uni-due.de>

On Mittwoch 15 September 2010, Vlad Yasevich wrote:
> On 09/15/2010 04:01 AM, Thomas Dreibholz wrote:
> > sctp_outq_flush() in net/sctp/outqueue.c may call sctp_packet_reset() on
> > a packet structure which has already been filled with chunks.
> > sctp_packet_reset() will not take care of the chunks in its list and
> > only reset the packet length. After that, the SCTP code assumes the
> > packet to be re-initialized and adds further chunks to the structure.
> > The length will be wrong. When actually trying to transmit the packet,
> > the packet sk_buff structure may be exceeded within
> > sctp_packet_transmit(), resulting in skb_over_panic() =3D> denial of
> > service.
> >=20
> > Such a DoS can be triggered by a malicious remote SCTP instance, as
> > follows: - The remote endpoint has to use two paths (i.e. 2 IP
> > addresses); easy to achieve using an IPv4 address and an IPv6 address ->
> > path A and B. - The remote user has to trigger the transmission of a
> > HEARTBEAT_ACK on path A. This is trivial, by sending a HEARTBEAT chunk.
> > sctp_outq_flush() will call sctp_packet_config() for the packet on path
> > A. The HEARTBEAT_ACK will be added to this packet.
> > - The remote user has to trigger a DATA chunk retransmission on path B.
> > This is trivial, since it only has to send appropriate SACK chunks.
> > sctp_outq_flush() notices that the retransmission is on a different path
> > and calls sctp_packet_config() for the packet on path B. The DATA chunk
> > to be retransmitted is added to this packet.
> > - The local instance has to send another DATA chunk on path A. This
> > depends on the application, but should be easy to trigger from a remote
> > instance. sctp_outq_flush() notices that the path has changed again, and
> > calls sctp_packet_config() for the packet on path A. This resets the
> > size of the HEARTBEAT_ACK chunk, but the chunk remains in the packet. If
> > size(HEARTBEAT_ACK) + size(DATA) > MTU - overhead, the next call to
> > sctp_packet_transmit() causes the kernel panic =3D> DoS.
> > In a similar way, the problem can also be triggered by a local user,
> > having only the permission to establish SCTP associations. Of course,
> > the problem can also occur during normal network operation, just by a
> > retransmission at the wrong time.
> >=20
> > The patch below against 2.6.36-rc4 (git repository) fixes
> > sctp_outq_flush() by ensuring that the packet on each path is
> > initialized only once. Furthermore, a BUG_ON() statement ensures that
> > further problems by calling
> > sctp_packet_reset() on packets with chunks are detected directly.
>=20
> Actually I have a much easier solution.  When calling packet_config, we
> should not be resetting the packet contents.
>=20
> Packet contents need to be reset when a new packet is created or when the
> packet has been sent.  We explicitly reset it after sending in
> sctp_packet_transmit.  We also reset it in sctp_packet_init().  So, code
> such as:
> 	sctp_packet_init()
> 	sctp_packet_config()
>=20
> already guarantees that at config time we have a clear packet.
>=20
> So, simply removing a reset call from sctp_packet_config() solves this

Great! It works fine.

I hope this bugfix will go into the main tree soon, in order to get the=20
distribution kernels fixed.


Best regards
--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Dr. Thomas Dreibholz

 University of Duisburg-Essen,                   Room ES210
 Inst. for Experimental Mathematics              Ellernstra=DFe 29
 Computer Networking Technology Group            D-45326 Essen/Germany
-----------------------------------------------------------------------
 E-Mail:     dreibh@iem.uni-due.de
 Homepage:   http://www.iem.uni-due.de/~dreibh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D