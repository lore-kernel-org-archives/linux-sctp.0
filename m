From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 26 Apr 2010 04:56:01 +0000
Subject: Re: [PATCH 1/2] sctp: fix to check the source address of COOKIE-ECHO
Message-Id: <4BD51CE1.5060601@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BD1746A.70508@cn.fujitsu.com>
In-Reply-To: <4BD1746A.70508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> Hi Wei
>
> Wei Yongjun wrote:
>   
>> SCTP does not check whether the source address of COOKIE-ECHO
>> chunk is part of the any address parameters saved in COOKIE in
>> CLOSED state. So even if the COOKIE-ECHO chunk other address
>> with correct COOKIE, the COOKIE-ECHO chunk still be accepted.
>> If the source does not match any address parameters saved in
>> COOKIE, the COOKIE ECHO chunk should be silently discarded.
>>
>>     
> I don't think this is correct.  An implementation is not required to specify
> the source address in the address parameters list.  The way most
> of rfc4960 is written, the combination of source and address parameters
> is used to construct the transports.  There is no requirement that
> the source should also be listed.
>   

Oh, my real mean is that the source should either be the source address
of the
INIT chunk or any addtess be list in the address parameters list. If It
is not any
of them, the asoc is started with new address? This is not a big
problem, but
endpoint can now accept COOKIE-ECHO with *any source address* plus correct
COOKIE in CLOSE state.

> With this patch, we will start rejecting associations with such implementations.
>
> -vlad
>
>   
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>>  include/net/sctp/constants.h |    1 +
>>  net/sctp/sm_make_chunk.c     |   28 ++++++++++++++++++++++++++++
>>  2 files changed, 29 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
>> index 6390884..288f2b7 100644
>> --- a/include/net/sctp/constants.h
>> +++ b/include/net/sctp/constants.h
>> @@ -183,6 +183,7 @@ typedef enum {
>>  	SCTP_IERROR_NO_DATA,
>>  	SCTP_IERROR_BAD_STREAM,
>>  	SCTP_IERROR_BAD_PORTS,
>> +	SCTP_IERROR_BAD_ADDR,
>>  	SCTP_IERROR_AUTH_BAD_HMAC,
>>  	SCTP_IERROR_AUTH_BAD_KEYID,
>>  	SCTP_IERROR_PROTO_VIOLATION,
>> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
>> index 17cb400..bc7ac37 100644
>> --- a/net/sctp/sm_make_chunk.c
>> +++ b/net/sctp/sm_make_chunk.c
>> @@ -1591,6 +1591,7 @@ struct sctp_association *sctp_unpack_cookie(
>>  	struct sk_buff *skb = chunk->skb;
>>  	struct timeval tv;
>>  	struct hash_desc desc;
>> +	union sctp_params param;
>>  
>>  	/* Header size is static data prior to the actual cookie, including
>>  	 * any padding.
>> @@ -1670,6 +1671,33 @@ no_hmac:
>>  		goto fail;
>>  	}
>>  
>> +	/* Check whether the source address of COOKIE ECHO chunk is part
>> +	 * of the any address parameters. If the value does not match, the
>> +	 * COOKIE ECHO chunk MUST be silently discarded.
>> +	 */
>> +	if (asoc || sctp_cmp_addr_exact(sctp_source(chunk),
>> +					&bear_cookie->peer_addr))
>> +		goto addr_match;
>> +
>> +	sctp_walk_params(param, &bear_cookie->peer_init[0], init_hdr.params) {
>> +		if (param.p->type = SCTP_PARAM_IPV4_ADDRESS ||
>> +		    param.p->type = SCTP_PARAM_IPV6_ADDRESS) {
>> +			struct sctp_af *af;
>> +			union sctp_addr addr;
>> +
>> +			af = sctp_get_af_specific(param_type2af(param.p->type));
>> +			af->from_addr_param(&addr, param.addr,
>> +					    chunk->sctp_hdr->source, 0);
>> +
>> +			if (sctp_cmp_addr_exact(sctp_source(chunk), &addr))
>> +				goto addr_match;
>> +		}
>> +	}
>> +
>> +	*error = -SCTP_IERROR_BAD_ADDR;
>> +	goto fail;
>> +
>> +addr_match:
>>  	/* Check to see if the cookie is stale.  If there is already
>>  	 * an association, there is no need to check cookie's expiration
>>  	 * for init collision case of lost COOKIE ACK.
>>     
>
>   
