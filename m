From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 06 Jun 2016 20:16:46 +0000
Subject: re: sctp: Add GSO support
Message-Id: <20160606201646.GA5425@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello Marcelo Ricardo Leitner,

This is a semi-automatic email about new static checker warnings.

The patch 90017accff61: "sctp: Add GSO support" from Jun 2, 2016, 
leads to the following Smatch complaint:

net/sctp/output.c:122 sctp_packet_config()
	 error: we previously assumed 'asoc' could be null (see line 94)

net/sctp/output.c
    93	
    94		if (asoc && tp->dst) {
                    ^^^^
New test.

    95			struct sock *sk = asoc->base.sk;
    96	
    97			rcu_read_lock();
    98			if (__sk_dst_get(sk) != tp->dst) {
    99				dst_hold(tp->dst);
   100				sk_setup_caps(sk, tp->dst);
   101			}
   102	
   103			if (sk_can_gso(sk)) {
   104				struct net_device *dev = tp->dst->dev;
   105	
   106				packet->max_size = dev->gso_max_size;
   107			} else {
   108				packet->max_size = asoc->pathmtu;
   109			}
   110			rcu_read_unlock();
   111	
   112		} else {
   113			packet->max_size = tp->pathmtu;
   114		}
   115	
   116		if (ecn_capable && sctp_packet_empty(packet)) {
   117			struct sctp_chunk *chunk;
   118	
   119			/* If there a is a prepend chunk stick it on the list before
   120			 * any other chunks get appended.
   121			 */
   122			chunk = sctp_get_ecne_prepend(asoc);
                                                      ^^^^
New unchecked dereference.  It's possible that maybe checking
ecn_capable and sctp_packet_empty() implies that "asoc" is non-NULL but
it's not obvious from a glance.  Anyway, just let me know if that's the
case.

   123			if (chunk)
   124				sctp_packet_append_chunk(packet, chunk);

regards,
dan carpenter
