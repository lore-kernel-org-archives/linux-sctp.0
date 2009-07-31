From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 31 Jul 2009 16:49:25 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet
Message-Id: <4A732095.6030107@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> The sender should create a SACK only if the size of the final SCTP
>> packet does not exceed the current MTU. Base on RFC 4960:
>>
>>   6.1.  Transmission of DATA Chunks
>>
>>     Before an endpoint transmits a DATA chunk, if any received DATA
>>     chunks have not been acknowledged (e.g., due to delayed ack), the
>>     sender should create a SACK and bundle it with the outbound DATA
>>     chunk, as long as the size of the final SCTP packet does not exceed
>>     the current MTU.
>>     
>
>
> I like this much better, but the one thing I don't like is that we end
> up delaying the SACK if it doesn't fit in the chunk.
>   

Why we need to send the SACK immediate? Just to make the one send one
recv mode happy?
In this case, it is better to disable the delay ack, is this correct?

> May be we can add some checking to see if there are more chunks that we'll
> be sending and try to bundle it later.
>
> Another question is whether we should really be sending an immediate SACK
> back after receiving just one DATA?
>
> I still think that this should really be handled by SACK immediately extension.
> The extension can apply when we are single sub-MTU packets, essentially a
> request-response scenario.  There is no reason that Immediate SACKs can't be
> bundled in this manner.
>   

The immediate SACK is sent without delay SACK timer.It is not generate by
sctp_packet_bundle_sack(), it is created by sctp_gen_sack().



