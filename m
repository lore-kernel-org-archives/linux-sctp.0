From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 17 May 2010 07:55:04 +0000
Subject: Re: [PATCH CLEANUP] sctp: fix the comment of  sctp_sf_violation_paramlen()
Message-Id: <4BF0F658.5040305@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BF0DD56.70105@cn.fujitsu.com>
In-Reply-To: <4BF0DD56.70105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote, at 05/17/2010 02:14 PM:
> 
> 于 2010年05月17日 14:08, Shan Wei 写道:
>> The comment about sctp_sf_violation_paramlen() is wrong.
>>
>> Invalid length should be identified as it does not equal actual length
>> of a given parameter. The actual length of a given parameter is not including
>> the padding part.
>>   
> 
> Not right. If the param length is larger then what is request, we
> also treat it as correct. And for unkonw params, we just check
> the length larger then the minimal length.

From the code of sctp_verify_asconf(), I saw that if length value of any parameter in chunk
is not equal true length, sctp_verify_asconf() return 0.

@@sctp_verify_asconf()
3045                 if (param.v > chunk_end - length ||
3046                     length < sizeof(sctp_paramhdr_t))
3047                         return 0;


-- 
Best Regards
-----
Shan Wei

