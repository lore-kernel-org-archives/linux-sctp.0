From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 08 Sep 2009 19:31:02 +0000
Subject: Re: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <4AA6B0F6.2090509@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------020302090100050706080008"
List-Id: <linux-sctp.vger.kernel.org>
References: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------020302090100050706080008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Doug Graham wrote:
> Vlad Yasevich wrote:
>> Doug Graham wrote:
>>  
>>>> Sorry, haven't had a lot of time to play with this until now.  The
>>>> behaviour for
>>>> small unfragmented message looks fine, but if the message has to be
>>>> fragmented,
>>>> things don't look so good.  I'm ping-ponging a 1500 byte message
>>>> around: client
>>>> sends 1500 bytes, server reads that and replies with the same message,
>>>> client
>>>> reads the reply then sleeps 2 seconds before doing it all over
>>>> again. I see no
>>>> piggybacking happening at all.  A typical cycle looks like:
>>>>
>>>> 12 2.007226    10.0.0.248    10.0.0.249    SCTP     DATA  (TSN 7376)
>>>> 13 2.007268    10.0.0.248    10.0.0.249    SCTP     DATA  (TSN 7377)
>>>> 14 2.007313    10.0.0.249    10.0.0.248    SCTP     SACK  (TSN 7377)
>>>> 15 2.007390    10.0.0.249    10.0.0.248    SCTP     SACK  (TSN 7377)
>>>> 16 2.007542    10.0.0.249    10.0.0.248    SCTP     DATA
>>>> 17 2.007567    10.0.0.249    10.0.0.248    SCTP     DATA
>>>> 18 2.007615    10.0.0.248    10.0.0.249    SCTP     SACK
>>>> 19 2.007661    10.0.0.248    10.0.0.249    SCTP     SACK
>>>>
>>>> Those back-to-back SACKs look wasteful too.  One should have done the
>>>> job,
>>>> although I suppose I can't be sure that SACKs aren't crossing DATA
>>>> on the wire.  But the real mystery is why the SACKs were
>>>> sent immediately after the DATA was received.  Looks like delayed SACKs
>>>> might be broken, although they are working for unfragmented messages.
>>>>
>>>>       
>>> It just occurred to me to check the TSNs too, and I've redone the
>>> annotation
>>> in the trace above with those.  So the back-to-back SACKs are
>>> duplicates: both
>>> acknowledge the second data chunk (so they could not have crossed DATA
>>> on the
>>> wire).
>>>     
>>
>> What does the a_rwnd size look like?  Since you are moving 1500 byte
>> payload around, once your app has consumed the data, that will trigger
>> a rwnd update SACK, so it'll look like 2 sacks.  I bet that's what's
>> happening in your scenario.
>>
>> The first SACK back is the immediate SACK after 2 packets.  So, in this
>> case, there is no bundling possible, unless we delay one of the SACKs
>> waiting for user data.  Try something with an odd number of segments.
>>
>>   
> You're right about the reasons for the two SACKs.  An odd
> number of chunks still doesn't result in any piggybacking though
> (see trace below).  Every even chunk is SACKed because of the
> ack-every-second-packet rule, and the last chunk always results in a
> window update SACK being sent when the app reads the data.  So I'm
> not sure that all the fancy footwork to try to piggyback SACKs on
> fragmented messages is buying much, at least not in the case where
> client and server are sending each other messages of the same size.

Yeah, I realized shortly after sending a reply.  Well, in this case
there is really no opportunity to piggy-back the SACK on anything
since we don't have any pending DATA.

In a 2 directional stream test I ran, I saw piggibacking since
there was actually pending DATA queued up when time for SACK arrived.
Even here though, we didn't have optimal piggybacking.

> 
> Here's a trace with messages of 3000 bytes.  In this case, frames
> 19 and 20 must have crossed on the wire.
> 
> 17 2.009811    10.0.0.248  10.0.0.249  SCTP     DATA (TSN 8430)
> 18 2.010058    10.0.0.248  10.0.0.249  SCTP     DATA (TSN 8431)
> 19 2.010211    10.0.0.248  10.0.0.249  SCTP     DATA (TSN 8432)
> 20 2.010248    10.0.0.249  10.0.0.248  SCTP     SACK (TSN 8431)
> 21 2.010528    10.0.0.249  10.0.0.248  SCTP     SACK (TSN 8432)
> 22 2.010928    10.0.0.249  10.0.0.248  SCTP     DATA
> 23 2.011156    10.0.0.249  10.0.0.248  SCTP     DATA
> 24 2.011297    10.0.0.249  10.0.0.248  SCTP     DATA
> 25 2.011395    10.0.0.248  10.0.0.249  SCTP     SACK
> 26 2.011688    10.0.0.248  10.0.0.249  SCTP     SACK
> 
> Oh well, the SACK-SACK-DATA sequences being sent in the same direction
> do seem a bit wasteful when a single DATA with a piggybacked SACK would
> have done the job nicely, but I don't see how that could be improved
> on without delaying one or both of the SACKs.

Yes.  I have some ideas on how to do that.  Let me hack on it a bit
and I'll let you know if I have anything.

> 
> BTW, even in the case where a message is being sent that is small
> enough to fit in one packet, but too large to have a SACK bundled
> with it, the code you added to chunk.c to encourage SACK bundling
> doesn't kick in.  It's doesn't kick in because the "msg_len > max"
> test fails.  Depending on your intent, I think maybe that test ought
> to be "msg_len + sizeof(sctp_sack_chunk_t) > max". 

The intent was to not fragment if it was not fragmented before.
That intent came from the Nagle kicking in on the second small fragment.
I was getting abysmal results when I was fragmenting and hitting Nagle.

So, the code essentially says that if we are going to fragment anyway,
then allow SACKs into the first fragment.  If we are not fragmenting, then
SACK will be bundled on best effort basis.  That's what bundling is all about
it, anyway.  It's best effort.

Making Nagle not applicable to fragments didn't make sense since that would
allow you to effectively disable Nagle by setting a SCTP_MAXSEG to 1/2 your
message size and then sending small messages.

So, now Nagle doesn't apply to messages that would fill the mtu.  I think I can
do this a little bit better though...

Try attached patch on top of the net-next tree.

It give me the following pattern with 1444 byte payload:

DATA (1444) -------->
            <-------   SACK + DATA(1436)
            <-------   DATA (8)
SACK        -------->
DATA (1444) -------->
            <-------   SACK + DATA(1436)
            <-------   DATA (8)


Not sure if this better then a pattern of:

DATA    -------->
        <--------  SACK
        <-------   DATA
SACK    -------->
DATA    -------->
        <-------- SACK
        <-------- DATA

The original code attempted to account for SACK length if we were fragmenting
anyway.  That seemed like a safe thing to do.  All the fancy footwork was really
to make sure that we don't needlessly reduce message size.

The only difference I see is the size of the second packet will fluctuate
between 66 and 78 bytes, where as the SACK packet is typically 62 bytes
(including ethernet).

-vlad

--------------020302090100050706080008
Content-Type: text/plain;
 name="try"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="try"

commit c7be5d98b7b760dcd071415f018ee31312372ef5
Author: Vlad Yasevich <vladislav.yasevich@hp.com>
Date:   Tue Sep 8 14:39:47 2009 -0400

    sctp: Tag messages that can be Nagle delayed at creation.
    
    When we create the sctp_datamsg and fragment the user data,
    we know exactly if we are sending full segments or not and
    how they might be bundled.  During this time, we can mark
    messages a Nagle capable or not.  This makes the check at
    transmit time much simpler.
    
    Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 42d00ce..103e748 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -645,9 +645,9 @@ struct sctp_datamsg {
 	unsigned long expires_at;
 	/* Did the messenge fail to send? */
 	int send_error;
-	char send_failed;
-	/* Control whether chunks from this message can be abandoned. */
-	char can_abandon;
+	u8 send_failed:1,
+	   can_abandon:1,   /* can chunks from this message can be abandoned. */
+	   can_delay;	    /* should this message be Nagle delayed */
 };
 
 struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index acf7c4d..9de8643 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -57,6 +57,7 @@ static void sctp_datamsg_init(struct sctp_datamsg *msg)
 	msg->send_failed = 0;
 	msg->send_error = 0;
 	msg->can_abandon = 0;
+	msg->can_delay = 1;
 	msg->expires_at = 0;
 	INIT_LIST_HEAD(&msg->chunks);
 	msg->msg_size = 0;
@@ -230,8 +231,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	 */
 	if (timer_pending(&asoc->timers[SCTP_EVENT_TIMEOUT_SACK]) &&
 	    asoc->outqueue.out_qlen == 0 &&
-	    list_empty(&asoc->outqueue.retransmit) &&
-	    msg_len > max)
+	    list_empty(&asoc->outqueue.retransmit))
 		max_data -= WORD_ROUND(sizeof(sctp_sack_chunk_t));
 
 	/* Encourage Cookie-ECHO bundling. */
@@ -246,6 +246,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	if (msg_len >= first_len) {
 		msg_len -= first_len;
 		whole = 1;
+		msg->can_delay = 0;
 	}
 
 	/* How many full sized?  How many bytes leftover? */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 5cbda8f..36bd0fd 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -706,7 +706,7 @@ static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
 		 * Don't delay large message writes that may have been
 		 * fragmeneted into small peices.
 		 */
-		if ((len < max) && (chunk->msg->msg_size < max)) {
+		if ((len < max) && chunk->msg->can_delay) {
 			retval = SCTP_XMIT_NAGLE_DELAY;
 			goto finish;
 		}

--------------020302090100050706080008--
