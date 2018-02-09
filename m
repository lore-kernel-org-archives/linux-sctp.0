From: Alexey Kodanev <alexey.kodanev@oracle.com>
Date: Fri, 09 Feb 2018 14:05:37 +0000
Subject: Re: [PATCH] sctp: verify size of a new chunk in _sctp_make_chunk()
Message-Id: <3136bfa1-2edc-08b7-e8c1-c7eb8020919b@oracle.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1518181351-28199-1-git-send-email-alexey.kodanev@oracle.com>
 <20180209132732.GB7278@localhost.localdomain>
In-Reply-To: <20180209132732.GB7278@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org

On 09.02.2018 16:27, Marcelo Ricardo Leitner wrote:
> On Fri, Feb 09, 2018 at 04:02:31PM +0300, Alexey Kodanev wrote:
>> 
>> ---
>>  net/sctp/sm_make_chunk.c |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
>> index 793b05e..95618eb 100644
>> --- a/net/sctp/sm_make_chunk.c
>> +++ b/net/sctp/sm_make_chunk.c
>> @@ -1380,9 +1380,14 @@ void sctp_init_addrs(struct sctp_chunk *chunk, union sctp_addr *src,
> 
> Weird how it identified sctp_init_addrs as the context here o.O
> Line numbers above and the rest below matches _sctp_make_chunk.

Looks like because of my old git version...

> 
>>  	struct sctp_chunk *retval;
>>  	struct sk_buff *skb;
>>  	struct sock *sk;
>> +	int chunklen;
>> +
>> +	chunklen = sizeof(*chunk_hdr) + paylen;
> 
> It's better to do the padding here too, as it may grow the length by 3
> bytes.

Hmm, SCTP_MAX_CHUNK_LEN is 65532 (accounts for padding by subtracting
sizeof(__u32) from 1 << 16) and SCTP_PAD4(65531) equals 65532, i.e. it
can't grow above it or am I missing something?

Agree, may be it's better to not rely on the particular constant value.
I'll send a new version.

Thanks,
Alexey

> 
>   Marcelo
> 
>> +	if (chunklen > SCTP_MAX_CHUNK_LEN)
>> +		goto nodata;
>>  
>>  	/* No need to allocate LL here, as this is only a chunk. */
>> -	skb = alloc_skb(SCTP_PAD4(sizeof(*chunk_hdr) + paylen), gfp);
>> +	skb = alloc_skb(SCTP_PAD4(chunklen), gfp);
>>  	if (!skb)
>>  		goto nodata;
>>  
>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

