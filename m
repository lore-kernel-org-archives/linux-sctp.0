From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 11 May 2010 15:35:35 +0000
Subject: Re: Gap not retransmitted after switchover
Message-Id: <4BE97947.9050203@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------090902090000090505090507"
List-Id: <linux-sctp.vger.kernel.org>
References: <4BE95C1C.4050902@hp.com>
In-Reply-To: <4BE95C1C.4050902@hp.com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------090902090000090505090507
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



Vlad Yasevich wrote:
> 
> Georgios Cheimonidis wrote:
>> Hi Vlad!
>>
>> I have repeated the test with the net-next kernel tree. It seems that
>> the problem persists. Below, I summarize what I observed from the
>> capture at the server side (the client's capture agrees with these
>> observations). Although the timing differs somewhat from the previous
>> test, the basic observation is still the same. After the server switches
>> primary address and removes the previous primary from the association,
>> some unacknowledged DATA packets that were transmitted to the previous
>> primary (after it became unreachable) are never retransmitted to the new
>> one.
>>
> 
> Thanks for testing.  I am looking to see what can be happening.
> 
> -vlad
> 

Hi George.

I figured out why there were no retransmits.  Because you changed primary
path, you kicked in the SFR-CACC algorithm, and our implementation didn't
deal properly with the fact that some chunks may have moved from the old
primary to the new one without going though a retransmit.

There are really 2 ways to deal with this:
	1).  If we are deleting a transport that had outstanding data,
	automatically retransmit the data on the new transport.

	or.

	2) Under the same condition as above, move the data to the new primary
	destination and let fast-recovery take care of the issue.

Linux implemented (2) from above, and thus this bug surfaced.

Try the attached patch, and let me know if it fixes it for you.

-vlad

--------------090902090000090505090507
Content-Type: text/x-patch;
 name="0001-sctp-teach-CACC-algorithm-about-removed-transports.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-sctp-teach-CACC-algorithm-about-removed-transports.patc";
 filename*1="h"

From 7634892e75811970f501aebf88c7c97a86e77066 Mon Sep 17 00:00:00 2001
From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 11 May 2010 11:16:29 -0400
Subject: [PATCH] sctp: teach CACC algorithm about removed transports

When we have have to remove a transport due to ASCONF, we move
the data to a new active path.  This can trigger CACC algorithm
to not mark that data as missing when SACKs arrive.  This is
because the transport passed to the CACC algorithm is the one
this data is sitting on, not the one it was sent on (that one
may be gone).  So, by sending the original transport (even if
it's NULL), we may start marking data as missing.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/outqueue.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 5d05717..dd55f63 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -131,7 +131,8 @@ static inline int sctp_cacc_skip_3_1_d(struct sctp_transport *primary,
 static inline int sctp_cacc_skip_3_1_f(struct sctp_transport *transport,
 				       int count_of_newacks)
 {
-	if (count_of_newacks < 2 && !transport->cacc.cacc_saw_newack)
+	if (count_of_newacks < 2 &&
+			(transport && !transport->cacc.cacc_saw_newack))
 		return 1;
 	return 0;
 }
@@ -620,9 +621,12 @@ redo:
 
 			/* If we are retransmitting, we should only
 			 * send a single packet.
+			 * Otherwise, try appending this chunk again.
 			 */
 			if (rtx_timeout || fast_rtx)
 				done = 1;
+			else
+				goto redo;
 
 			/* Bundle next chunk in the next round.  */
 			break;
@@ -1685,8 +1689,9 @@ static void sctp_mark_missing(struct sctp_outq *q,
 			/* SFR-CACC may require us to skip marking
 			 * this chunk as missing.
 			 */
-			if (!transport || !sctp_cacc_skip(primary, transport,
-					    count_of_newacks, tsn)) {
+			if (!transport || !sctp_cacc_skip(primary,
+						chunk->transport,
+					    	count_of_newacks, tsn)) {
 				chunk->tsn_missing_report++;
 
 				SCTP_DEBUG_PRINTK(
-- 
1.6.0.4


--------------090902090000090505090507--
