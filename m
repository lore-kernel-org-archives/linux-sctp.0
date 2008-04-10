From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 10 Apr 2008 12:55:03 +0000
Subject: Re: [PATCH] SCTP: remove useless function sctp_auth_asoc_get_hmac()
Message-Id: <47FE0E27.9070807@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <47F33EAE.3000408@cn.fujitsu.com>
In-Reply-To: <47F33EAE.3000408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

David Miller wrote:
> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> Date: Wed, 02 Apr 2008 16:07:10 +0800
> 
>> Since we have do a strict check of HMAC-ALGO parameter while establish 
>> the association, the function sctp_auth_asoc_get_hmac() become useless.
>>
>> This patch remove function sctp_auth_asoc_get_hmac().
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> After your change nothing uses the default_hmac_id any longer.
> 
> Surely it is useful for some purpose?
> 

Hi David

Yes, it is still useful and still used in the patch

> +    hmac_desc = sctp_auth_get_hmac(asoc->default_hmac_id); 

However, this patch depends on another patch:

[SCTP]: Add check for hmac_algo parameter in sctp_verify_param()

That I have queued and was verifying along with some others.

I'll send them out today.

-vlad
