From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 03 Mar 2010 04:58:41 +0000
Subject: Re: [BUG] sctp failed to load transform for hmac(md5)
Message-Id: <4B8DEC81.8000304@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B8B83DF.4090705@cn.fujitsu.com>
In-Reply-To: <4B8B83DF.4090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Herbert Xu wrote:
> On Tue, Mar 02, 2010 at 09:50:31AM +0800, Wei Yongjun wrote:
>   
>> It is the latest git tree.
>>     
>
> OK, it was caused by the new import/export functions.
>
> This patch should fix it:
>
> commit 73691eebefb1961b4819d995e530d6254cb51769
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Mar 2 20:54:38 2010 +0800
>
>     md5: Set statesize
>     
>     As md5 now has export/import functions, it must set the attribute
>     statesize.  Otherwise anything that relies on import/export may
>     fail as they will see a zero statesize.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>   

This patch fixed the sctp's problem. Thanks.


