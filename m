From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Wed, 05 Jun 2019 16:13:19 +0000
Subject: Re: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
Message-Id: <20190605091319.000054e9@intel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
        <20190605142428.84784-3-wangkefeng.wang@huawei.com>
In-Reply-To: <20190605142428.84784-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, jesse.brandeburg@intel.com

On Wed, 5 Jun 2019 22:24:26 +0800 Kefeng wrote:
> IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag,
> so no need to do that again from its callers. Drop it.
> 

<snip>

>  	segs = __skb_gso_segment(skb, features, false);
> -	if (unlikely(IS_ERR_OR_NULL(segs))) {
> +	if (IS_ERR_OR_NULL(segs)) {
>  		int segs_nr = skb_shinfo(skb)->gso_segs;
>  

The change itself seems reasonable, but did you check to see if the
paths changed are faster/slower with your fix?  Did you look at any
assembly output to see if the compiler actually generated different
code?  Is there a set of similar changes somewhere else in the kernel
we can refer to?

I'm not sure in the end that the change is worth it, so would like you
to prove it is, unless davem overrides me. :-)
