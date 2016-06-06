From: marcelo.leitner@gmail.com
Date: Mon, 06 Jun 2016 20:26:49 +0000
Subject: Re: sctp: Add GSO support
Message-Id: <20160606202649.GE22680@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160606201646.GA5425@mwanda>
In-Reply-To: <20160606201646.GA5425@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Dan,

On Mon, Jun 06, 2016 at 11:16:46PM +0300, Dan Carpenter wrote:
> Hello Marcelo Ricardo Leitner,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 90017accff61: "sctp: Add GSO support" from Jun 2, 2016, 
> leads to the following Smatch complaint:
> 
> net/sctp/output.c:122 sctp_packet_config()
> 	 error: we previously assumed 'asoc' could be null (see line 94)
> 
> net/sctp/output.c
>     93	
>     94		if (asoc && tp->dst) {
>                     ^^^^
> New test.
> 
>     95			struct sock *sk = asoc->base.sk;
>     96	
>     97			rcu_read_lock();
>     98			if (__sk_dst_get(sk) != tp->dst) {
>     99				dst_hold(tp->dst);
>    100				sk_setup_caps(sk, tp->dst);
>    101			}
>    102	
>    103			if (sk_can_gso(sk)) {
>    104				struct net_device *dev = tp->dst->dev;
>    105	
>    106				packet->max_size = dev->gso_max_size;
>    107			} else {
>    108				packet->max_size = asoc->pathmtu;
>    109			}
>    110			rcu_read_unlock();
>    111	
>    112		} else {
>    113			packet->max_size = tp->pathmtu;
>    114		}
>    115	
>    116		if (ecn_capable && sctp_packet_empty(packet)) {
>    117			struct sctp_chunk *chunk;
>    118	
>    119			/* If there a is a prepend chunk stick it on the list before
>    120			 * any other chunks get appended.
>    121			 */
>    122			chunk = sctp_get_ecne_prepend(asoc);
>                                                       ^^^^
> New unchecked dereference.  It's possible that maybe checking
> ecn_capable and sctp_packet_empty() implies that "asoc" is non-NULL but
> it's not obvious from a glance.  Anyway, just let me know if that's the
> case.
> 
>    123			if (chunk)
>    124				sctp_packet_append_chunk(packet, chunk);
> 

Thanks for the report.

It's a false-positive, I think. Is there a way that we can avoid the
warning without changing the code? I could add a check in there, like
'if (ecn_capable && asoc && ..' just to clear this but wouldn't like to
do it.

False-positive because ecn_capable cannot be true without an asoc, so
checking ecn_capable is enough to know that asoc is there too, as in:

$ git grep -A 1 sctp_packet_config
output.c:void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
output.c-                       int ecn_capable)
--
outqueue.c:                     sctp_packet_config(packet, vtag,
outqueue.c-
asoc->peer.ecn_capable);
--
outqueue.c:                     sctp_packet_config(&singleton, vtag, 0);
outqueue.c-                     sctp_packet_append_chunk(&singleton,
chunk);
--
outqueue.c:                     sctp_packet_config(packet, vtag,
outqueue.c-
asoc->peer.ecn_capable);
--
outqueue.c:                             sctp_packet_config(packet, vtag,
outqueue.c-
asoc->peer.ecn_capable);
--
sm_statefuns.c: sctp_packet_config(packet, vtag, 0);
sm_statefuns.c-

and in all these cases, asoc was verified already. Unless the tool can
do such check across the call stack and I missed something in it..

Regards,
Marcelo
