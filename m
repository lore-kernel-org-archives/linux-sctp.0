From: Julian Anastasov <ja@ssi.bg>
Date: Wed, 21 Dec 2016 20:19:17 +0000
Subject: Re: [PATCH RFC net-next 3/7] sctp: add dst_pending_confirm flag
Message-Id: <alpine.LFD.2.11.1612212159240.1945@ja.home.ssi.bg>
List-Id: <linux-sctp.vger.kernel.org>
References: <1482094596-26046-1-git-send-email-ja@ssi.bg> <1482094596-26046-4-git-send-email-ja@ssi.bg> <20161221141108.GB23197@hmsreliant.think-freely.org>
In-Reply-To: <20161221141108.GB23197@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>


	Hello,

On Wed, 21 Dec 2016, Neil Horman wrote:

> On Sun, Dec 18, 2016 at 10:56:32PM +0200, Julian Anastasov wrote:

> > -	tp->af_specific->sctp_xmit(head, tp);
> > +	confirm = tp->dst_pending_confirm;
> > +	if (confirm)
> > +		head->dst_pending_confirm = 1;
> Why not use your confirm helper function here?

	It is for sk, I can add a skb_set_dst_pending_confirm(skb,int)
helper, if needed.

> > +	if (!t->dst_pending_confirm)
> > +		t->dst_pending_confirm = 1;
> I'm not sure why you check it for being zero before setting it here, just set it
> unilaterally instead, or are you trying to avoid dirtying a cacheline?

	Yes, no other reason. I'll change it in the next version.

Regards

--
Julian Anastasov <ja@ssi.bg>
