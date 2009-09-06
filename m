From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sun, 06 Sep 2009 02:06:33 +0000
Subject: Re: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <4AA31929.5080009@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> 
>>
>> Sorry, haven't had a lot of time to play with this until now.  The
>> behaviour for
>> small unfragmented message looks fine, but if the message has to be
>> fragmented,
>> things don't look so good.  I'm ping-ponging a 1500 byte message
>> around: client
>> sends 1500 bytes, server reads that and replies with the same message,
>> client
>> reads the reply then sleeps 2 seconds before doing it all over again. 
>> I see no
>> piggybacking happening at all.  A typical cycle looks like:
>>
>> 12 2.007226    10.0.0.248    10.0.0.249    SCTP     DATA  (TSN 7376)
>> 13 2.007268    10.0.0.248    10.0.0.249    SCTP     DATA  (TSN 7377)
>> 14 2.007313    10.0.0.249    10.0.0.248    SCTP     SACK  (TSN 7377)
>> 15 2.007390    10.0.0.249    10.0.0.248    SCTP     SACK  (TSN 7377)
>> 16 2.007542    10.0.0.249    10.0.0.248    SCTP     DATA
>> 17 2.007567    10.0.0.249    10.0.0.248    SCTP     DATA
>> 18 2.007615    10.0.0.248    10.0.0.249    SCTP     SACK
>> 19 2.007661    10.0.0.248    10.0.0.249    SCTP     SACK
>>
>> Those back-to-back SACKs look wasteful too.  One should have done the
>> job,
>> although I suppose I can't be sure that SACKs aren't crossing DATA
>> on the wire.  But the real mystery is why the SACKs were
>> sent immediately after the DATA was received.  Looks like delayed SACKs
>> might be broken, although they are working for unfragmented messages.
>>
> 
> It just occurred to me to check the TSNs too, and I've redone the
> annotation
> in the trace above with those.  So the back-to-back SACKs are
> duplicates: both
> acknowledge the second data chunk (so they could not have crossed DATA
> on the
> wire).

What does the a_rwnd size look like?  Since you are moving 1500 byte
payload around, once your app has consumed the data, that will trigger
a rwnd update SACK, so it'll look like 2 sacks.  I bet that's what's
happening in your scenario.

The first SACK back is the immediate SACK after 2 packets.  So, in this
case, there is no bundling possible, unless we delay one of the SACKs
waiting for user data.  Try something with an odd number of segments.

-vlad
 
> 
> --Doug
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

