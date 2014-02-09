From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Sun, 09 Feb 2014 07:11:43 +0000
Subject: [PATCH lksctp-tools] Remove dependency to implementation-specific a_rwnd behavior
Message-Id: <52F72A2F.2070705@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

test_timetolive and test_sctp_sendrecvmsq take advantage of the following lksctp
characteristic:

 - SO_RECVBUF being set prior association is established will control initially
   advertised rwnd
 - Modifying SO_RECVBUF later will keep maximum rwnd at the initial value which
   is defined at the association startup

Test cases use this fact in order to initially advertise small rwnd, increase
buffer later, but keeping the initial rwnd as maximum one. However, we may at
later time increase buffer, and implementation may advertise this to the
partner. RFC4960 only forbids decrease of the buffer space:

   Advertised Receiver Window Credit (a_rwnd): 32 bits (unsigned
   integer)

      This value represents the dedicated buffer space, in number of
      bytes, the sender of the INIT has reserved in association with
      this window.  During the life of the association, this buffer
      space SHOULD NOT be lessened (i.e., dedicated buffers taken away
      from this association); however, an endpoint MAY change the value
      of a_rwnd it sends in SACK chunks.

Having in mind that rwnd reflects free space in receiver's buffer,
implementation may advertise new value, and therefore test case should not
rely on above defined behavior. There is no impact on functional behavior of
test cases due to this change.

This change was done in course of '[PATCH v2] net: sctp: Fix a_rwnd/rwnd
management to reflect real state of the receiver's buffer', as with this patch
behavior is changed from described to rwnd reflecting real buffer state.

Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>

--- lksctp-tools.orig/src/func_tests/test_timetolive.c
+++ lksctp-tools/src/func_tests/test_timetolive.c
@@ -172,10 +172,8 @@ int main(int argc, char *argv[])
 	 * This code sets the associations RWND very small so we can
 	 * fill it.  It does this by manipulating the rcvbuf as follows:
 	 * 1) Reduce the rcvbuf size on the socket
-	 * 2) create an association so that we advertize rcvbuf/2 as
+	 * 2) create an association so that we advertise rcvbuf/2 as
 	 *    our initial rwnd
-	 * 3) raise the rcvbuf value so that we don't drop data wile 
-	 *    receiving later data
 	 */
 	len = SMALL_RCVBUF;
 	error = setsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &len,
@@ -239,14 +237,6 @@ int main(int argc, char *argv[])
 	sac = (struct sctp_assoc_change *)iov.iov_base;
 	associd1 = sac->sac_assoc_id;
 
-	/* restore the rcvbuffer size for the receiving socket */
-	error = setsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &orig_len,
-			   sizeof(orig_len));
-
-	if (error)
-		tst_brkm(TBROK, tst_exit, "setsockopt(SO_RCVBUF): %s",
-			strerror(errno));
-
         /* Get the first data message which was sent.  */
         inmessage.msg_controllen = sizeof(incmsg);
         error = test_recvmsg(sk2, &inmessage, MSG_WAITALL);
--- lksctp-tools.orig/src/func_tests/test_sctp_sendrecvmsg.c
+++ lksctp-tools/src/func_tests/test_sctp_sendrecvmsg.c
@@ -142,7 +142,6 @@ int main(int argc, char *argv[])
 
 	/*
 	 * Set the RWND small so we can fill it up easily.
-	 * then reset RCVBUF to avoid frame droppage
 	 */
 	len = sizeof(int);
 	error = getsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &oldlen, &len);
@@ -186,14 +185,6 @@ int main(int argc, char *argv[])
 				    SCTP_ASSOC_CHANGE, SCTP_COMM_UP);
 
 
-	/* restore the rcvbuffer size for the receiving socket */
-	error = setsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &oldlen,
-			   sizeof(oldlen));
-
-	if (error)
-		tst_brkm(TBROK, tst_exit, "setsockopt(SO_RCVBUF): %s",
-			 strerror(errno));
-
 	/* Get the communication up message on sk1.  */
 	buflen = REALLY_BIG;
 	msgname_len = sizeof(msgname);
