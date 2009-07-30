From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 30 Jul 2009 14:28:13 +0000
Subject: Re: [PATCH] sctp: remove unused union (sctp_cmsg_data_t) definition
Message-Id: <4A71ADFD.3080307@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
In-Reply-To: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Rami Rosen wrote:
>>> it still used by lksctp-tools.
>>>     
>> I know; wouldn't it be more suitable to put it in include/linux/sctp.h ?
>>   
> 
> include/linux/sctp.h is used by kernel source code only.

/usr/include/netinet/sctp.h is the proper place for that definition.  If
it's not used by the kernel, it has no business living in the kernel tree.

-vlad


> 
>> Regards,
>> Rami Rosen
>>
>>
>> On Thu, Jul 30, 2009 at 9:55 AM, Wei Yongjun<yjwei@cn.fujitsu.com> wrote:
>>   
>>> Rami Rosen wrote:
>>>     
>>>> Hi,
>>>> This patch removes an unused union definition (sctp_cmsg_data_t)
>>>> from include/net/sctp/user.h.
>>>>
>>>> Regards,
>>>> Rami Rosen
>>>>
>>>>
>>>> Signed-off-by: Rami Rosen <rosenrami@gmail.com>
>>>>
>>>>       
>>> sctp_cmsg_data_t  is not used by kernel source code, but it still used
>>> by lksctp-tools.
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>     
>>
>>
>>   
> 
> 

