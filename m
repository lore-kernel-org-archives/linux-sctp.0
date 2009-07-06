From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 06 Jul 2009 13:45:01 +0000
Subject: Re: [PATCHv2] sctp: fix warning at inet_sock_destruct() while	release
Message-Id: <4A51FFDD.30108@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A518EDF.9030501@cn.fujitsu.com> <4A518F8C.2090807@cn.fujitsu.com> <20090706064957.GA16971@gondor.apana.org.au>
In-Reply-To: <20090706064957.GA16971@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

Herbert Xu wrote:
> On Mon, Jul 06, 2009 at 01:45:48PM +0800, Wei Yongjun wrote:
>> Commit 'net: Move rx skb_orphan call to where needed' broken sctp protocol
>> with warning at inet_sock_destruct(). Actually, sctp can do this right with
>> sctp_sock_rfree_frag() and sctp_skb_set_owner_r_frag() pair.
>>
>>     sctp_sock_rfree_frag(skb);
>>     sctp_skb_set_owner_r_frag(skb, newsk);
>>
>> This patch not revert the commit d55d87fdff8252d0e2f7c28c2d443aee17e9d70f,
>> instead remove the sctp_sock_rfree_frag() function.
> 
> It took me a while to understand your patch but yeah it does seem
> to be the right fix.  So essentially we were freeing the packet
> twice as my newly added skb_orphan in sctp_skb_set_owner_r is
> repeating what sctp_sock_rfree_frag has already done for the
> migration case.
> 
> While your patch simply eliminates sctp_sock_rfree_frag so that
> we only free things once.
>  

Yep, I agree.

>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

> 
> Thanks,

