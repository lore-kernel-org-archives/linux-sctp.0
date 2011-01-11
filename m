From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Tue, 11 Jan 2011 10:29:42 +0000
Subject: Re: Question regarding struct sctp_association
Message-Id: <4D2C3116.7070703@freyther.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D2AF2C3.8010306@freyther.de>
In-Reply-To: <4D2AF2C3.8010306@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/11/2011 10:12 AM, Wei Yongjun wrote:
> 

>> The sctp_packet has a pointer to sctp_transport. Does every sctp_transport
>> hold a valid pointer to sctp_association? Does it hold a valid pointer if
> 
> assoc not always valid, when we response to an OOTB packet, the
> assoc will be NULL.

Thanks, I am sorry if the next question is totally obvious. I am obviously not
too familiar with SCTP and the implementation here. For an OOTB packet we
first check if we want to ignore it according to the RFC and then it will be
placed in sctp_inq_push(&chunk->rcvr->inqueue, chunk) and here is where I am
lost and the below is just guessing.


--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -490,7 +490,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
         *    HMAC field set to zero (as shown in Figure 6) followed by all
         *    chunks that are placed after the AUTH chunk in the SCTP packet.
         */
-       if (auth)
+       if (auth && asoc)
                sctp_auth_calculate_hmac(asoc, nskb,
                                        (struct sctp_auth_chunk *)auth,
                                        GFP_ATOMIC);

Can an OOTB packet force us to calculate the hmac here?



@@ -563,7 +563,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
                unsigned long timeout;

                /* Restart the AUTOCLOSE timer when sending data. */
-               if (sctp_state(asoc, ESTABLISHED) && asoc->autoclose) {
+               if (asoc && sctp_state(asoc, ESTABLISHED) && asoc->autoclose) {
                        timer = &asoc->timers[SCTP_EVENT_TIMEOUT_AUTOCLOSE];
                        timeout = asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE];


Can an OOTB packet contain data chunks that would make us go through this path?



