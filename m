From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 28 Apr 2010 03:50:03 +0000
Subject: Re: [PATCH 2/2] sctp: COOKIE-ACK should back to where the COOKIE-ECHO
Message-Id: <4BD7B06B.2060800@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BD174DC.40308@cn.fujitsu.com>
In-Reply-To: <4BD174DC.40308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> Hi Wei
>
> Wei Yongjun wrote:
>   
>> This patch fixed to send COOKIE-ACK back to where the COOKIE-ECHO
>> came from, and if COOKIE ACK is sent to an UNCONFIRMED address,
>> bundled it with a HEARTBEAT including a nonce. Based on RFC4960:
>>
>>   Section 6.4.  Multi-Homed SCTP Endpoints
>>
>>   An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
>>   etc.) to the same destination transport address from which it
>>   received the DATA or control chunk to which it is replying.
>>
>>   Section 5.4.  Path Verification:
>>
>>   -  A COOKIE ACK MAY be sent to an UNCONFIRMED address, but it MUST be
>>      bundled with a HEARTBEAT including a nonce.  An implementation
>>      that does NOT support bundling MUST NOT send a COOKIE ACK to an
>>      UNCONFIRMED address.
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>>  net/sctp/output.c        |   22 ++++++++++++++++++++++
>>  net/sctp/outqueue.c      |    1 +
>>  net/sctp/sm_make_chunk.c |    3 +++
>>  3 files changed, 26 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index fad261d..a68a57d 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -260,6 +260,25 @@ static sctp_xmit_t sctp_packet_bundle_sack(struct sctp_packet *pkt,
>>  	return retval;
>>  }
>>  
>> +/* Try to bundle a HEARTBEAT with the packet. */
>> +static sctp_xmit_t sctp_packet_bundle_hb(struct sctp_packet *pkt,
>> +					 struct sctp_chunk *chunk)
>> +{
>> +	sctp_xmit_t retval = SCTP_XMIT_OK;
>> +
>> +	if (pkt->transport->state = SCTP_UNCONFIRMED &&
>> +	    chunk->chunk_hdr->type = SCTP_CID_COOKIE_ACK) {
>> +		struct sctp_transport *transport = pkt->transport;
>> +		struct sctp_chunk *hb;
>> +
>> +		hb = sctp_make_heartbeat(transport->asoc, transport);
>> +		if (hb)
>> +			retval = sctp_packet_append_chunk(pkt, hb);
>> +	}
>> +
>> +	return retval;
>> +}
>> +
>>  /* Append a chunk to the offered packet reporting back any inability to do
>>   * so.
>>   */
>> @@ -329,6 +348,9 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
>>  	list_add_tail(&chunk->list, &packet->chunk_list);
>>  	packet->size += chunk_len;
>>  	chunk->transport = packet->transport;
>> +
>> +	/* Try to bundle HEARTBEAT chunk */
>> +	retval = sctp_packet_bundle_hb(packet, chunk);
>>     
> Not sure if this is the right place.  Also, this will add the HB after cookie-ACK.
> I am wondering if it should go before.   Seems a more correct thing to do is
> to elicit HB-ACK before any further data might flow over the transport.
>   

I add the HB after cookie-ACK is because that the COOKIE-ECHO on
UNCONFIRMED address must also be bundled with a HEARTBEAT.
If HB is before COOKIE-ECHO, the peer is in CLOSED state and the
HB will be treat as OOTB chunk. And I think COOKIE-ACK need to
do the same thing.


> Also, what about all the HB related things like error counters, timers, etc...
> Seems that we should also do that.
>   

Not sure about that, the first HB may be sent then RTO is expired.
Do this may change the orig HB's action.


> May be we can just cue the HB to the control queue if we are not replying to the
> source of INIT-ACK?
>   

If the state is UNCONFIRMED, the transport should not be the source
of INIT-ACK, since INIT-ACK is sent to the source of INIT, and it should
be in ACTIVE state.


>   
>>  finish:
>>  	return retval;
>>  }
>> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
>> index abfc0b8..322ecd1 100644
>> --- a/net/sctp/outqueue.c
>> +++ b/net/sctp/outqueue.c
>> @@ -788,6 +788,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>>  			 */
>>  			if (chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT &&
>>  			    chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT_ACK &&
>> +			    chunk->chunk_hdr->type != SCTP_CID_COOKIE_ACK &&
>>  			    chunk->chunk_hdr->type != SCTP_CID_ASCONF_ACK)
>>  				new_transport = asoc->peer.active_path;
>>  		}
>> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
>> index 04c45dd..b9f08f0 100644
>> --- a/net/sctp/sm_make_chunk.c
>> +++ b/net/sctp/sm_make_chunk.c
>> @@ -584,6 +584,9 @@ struct sctp_chunk *sctp_make_cookie_ack(const struct sctp_association *asoc,
>>  	if (retval && chunk)
>>  		retval->transport = chunk->transport;
>>  
>> +	if (retval && !retval->transport)
>> +		retval->dest = chunk->source;
>> +
>>     
> This one is good, but I am thinking that transport assignment may be incorrect.
>  Like I said before, when we are restarting, the transport assigned is from the
> existing association, but the packet is transmitted on the temporary association
> that's about to vanish.  Not sure if this is ok.
>   

It can works, but may be the transport should not be set, the only
thing we should do is set the retval->dest.


>
>   
>>  	return retval;
>>  }
>>  
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
