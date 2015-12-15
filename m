From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 15 Dec 2015 02:31:46 +0000
Subject: Re: Kernel crypto framework, sleeping-in-atomic issues
Message-Id: <566F7B92.3080103@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACzeOEegCN+pXaa6vM8QQrbRDD=iDaXOQyg=5JCUU9T6zQ5j1g@mail.gmail.com>
In-Reply-To: <CACzeOEegCN+pXaa6vM8QQrbRDD=iDaXOQyg=5JCUU9T6zQ5j1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/10/2015 10:49 AM, Fabrizio Demaria wrote:
> Hello,
> 
> I am investigating the current usage of kernel crypto-libraries in the
> SCTP code, considering to adopt the same crypto framework for the
> MPTCP implementation.
> 
> In sm_make_chunk.c, the crypto function "crypto_hash_setkey" is called
> in an atomic context, despite the fact that this function CAN invoke a
> GFP_KERNEL (sleeping) memory allocation. Calling a sleeping function
> from an atomic context can end up in deadlock. Has this factor been
> considered when adding the crypto functions into the SCTP code or has
> it been safely handled/verified in any way?

That code has been in use since the very beginning and we've never seen
any atomicity issues.  I think the reason for this is that we are only
using the sha1 hash code which doesn't seem to provide its own setkey
function.  What I think it's using is the hmac version of setkey (I could
be wrong here...) and that doesn't actually allocate any memory.

-vlad

> 
> 
> Thanks,
> Fabrizio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

