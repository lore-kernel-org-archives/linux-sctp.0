From: Jamie Parsons <Jamie.Parsons@metaswitch.com>
Date: Thu, 17 Jan 2013 16:45:34 +0000
Subject: RE: Possible SCTP peer receive window bug
Message-Id: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA722151E6@ENFIRHMBX1.datcon.co.uk>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

That patch looks good apart from a typo - in sctp_outq_teardown(), __sctp_outq_teardown() should be called rather than the recursive call to sctp_outq_teardown().

I've run the test again with this patch in place on the fedora17 LINUX kernel.  It went through the same code path as before receiving the duplicate COOKIE ECHO, outstanding bytes was reinitialized and the peer receive window returned to the expected value.

Thanks for all your help,

Jamie

-----Original Message-----
From: Neil Horman [mailto:nhorman@tuxdriver.com] 
Sent: 16 January 2013 21:12
To: Jamie Parsons
Cc: Vlad Yasevich; Peter Brittain; linux-sctp@vger.kernel.org
Subject: Re: Possible SCTP peer receive window bug

On Wed, Jan 16, 2013 at 04:58:08PM +0000, Jamie Parsons wrote:
> Hi Neil and Vlad,
> 
> Sorry for not getting back to you for a while.  The good news is I think we have got to the bottom of what is going on!
> 
> I think the root cause of the problem is that the function sctp_outq_teardown() clears the queue of packets awaiting an ACK but does not reset the outstanding_bytes field to zero. 
> 
> My testing has hit two basic scenarios:
> 
> 1) lksctp spots the failure (through HEARTBEAT timeouts) before the far end recovers.  In this case, lksctp recovers gracefully, tearing down the association and creating a new one, completing the INIT/COOKIE handshake when the far end attempts to re-establish the association.  This works perfectly, so it's not something particularly strange in the messages from the far end.
> 
> 2) The far end recovers before lksctp spots the failure.  In this case, lksctp tries to reset the existing association, thus generating an SCTP_RESTART notification, remove all outstanding data, reply (to complete the handshake) and then carry on as before.  This is the failing case.
> 
> Looking at the latter in more detail, lksctp ends up calling into sctp_sf_do_dupcook_a which in turn ends up calling sctp_outq_teardown().  The asoc->outqueue is emptied but asoc->outqueue.outstanding_bytes is not reset.  The outstanding_bytes field is then used in sctp_outq_sack() to calculate the new peer receive window.
> 
> I've gathered some system tap output showing the code going through this path.  The bit that convinces me is that the outstanding bytes at the point of the restart is the exact discrepancy in the actual rwnd and what lksctp is reporting.  Looking at the code even more closely, I also see that other places which discard data from the transmitted queue also fix up the outstanding_bytes.  This isn't done in sctp_outq_teardown().
> 
> I think that's a smoking gun, but just in case, I've placed the system tap output (stap2.txt) along with the system tap script (outstanding_bytes_stap), the usual output giving the SCTP status (sctp_status) and a tcpdump file (tcpdump2.pcap) in the FTP directory.  Again the system tap output has the same problems as before, with the exit value of functions returned the same as the entry values.  All of this output came from a repro on a Fedora17 LINUX box.
> 
> Please let me know your thoughts,
> 
> Jamie
> 

I've not yet looked at your stap scripts, but the theory makes good sense to me.
Nice work!

Can you try this patch out?  Its untested, but it should correct the problem if your theory is correct.  Its a bit more than is strictly necessecary, but given what you describe, it makes more sense to me to ensure a re-initalization of the entire structure rather than just fixing up the one value thats wrong for this specific bug. That will future proof us against simmilar errors down the road.

Thanks!
Neil


diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c index 379c81d..bef6a31 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -224,7 +224,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 
 /* Free the outqueue structure and any related pending chunks.
  */
-void sctp_outq_teardown(struct sctp_outq *q)
+static void __sctp_outq_teardown(struct sctp_outq *q)
 {
 	struct sctp_transport *transport;
 	struct list_head *lchunk, *temp;
@@ -277,8 +277,6 @@ void sctp_outq_teardown(struct sctp_outq *q)
 		sctp_chunk_free(chunk);
 	}
 
-	q->error = 0;
-
 	/* Throw away any leftover control chunks. */
 	list_for_each_entry_safe(chunk, tmp, &q->control_chunk_list, list) {
 		list_del_init(&chunk->list);
@@ -286,11 +284,17 @@ void sctp_outq_teardown(struct sctp_outq *q)
 	}
 }
 
+void sctp_outq_teardown(struct sctp_outq *q) {
+	sctp_outq_teardown(q);
+	sctp_outq_init(q->asoc, q);
+}
+
 /* Free the outqueue structure and any related pending chunks.  */  void sctp_outq_free(struct sctp_outq *q)  {
 	/* Throw away leftover chunks. */
-	sctp_outq_teardown(q);
+	__sctp_outq_teardown(q);
 
 	/* If we were kmalloc()'d, free the memory.  */
 	if (q->malloced)
