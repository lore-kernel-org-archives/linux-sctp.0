From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Sun, 22 Dec 2019 04:22:24 +0000
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
Message-Id: <1ec267f2-1172-32c0-baee-0d4ebcbfb380@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191220044703.88-1-qdkevin.kou@gmail.com>
 <20191220161756.GE5058@localhost.localdomain>
In-Reply-To: <20191220161756.GE5058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org



On 2019/12/21 0:17, Marcelo Ricardo Leitner wrote:
> On Fri, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
>> The function sctp_sf_eat_sack_6_2 now performs
>> the Verification Tag validation, Chunk length validation, Bogu check,
>> and also the detection of out-of-order SACK based on the RFC2960
>> Section 6.2 at the beginning, and finally performs the further
>> processing of SACK. The trace_sctp_probe now triggered before
>> the above necessary validation and check.
>>
>> This patch is to do the trace_sctp_probe after the necessary check
>> and validation to SACK.
>>
>> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
>> ---
>>   net/sctp/sm_statefuns.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>> index 42558fa..b4a54df 100644
>> --- a/net/sctp/sm_statefuns.c
>> +++ b/net/sctp/sm_statefuns.c
>> @@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>>   	struct sctp_sackhdr *sackh;
>>   	__u32 ctsn;
>>   
>> -	trace_sctp_probe(ep, asoc, chunk);
>>   
>>   	if (!sctp_vtag_verify(chunk, asoc))
>>   		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>> @@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>>   	if (!TSN_lt(ctsn, asoc->next_tsn))
>>   		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
>>   
>> +	trace_sctp_probe(ep, asoc, chunk);
>> +
> 
> Moving it here will be after the check against ctsn_ack_point, which
> could cause duplicated SACKs to be missed from the log.


As this SCTP trace used to trace the changes of SCTP association state 
in response to incoming packets(SACK). It is used for debugging SCTP 
congestion control algorithms, so according to the code in 
include/trace/events/sctp.h, the trace event mainly focus on congestion 
related information, and there is no SACK Chunk related information 
printed. So it is hard to point out whether the SACK is duplicate one or 
not based on this trace event.

include/trace/events/sctp.h
1. TRACE_EVENT(sctp_probe,

TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
		  "rwnd=%u unack_data=%d",
		  __entry->asoc, __entry->mark, __entry->bind_port,
		  __entry->peer_port, __entry->pathmtu, __entry->rwnd,
		  __entry->unack_data)

2. TRACE_EVENT(sctp_probe_path,

TP_printk("asoc=%#llx%s ipaddr=%pISpc state=%u cwnd=%u ssthresh=%u "
		  "flight_size=%u partial_bytes_acked=%u pathmtu=%u",
		  __entry->asoc, __entry->primary ? "(*)" : "",
		  __entry->ipaddr, __entry->state, __entry->cwnd,
		  __entry->ssthresh, __entry->flight_size,
		  __entry->partial_bytes_acked, __entry->pathmtu)

> 
> Yes, from the sender-side CC we don't care about it (yet), but it
> helps to spot probably avoidable retransmissions.
> 
> I think this is cleaning up the noise too much. I can agree with
> moving it to after the chunk sanity tests, though.
> 
>>   	/* Return this SACK for further processing.  */
>>   	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>>   
>> -- 
>> 1.8.3.1
>>
