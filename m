From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 31 Jul 2009 17:04:44 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet
Message-Id: <4A73242C.1040205@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Vlad Yasevich wrote:
>> Wei Yongjun wrote:
>>   
>>> The sender should create a SACK only if the size of the final SCTP
>>> packet does not exceed the current MTU. Base on RFC 4960:
>>>
>>>   6.1.  Transmission of DATA Chunks
>>>
>>>     Before an endpoint transmits a DATA chunk, if any received DATA
>>>     chunks have not been acknowledged (e.g., due to delayed ack), the
>>>     sender should create a SACK and bundle it with the outbound DATA
>>>     chunk, as long as the size of the final SCTP packet does not exceed
>>>     the current MTU.
>>>     
>>
>> I like this much better, but the one thing I don't like is that we end
>> up delaying the SACK if it doesn't fit in the chunk.
>>   
> 
> Why we need to send the SACK immediate? Just to make the one send one
> recv mode happy?
> In this case, it is better to disable the delay ack, is this correct?

Consistent behavior.  A change in message size shouldn't cause a change in
on the wire behavior.

Either we always send a SACK if we have DATA to send, or we don't.  Having a
weird "only if it fits" behavior will have unpredictable results.

> 
>> May be we can add some checking to see if there are more chunks that we'll
>> be sending and try to bundle it later.
>>
>> Another question is whether we should really be sending an immediate SACK
>> back after receiving just one DATA?
>>
>> I still think that this should really be handled by SACK immediately extension.
>> The extension can apply when we are single sub-MTU packets, essentially a
>> request-response scenario.  There is no reason that Immediate SACKs can't be
>> bundled in this manner.
>>   
> 
> The immediate SACK is sent without delay SACK timer.It is not generate by
> sctp_packet_bundle_sack(), it is created by sctp_gen_sack().
> 

Matter of implementation.

-vlad

> 
> 

