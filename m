From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Mar 2020 03:22:52 +0000
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200326032252.GI3756@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200322090425.6253-1-hqjagain@gmail.com>
 <20200326001416.GH3756@localhost.localdomain>
 <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com>
In-Reply-To: <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiujun Huang <hqjagain@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Thu, Mar 26, 2020 at 09:30:08AM +0800, Qiujun Huang wrote:
> On Thu, Mar 26, 2020 at 8:14 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> > > sctp_sock_migrate should iterate over the datamsgs to modify
> > > all trunks(skbs) to newsk. For this, out_msg_list is added to
> >
> > s/trunks/chunks/
> 
> My :p.
> 
> >
> > > sctp_outq to maintain datamsgs list.
> >
> > It is an interesting approach. It speeds up the migration, yes, but it
> > will also use more memory per datamsg, for an operation that, when
> > performed, the socket is usually calm.
> >
> > It's also another list to be handled, and I'm not seeing the patch
> > here move the datamsg itself now to the new outq. It would need
> > something along these lines:
> 
> Are all the rx chunks in the rx queues?

Yes, even with GSO.

> 
> > sctp_sock_migrate()
> > {
> > ...
> >         /* Move any messages in the old socket's receive queue that are for the
> >          * peeled off association to the new socket's receive queue.
> >          */
> >         sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
> >                 event = sctp_skb2event(skb);
> > ...
> >                 /* Walk through the pd_lobby, looking for skbs that
> >                  * need moved to the new socket.
> >                  */
> >                 sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
> >                         event = sctp_skb2event(skb);
> >
> > That said, I don't think it's worth this new list.
> 
> About this case:
> datamsg
>                    ->chunk0                       chunk1
>        chunk2
>  queue          ->transmitted                 ->retransmit
>  ->not in any queue

We always can find it through the other chunks, otherwise it's freed.

> 
> Also need to maintain a datamsg list to record which datamsg is
> processed avoiding repetitive
> processing.

Right, but for that we can add a simple check on
sctp_for_each_tx_datamsg() based on a parameter.

> So, list it to outq. Maybe it will be used sometime.

We can change it when the time comes. For now, if we can avoid growing
sctp_datamsg, it's better. With this patch, it grows from 40 to 56
bytes, leaving just 8 left before it starts using a slab of 128 bytes
for it.


The patched list_for_each_entry() can/should be factored out into
__sctp_for_each_tx_datachunk, whose first parameter then is the queue
instead the asoc.

---8<---

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fed26a1e9518..62f401799709 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -148,19 +148,30 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 }
 
 static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
+				       bool clear,
 				       void (*cb)(struct sctp_chunk *))
 
 {
+	struct sctp_datamsg *msg, *prev_msg = NULL;
 	struct sctp_outq *q = &asoc->outqueue;
+	struct sctp_chunk *chunk, *c;
 	struct sctp_transport *t;
-	struct sctp_chunk *chunk;
 
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
 			cb(chunk);
 
-	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
-		cb(chunk);
+	list_for_each_entry(chunk, &q->sacked, transmitted_list) {
+		msg = chunk->msg;
+		if (msg = prev_msg)
+			continue;
+		list_for_each_entry(c, &msg->chunks, frag_list) {
+			if ((clear && asoc->base.sk = c->skb->sk) ||
+			    (!clear && asoc->base.sk != c->skb->sk))
+				cb(c);
+		}
+		prev_msg = msg;
+	}
 
 	list_for_each_entry(chunk, &q->sacked, transmitted_list)
 		cb(chunk);
@@ -9574,9 +9585,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * paths won't try to lock it and then oldsk.
 	 */
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
-	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
+	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
