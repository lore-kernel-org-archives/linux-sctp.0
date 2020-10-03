From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 03 Oct 2020 04:04:28 +0000
Subject: Re: [PATCH net-next 03/15] udp: do checksum properly in skb_udp_tunnel_segment
Message-Id: <20201003040428.GC70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

On Tue, Sep 29, 2020 at 09:48:55PM +0800, Xin Long wrote:
> This patch fixes two things:
> 
>   When skb->ip_summed = CHECKSUM_PARTIAL, skb_checksum_help() should be
>   called do the checksum, instead of gso_make_checksum(), which is used
>   to do the checksum for current proto after calling skb_segment(), not
>   after the inner proto's gso_segment().
> 
>   When offload_csum is disabled, the hardware will not do the checksum
>   for the current proto, udp. So instead of calling gso_make_checksum(),
>   it should calculate checksum for udp itself.

Gotta say, this is odd. It is really flipping the two around. What
about other users of this function, did you test them too?

It makes sense to be, but would be nice if someone else could review
this.
