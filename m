From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 03 Oct 2020 04:06:16 +0000
Subject: Re: [PATCH net-next 10/15] sctp: allow changing transport encap_port by peer packets
Message-Id: <20201003040616.GE70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

On Tue, Sep 29, 2020 at 09:49:02PM +0800, Xin Long wrote:
>  static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
>  {
> +	memset(skb->cb, 0, sizeof(skb->cb));
> +	SCTP_INPUT_CB(skb)->encap_port = ntohs(udp_hdr(skb)->source);

Here it's in host order already. The fact that is does this
transparent update probably hid the other issue.

> +
>  	skb_set_transport_header(skb, sizeof(struct udphdr));
>  	sctp_rcv(skb);
>  	return 0;
