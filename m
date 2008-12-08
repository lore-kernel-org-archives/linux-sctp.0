From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 08 Dec 2008 18:53:11 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <493D6D17.7090402@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------040308020807090204020708"
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------040308020807090204020708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Michal Hocko wrote:
> On Mon 24-11-08 10:00:28, Vlad Yasevich wrote:
>> Michal Hocko wrote:
>>> On Fri 21-11-08 09:28:37, Vlad Yasevich wrote:
>>>> Michal
>>> Hi Vlad,
>>>
>>>> This really smells like the corruption of the sctp_packet structure.
>>>> The number chunks printout out is 0, but the list appears to have multiple
>>>> entries on it.
>>>>
>>>> Can you turn on CONFIG_DEBUG_LIST and may be even turn on memory
>>>> debugging as well.
>>> I have turned on some debug config options as you have suggested and
>>> here is the trace (unfortunately there was no other output on my serial
>>> console):
>>>
> [...]
>>>
>>> If you are interested in vmcore, system map and config file, you can find 
>>> them at:
>>> ftp.novell.com/outgoing/System.map-2.6.28-rc5-sctp.debug.gz
>>> ftp.novell.com/outgoing/vmcore.2.6.28-rc5-sctp.debug.gz
>>> ftp.novell.com/outgoing/config-2.6.28-rc5-sctp.debug
>>>
>>> Best regrads
>>
>> Michal
>>
>> In you test runs, what's the data size of the messages you use?
> 
> Both server and client take command-line parameter (2nd) and we have
> tested with the value 1024. You can change it (from 0 up to the lenght
> of s_SndData SCTPCrash.cpp:522)
> 
>> Thanks
>> -vlad
> 

Michal

Can you try this patch.  This applies on top of a clean tree.  I've started a
run with it here as well.

Thanks
-vlad

--------------040308020807090204020708
Content-Type: text/x-diff;
 name="hung_rtx.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hung_rtx.patch"

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 247ebc9..0fdf544 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -604,6 +604,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		if (fast_rtx && !chunk->fast_retransmit)
 			continue;
 
+again:
 		/* Attempt to append this chunk to the packet. */
 		status = sctp_packet_append_chunk(pkt, chunk);
 
@@ -617,20 +618,14 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 			 */
 			if (rtx_timeout || fast_rtx)
 				done = 1;
+			else {
+				/* Bundle this chunk in the next round.  */
+				goto again;
+			}
 
-			/* Bundle next chunk in the next round.  */
 			break;
 
 		case SCTP_XMIT_RWND_FULL:
-			/* Send this packet. */
-			error = sctp_packet_transmit(pkt);
-
-			/* Stop sending DATA as there is no more room
-			 * at the receiver.
-			 */
-			done = 1;
-			break;
-
 		case SCTP_XMIT_NAGLE_DELAY:
 			/* Send this packet. */
 			error = sctp_packet_transmit(pkt);
@@ -929,7 +924,6 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 		}
 
 		/* Finally, transmit new packets.  */
-		start_timer = 0;
 		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
 			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
 			 * stream identifier.
@@ -1028,7 +1022,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			list_add_tail(&chunk->transmitted_list,
 				      &transport->transmitted);
 
-			sctp_transport_reset_timers(transport, start_timer-1);
+			sctp_transport_reset_timers(transport, 0);
 
 			q->empty = 0;
 

--------------040308020807090204020708--
