From: "Doug Graham" <dgraham@nortel.com>
Date: Sun, 06 Sep 2009 04:27:22 +0000
Subject: Re: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <4AA33A2A.2070007@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Doug Graham wrote:
>   
>>> Sorry, haven't had a lot of time to play with this until now.  The
>>> behaviour for
>>> small unfragmented message looks fine, but if the message has to be
>>> fragmented,
>>> things don't look so good.  I'm ping-ponging a 1500 byte message
>>> around: client
>>> sends 1500 bytes, server reads that and replies with the same message,
>>> client
>>> reads the reply then sleeps 2 seconds before doing it all over again. 
>>> I see no
>>> piggybacking happening at all.  A typical cycle looks like:
>>>
>>> 12 2.007226    10.0.0.248    10.0.0.249    SCTP     DATA  (TSN 7376)
>>> 13 2.007268    10.0.0.248    10.0.0.249    SCTP     DATA  (TSN 7377)
>>> 14 2.007313    10.0.0.249    10.0.0.248    SCTP     SACK  (TSN 7377)
>>> 15 2.007390    10.0.0.249    10.0.0.248    SCTP     SACK  (TSN 7377)
>>> 16 2.007542    10.0.0.249    10.0.0.248    SCTP     DATA
>>> 17 2.007567    10.0.0.249    10.0.0.248    SCTP     DATA
>>> 18 2.007615    10.0.0.248    10.0.0.249    SCTP     SACK
>>> 19 2.007661    10.0.0.248    10.0.0.249    SCTP     SACK
>>>
>>> Those back-to-back SACKs look wasteful too.  One should have done the
>>> job,
>>> although I suppose I can't be sure that SACKs aren't crossing DATA
>>> on the wire.  But the real mystery is why the SACKs were
>>> sent immediately after the DATA was received.  Looks like delayed SACKs
>>> might be broken, although they are working for unfragmented messages.
>>>
>>>       
>> It just occurred to me to check the TSNs too, and I've redone the
>> annotation
>> in the trace above with those.  So the back-to-back SACKs are
>> duplicates: both
>> acknowledge the second data chunk (so they could not have crossed DATA
>> on the
>> wire).
>>     
>
> What does the a_rwnd size look like?  Since you are moving 1500 byte
> payload around, once your app has consumed the data, that will trigger
> a rwnd update SACK, so it'll look like 2 sacks.  I bet that's what's
> happening in your scenario.
>
> The first SACK back is the immediate SACK after 2 packets.  So, in this
> case, there is no bundling possible, unless we delay one of the SACKs
> waiting for user data.  Try something with an odd number of segments.
>
>   
You're right about the reasons for the two SACKs.  An odd
number of chunks still doesn't result in any piggybacking though
(see trace below).  Every even chunk is SACKed because of the
ack-every-second-packet rule, and the last chunk always results in a
window update SACK being sent when the app reads the data.  So I'm
not sure that all the fancy footwork to try to piggyback SACKs on
fragmented messages is buying much, at least not in the case where
client and server are sending each other messages of the same size.

Here's a trace with messages of 3000 bytes.  In this case, frames
19 and 20 must have crossed on the wire.

 17 2.009811    10.0.0.248  10.0.0.249  SCTP     DATA (TSN 8430)
 18 2.010058    10.0.0.248  10.0.0.249  SCTP     DATA (TSN 8431)
 19 2.010211    10.0.0.248  10.0.0.249  SCTP     DATA (TSN 8432)
 20 2.010248    10.0.0.249  10.0.0.248  SCTP     SACK (TSN 8431)
 21 2.010528    10.0.0.249  10.0.0.248  SCTP     SACK (TSN 8432)
 22 2.010928    10.0.0.249  10.0.0.248  SCTP     DATA
 23 2.011156    10.0.0.249  10.0.0.248  SCTP     DATA
 24 2.011297    10.0.0.249  10.0.0.248  SCTP     DATA
 25 2.011395    10.0.0.248  10.0.0.249  SCTP     SACK
 26 2.011688    10.0.0.248  10.0.0.249  SCTP     SACK

Oh well, the SACK-SACK-DATA sequences being sent in the same direction
do seem a bit wasteful when a single DATA with a piggybacked SACK would
have done the job nicely, but I don't see how that could be improved
on without delaying one or both of the SACKs.

BTW, even in the case where a message is being sent that is small
enough to fit in one packet, but too large to have a SACK bundled
with it, the code you added to chunk.c to encourage SACK bundling
doesn't kick in.  It's doesn't kick in because the "msg_len > max"
test fails.  Depending on your intent, I think maybe that test ought
to be "msg_len + sizeof(sctp_sack_chunk_t) > max".  For example, if
I send a message of size 1438 and max is at its usual value of 1452
(when the MTU is 1500), the existing test will fail and not reserve
space for the SACK even though there isn't room to bundle a 16 byte
SACK with a 1438 byte DATA chunk.

In fact, I don't think there's *any* test that involves a client and
server sending equal sized messages to each other that will trigger
the new code in chunk.c.  For small messages, it's irrelevant,
for messages just less than the MTU, it isn't triggered because
of what I've just explained, and for large messages that need
to be fragmented, it isn't triggered because the SACKs are sent
immediately as we've seen, so the SACK timer won't be running.

--Doug

