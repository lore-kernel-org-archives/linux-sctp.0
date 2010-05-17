From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 17 May 2010 14:30:51 +0000
Subject: Re: [PATCH CLEANUP] sctp: fix the comment of  sctp_sf_violation_paramlen()
Message-Id: <4BF1531B.7070703@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BF0DD56.70105@cn.fujitsu.com>
In-Reply-To: <4BF0DD56.70105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org



Shan Wei wrote:
> Wei Yongjun wrote, at 05/17/2010 02:14 PM:
>> 于 2010年05月17日 14:08, Shan Wei 写道:
>>> The comment about sctp_sf_violation_paramlen() is wrong.
>>>
>>> Invalid length should be identified as it does not equal actual length
>>> of a given parameter. The actual length of a given parameter is not including
>>> the padding part.
>>>   
>> Not right. If the param length is larger then what is request, we
>> also treat it as correct. And for unkonw params, we just check
>> the length larger then the minimal length.
> 
> From the code of sctp_verify_asconf(), I saw that if length value of any parameter in chunk
> is not equal true length, sctp_verify_asconf() return 0.
> 
> @@sctp_verify_asconf()
> 3045                 if (param.v > chunk_end - length ||
> 3046                     length < sizeof(sctp_paramhdr_t))
> 3047                         return 0;
> 

This doesn't check the 'true' length of the parameter.  It makes sure that
the length specified is at least as long as sctp_paramhdr_t (minimum length),
and not longer then the end of the chunk.  It makes no assumptions about
the actual length of the parameter.

-vlad

> 
