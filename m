From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 06 Jun 2016 20:42:38 +0000
Subject: Re: sctp: Add GSO support
Message-Id: <20160606204237.GC32247@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160606201646.GA5425@mwanda>
In-Reply-To: <20160606201646.GA5425@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

It's fairly tricky to follow actually.  Here is one caller:

net/sctp/outqueue.c
   706  static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
   707  {
   708          struct sctp_packet *packet;
   709          struct sctp_packet singleton;
   710          struct sctp_association *asoc = q->asoc;
                                         ^^^^^^^^^^^^^^
asoc is set here.

   711          __u16 sport = asoc->base.bind_addr.port;
   712          __u16 dport = asoc->peer.port;
   713          __u32 vtag = asoc->peer.i.init_tag;
   714          struct sctp_transport *transport = NULL;
   715          struct sctp_transport *new_transport;
   716          struct sctp_chunk *chunk, *tmp;
   717          sctp_xmit_t status;

[ snip ]

   800  
   801                  /* Are we switching transports?
   802                   * Take care of transport locks.
   803                   */
   804                  if (new_transport != transport) {
   805                          transport = new_transport;
   806                          if (list_empty(&transport->send_ready)) {
   807                                  list_add_tail(&transport->send_ready,
   808                                                &transport_list);
   809                          }
   810                          packet = &transport->packet;
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
packet is set here.  How do we know that "packect->transport->asoc" and
"asoc" are the same?  It's complicated.

   811                          sctp_packet_config(packet, vtag,
   812                                             asoc->peer.ecn_capable);
   813                  }

Anyway, maybe eventually we'll figure out a way to make it work but even
just reading it manually is quite complicated....

For now, just ignore the false postive.

regards,
dan carpenter

