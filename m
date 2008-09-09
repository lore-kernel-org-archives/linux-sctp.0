From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 09 Sep 2008 00:48:14 +0000
Subject: Re: [PATCH] sctp: Fix kernel panic while process protocol violation
Message-Id: <48C5C7CE.6040709@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48C47CBC.3000405@cn.fujitsu.com>
In-Reply-To: <48C47CBC.3000405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> Since call to function sctp_sf_abort_violation() need paramter 'arg' with
>> 'struct sctp_chunk' type, it will read the chunk type and chunk length from
>> the chunk_hdr member of chunk. But call to sctp_sf_violation_paramlen()
>> always with 'struct sctp_paramhdr' type's parameter, it will be passed to
>> sctp_sf_abort_violation(). This may cause kernel panic.
>>
>>    sctp_sf_violation_paramlen()
>>      |-- sctp_sf_abort_violation()
>>         |-- sctp_make_abort_violation()
>>
>> This patch fixed this problem by add a new paramter 'struct sctp_paramhdr'
>> to sctp_make_abort_violation(), if param is not NULL, encode phdr with
>> param,
>> if param is NULL, encode phdr with chunk.
>>
>> This patch also fix two place which called sctp_sf_violation_paramlen()
>> with
>> wrong paramter type.
>>     
>
> GAK!!!  Thanks for finding this.
>
> I am not sure I am very happy this approach though...
>
> sctp_sf_violation_paramlen() is only used in processing of ascof/asconf_ack,
> so changing generic ABORT generation to track another argument is not the
> cleanest solution...
>
> In addition, we also have sctp_process_inv_paramlength() which is almost
> the same thing as sctp_sf_violation_paramlen().  So, I think it would
> be a good idea to have this code cleaned up and merged into a single
> function that can be called from both palaces.
>
> Part of the problem is that INIT processing expects an error chunk instead
> of the abort.  However, it's being rather dense in that regard and should
> be taught how to handle both.
>
> Once that happens, sctp_process_inv_paramlength() can start returning
> an ABORT chunk back just like sctp_sf_violation_paramlen().  An once
> that happens, we can call this one function from everywhere.
>   

I'll have a try, thanks.

Wei Yongjun

