From: David Miller <davem@davemloft.net>
Date: Tue, 27 Nov 2018 23:42:48 +0000
Subject: Re: [PATCH net] sctp: increase sk_wmem_alloc when head->truesize is increased
Message-Id: <20181127.154248.292898274922488309.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4989c666f6077526983b02615cad001748d2e658.1543215164.git.lucien.xin@gmail.com>
In-Reply-To: <4989c666f6077526983b02615cad001748d2e658.1543215164.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Nov 2018 14:52:44 +0800

> I changed to count sk_wmem_alloc by skb truesize instead of 1 to
> fix the sk_wmem_alloc leak caused by later truesize's change in
> xfrm in Commit 02968ccf0125 ("sctp: count sk_wmem_alloc by skb
> truesize in sctp_packet_transmit").
> 
> But I should have also increased sk_wmem_alloc when head->truesize
> is increased in sctp_packet_gso_append() as xfrm does. Otherwise,
> sctp gso packet will cause sk_wmem_alloc underflow.
> 
> Fixes: 02968ccf0125 ("sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
