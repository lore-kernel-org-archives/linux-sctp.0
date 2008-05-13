From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 13 May 2008 12:48:39 +0000
Subject: Re: [PATCH] [SCTP]: Add address type check while process paramaters
Message-Id: <48298E27.40100@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1210360195-16524-1-git-send-email-vladislav.yasevich@hp.com> <1210360195-16524-2-git-send-email-vladislav.yasevich@hp.com> <48297BE9.9020204@trash.net>
In-Reply-To: <48297BE9.9020204@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, Wei Yongjun <yjwei@cn.fujitsu.com>

Patrick McHardy wrote:
> Vlad Yasevich wrote:
>> @@ -2827,6 +2827,19 @@ static __be16 sctp_process_asconf_param(struct 
>> sctp_association *asoc,
>>      union sctp_addr    addr;
>>      union sctp_addr_param *addr_param;
>>  
>> +    switch (addr_param->v4.param_hdr.type) {
> 
> ^^^ use of addr_param
> 
>> +    case SCTP_PARAM_IPV6_ADDRESS:
>> +        if (!asoc->peer.ipv6_address)
>> +            return SCTP_ERROR_INV_PARAM;
>> +        break;
>> +    case SCTP_PARAM_IPV4_ADDRESS:
>> +        if (!asoc->peer.ipv4_address)
>> +            return SCTP_ERROR_INV_PARAM;
>> +        break;
>> +    default:
>> +        return SCTP_ERROR_INV_PARAM;
>> +    }
>> +
>>      addr_param = (union sctp_addr_param *)
>>              ((void *)asconf_param + sizeof(sctp_addip_param_t));
> 
> ^^^ initialization of addr_param
> 
> The patch is wrong and needs this fix on top.
> 

Ack.  David, please apply.  I missed this warning in the my builds...

Thanks
-vlad
