From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 31 Jul 2009 00:53:55 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A7240A3.6010803@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> On Thu, Jul 30, 2009 at 05:24:09PM -0400, Vlad Yasevich wrote:
>   
>> Doug Graham wrote:
>>     
>>> On Thu, Jul 30, 2009 at 05:51:18PM +0800, Wei Yongjun wrote:
>>>       
>>>> The sender should create a SACK only if the size of the final SCTP
>>>> packet does not exceed the current MTU. Base on RFC 4960:
>>>>
>>>>   6.1.  Transmission of DATA Chunks
>>>>
>>>>     Before an endpoint transmits a DATA chunk, if any received DATA
>>>>     chunks have not been acknowledged (e.g., due to delayed ack), the
>>>>     sender should create a SACK and bundle it with the outbound DATA
>>>>     chunk, as long as the size of the final SCTP packet does not exceed
>>>>     the current MTU.
>>>>         
>>> [patch deleted]
>>>
>>> I think you're right that there's a real problem here, and that a patch
>>> similar to yours is needed, but this is not a new problem introduced
>>> with my patch.  I only changed the conditions under which a SACK chunk
>>> was bundled with a DATA chunk, but the same bundling would have been
>>> happening before under different conditions.
>>>       
>> Doug
>>
>> If you still have BSD setup, can you try increasing you message size
>> to say 1442 and see what happens.
>>
>> I'd expect bundles SACKs at 1440 bytes, but then probably a separate SACK and DATA.
>>     
>
> The largest amount of data I can send and still have the BSD server bundle
> a SACK with the response is 1436 bytes.  The total ethernet frame size
> at that point is 1514 bytes, so this seems correct.  I've attached
> wireshark captures with data sizes of 1436 bytes and 1438 bytes.
> It's interesting to note that if BSD decides not to bundle a SACK,
> it instead sends a separate SACK packet immediately; it does not wait
> for the SACK timer to timeout.  It first sends the SACK, then the DATA
> immediately follows. I don't think Wei's patch would do this; I think
> that if his patch determined that bundling a SACK would cause the packet
> to exceed the MTU, then the behaviour will revert to what it was before
> my patch is applied: ie the SACK will not be sent for 200ms.
>   

Before my patch, SACK sent on linux is the same as BSD. But... BSD's
implemention is really correct?

RFC said:

the sender should create a SACK and bundle it with the outbound DATA
chunk, as long as the size of the final SCTP packet does not exceed
the current MTU.

So, we just need create a SACK only if the final packet size does not
exceed the MTU. Always send SACK may cause lower performance.

> So I guess the logic when about to send a DATA chunk should go something
> like:
>
>  if (sack_timer_running) {
>    /* We know we owe the peer a SACK */
>    if (SACK + DATA fits in the MTU)
>       bundle SACK with DATA and send that
>    else {
>       send SACK in a separate packet
>       send DATA in a separate packet
>    }
>    turn_off_sack_timer
>  }
>
> I don't think the RFC was explicit on what to do if the SACK+DATA
> exceeds the MTU, but this makes sense to me.
>
> --Doug.
>   


