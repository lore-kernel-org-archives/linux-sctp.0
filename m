From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 21 Mar 2020 01:02:46 +0000
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200321010246.GC3828@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200320110959.2114-1-hqjagain@gmail.com>
 <20200320185204.GB3828@localhost.localdomain>
 <CAJRQjoc-U_K-2THbmBOj2TOWDTfP9yr5Vec-WjhTjS8sj19fHA@mail.gmail.com>
In-Reply-To: <CAJRQjoc-U_K-2THbmBOj2TOWDTfP9yr5Vec-WjhTjS8sj19fHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiujun Huang <hqjagain@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Sat, Mar 21, 2020 at 07:53:29AM +0800, Qiujun Huang wrote:
...
> > > So, sctp_wfree was not called to destroy SKB)
> > >
> > > then migrate happened
> > >
> > >       sctp_for_each_tx_datachunk(
> > >       sctp_clear_owner_w);
> > >       sctp_assoc_migrate();
> > >       sctp_for_each_tx_datachunk(
> > >       sctp_set_owner_w);
> > > SKB was not in the outq, and was not changed to newsk
> >
> > The real fix is to fix the migration to the new socket, though the
> > situation on which it is happening is still not clear.
> >
> > The 2nd sendto() call on the reproducer is sending 212992 bytes on a
> > single call. That's usually the whole sndbuf size, and will cause
> > fragmentation to happen. That means the datamsg will contain several
> > skbs. But still, the sacked chunks should be freed if needed while the
> > remaining ones will be left on the queues that they are.
> 
> in sctp_sendmsg_to_asoc
> datamsg holds his chunk result in that the sacked chunks can't be freed

Right! Now I see it, thanks.
In the end, it's not a locking race condition. It's just not iterating
on the lists properly.

> 
> list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
> sctp_chunk_hold(chunk);
> sctp_set_owner_w(chunk);
> chunk->transport = transport;
> }
> 
> any ideas to handle it?

sctp_for_each_tx_datachunk() needs to be aware of this situation.
Instead of iterating directly/only over the chunk list, it should
iterate over the datamsgs instead. Something like the below (just
compile tested).

Then, the old socket will be free to die regardless of the new one.
Otherwise, if this association gets stuck on retransmissions or so,
the old socket would not be freed till then.

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fed26a1e9518..85c742310d26 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -151,9 +151,10 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 				       void (*cb)(struct sctp_chunk *))
 
 {
+	struct sctp_datamsg *msg, *prev_msg = NULL;
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_transport *t;
-	struct sctp_chunk *chunk;
+	struct sctp_chunk *chunk, *c;
 
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
@@ -162,8 +163,14 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
 		cb(chunk);
 
-	list_for_each_entry(chunk, &q->sacked, transmitted_list)
-		cb(chunk);
+	list_for_each_entry(chunk, &q->sacked, transmitted_list) {
+		msg = chunk->msg;
+		if (msg = prev_msg)
+			continue;
+		list_for_each_entry(c, &msg->chunks, frag_list)
+			cb(c);
+		prev_msg = msg;
+	}
 
 	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
 		cb(chunk);
