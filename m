From: Wang Weidong <weidong1991.wang@gmail.com>
Date: Wed, 25 Dec 2013 12:25:28 +0000
Subject: Re: [PATCH net-next] sctp: check dst 'NULL' before use it in, sctp_packet_transmit
Message-Id: <52BACEB8.6030704@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52BA8DA2.6030405@huawei.com> <52BAB282.4000308@redhat.com>
In-Reply-To: <52BAB282.4000308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Wang Weidong <wangweidong1@huawei.com>

On 2013/12/25 18:25, Daniel Borkmann wrote:
> On 12/25/2013 08:47 AM, Wang Weidong wrote:
>> skb_dst_set will use dst, if dst is NULL although is not a problem,
>> then goto the no_route and free nskb, so do the skb_dst_set is pointless.
>> so check dst before use it. Remove the unnecessary initialization as well.
>
> Please also cc linux-sctp as you did before!
>
> Just went through the code, only reading from your subject title it first
> sounded like a NULL pointer dereference, but in fact the code is fine and
> nothing is wrong with it. I'd suggest you should make the subject sound
> more "harmless" to not confuse people, imho, since all you do here is some
> cleanup and rearrangement. "Use" sounds to me as dereferencing dst that is
> NULL.
>
Sorry for that. I will fix the subject title and cc to linux-sctp.

Regards,
Wang

>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>> ---
>>   net/sctp/output.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index 3be70a4..9b76d62 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -387,7 +387,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>>       int err = 0;
>>       int padding;        /* How much padding do we need?  */
>>       __u8 has_data = 0;
>> -    struct dst_entry *dst = tp->dst;
>> +    struct dst_entry *dst;
>>       unsigned char *auth = NULL;    /* pointer to auth in skb data */
>>
>>       pr_debug("%s: packet:%p\n", __func__, packet);
>> @@ -420,9 +420,9 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>>           }
>>       }
>>       dst = dst_clone(tp->dst);
>> -    skb_dst_set(nskb, dst);
>>       if (!dst)
>>           goto no_route;
>
> Nit: you should set a newline here.
>
Nice. Thanks.

>> +    skb_dst_set(nskb, dst);
>>
>>       /* Build the SCTP header.  */
>>       sh = (struct sctphdr *)skb_push(nskb, sizeof(struct sctphdr));
>>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
