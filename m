From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 13 May 2010 13:37:54 +0000
Subject: Re: [PATCH] sctp: fix append error cause to ERROR chunk correctly
Message-Id: <4BEC00B2.6000705@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BEB8BE1.2080901@cn.fujitsu.com>
In-Reply-To: <4BEB8BE1.2080901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Neil Horman wrote:
> On Thu, May 13, 2010 at 01:19:29PM +0800, Wei Yongjun wrote:
>> commit 5fa782c2f5ef6c2e4f04d3e228412c9b4a4c8809
>>   sctp: Fix skb_over_panic resulting from multiple invalid \
>>     parameter errors (CVE-2010-1173) (v4)
>>
>> cause 'error cause' never be add the the ERROR chunk due to
>> some typo when check valid length in sctp_init_cause_fixed().
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>>  net/sctp/sm_make_chunk.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
>> index 30c1767..70d6c10 100644
>> --- a/net/sctp/sm_make_chunk.c
>> +++ b/net/sctp/sm_make_chunk.c
>> @@ -141,7 +141,7 @@ int sctp_init_cause_fixed(struct sctp_chunk *chunk, __be16 cause_code,
>>  	len = sizeof(sctp_errhdr_t) + paylen;
>>  	err.length  = htons(len);
>>  
>> -	if (skb_tailroom(chunk->skb) >  len)
>> +	if (skb_tailroom(chunk->skb) < len)
>>  		return -ENOSPC;
>>  	chunk->subh.err_hdr = sctp_addto_chunk_fixed(chunk,
>>  						     sizeof(sctp_errhdr_t),
>> @@ -1421,7 +1421,7 @@ void *sctp_addto_chunk(struct sctp_chunk *chunk, int len, const void *data)
>>  void *sctp_addto_chunk_fixed(struct sctp_chunk *chunk,
>>  			     int len, const void *data)
>>  {
>> -	if (skb_tailroom(chunk->skb) > len)
>> +	if (skb_tailroom(chunk->skb) >= len)
>>  		return sctp_addto_chunk(chunk, len, data);
>>  	else
>>  		return NULL;
> Yup, thanks!
> Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
> 

Yikes..  Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Please submit to netdev with all updated attributions.
