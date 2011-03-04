From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 05:10:26 +0000
Subject: Re: [PATCH] sctp: do not mark chunk abandoned if peer has no PRSCTP
Message-Id: <4D707442.1090903@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D6F1723.5030909@cn.fujitsu.com> <4D6FA25A.6030401@hp.com>
In-Reply-To: <4D6FA25A.6030401@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>, David Miller <davem@davemloft.net>


> On 03/02/2011 11:20 PM, Wei Yongjun wrote:
>> Chunk is marked abandoned if the chunk is expires, and it not be
>> retransmited even if the peer has no PRSCTP capable, but the peer
>> will still wait for retransmit it to update CTSN.
>> This patch disable mark chunk abandoned if peer has no PRSCTP
>> capable.
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>>  net/sctp/chunk.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
>> index 6c85564..0d4832d 100644
>> --- a/net/sctp/chunk.c
>> +++ b/net/sctp/chunk.c
>> @@ -347,6 +347,9 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
>>  {
>>  	struct sctp_datamsg *msg = chunk->msg;
>>  
>> +	if (!chunk->asoc->peer.prsctp_capable)
>> +		return 0;
>> +
>>  	if (!msg->can_abandon)
>>  		return 0;
>>  
> The trouble is that timetolive can be set on a message independent of Partial Reliability.
> The difference in behavior is that when PR can't be used, a chunk can only be abandoned
> if it has not yet been transmitted.  With PR enabled, the chunk can be abandoned at any time.
>
> So, you can't blindly disallow abandonment. 

But, how can we do PR if peer has no PRSCTP capable?
Return error to application in sendmsg()? If so, how we check this if there is no asoc?


> -vlad
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
