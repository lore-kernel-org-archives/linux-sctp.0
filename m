From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 08 Dec 2010 00:42:25 +0000
Subject: Re: [Lksctp-developers] SCTP_SET_PEER_PRIMARY_ADDR v4 mapped?
Message-Id: <4CFED471.8050008@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4CFDD5BA.2030301@cn.fujitsu.com>
In-Reply-To: <4CFDD5BA.2030301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> On 12/ 7/10 06:35 AM, Wei Yongjun wrote:
>> .......
>> Can you try the following patch?
>
> Embarrassingly, I have to admit that I never successfully built and
> deployed a Linux kernel. Something that's on my (ever growing) todo
> list. I really appreciate your help here, but I will have to leave it
> to you experts to decided how to handle this.
>
> To clarify, your changes will now allow SCTP_SET_PEER_PRIMARY_ADDR to
> accept BOTH v4 and v4-mapped addresses, right? That way compatibility
> will be maintained with existing apps.

Yes, with the patch, both v4 and v4-mapped address is allowed
if v4map is enabled.

>
> -Chris.
>> [PATCH] SCTP: Fix SCTP_SET_PEER_PRIMARY_ADDR to accpet v4mapped address
>>
>> SCTP_SET_PEER_PRIMARY_ADDR does not accpet v4mapped address, this
>> patch will fix it by map v4mapped address to v4 address if allowed.
>>
>> Signed-off-by: Wei Yongjun<yjwei@cn.fujitsu.com>
>> ---
>>   net/sctp/socket.c |    8 ++++++++
>>   1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index 6bd5543..0b9ee34 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -2932,6 +2932,7 @@ static int
>> sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
>>       struct sctp_association    *asoc = NULL;
>>       struct sctp_setpeerprim    prim;
>>       struct sctp_chunk    *chunk;
>> +    struct sctp_af        *af;
>>       int             err;
>>
>>       sp = sctp_sk(sk);
>> @@ -2959,6 +2960,13 @@ static int
>> sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
>>       if (!sctp_state(asoc, ESTABLISHED))
>>           return -ENOTCONN;
>>
>> +    af = sctp_get_af_specific(prim.sspp_addr.ss_family);
>> +    if (!af)
>> +        return -EINVAL;
>> +
>> +    if (!af->addr_valid((union sctp_addr *)&prim.sspp_addr, sp, NULL))
>> +        return -EADDRNOTAVAIL;
>> +
>>       if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr
>> *)&prim.sspp_addr))
>>           return -EADDRNOTAVAIL;
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
