From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 03 Oct 2020 07:40:05 +0000
Subject: Re: [PATCH net-next 03/15] udp: do checksum properly in skb_udp_tunnel_segment
Message-Id: <CADvbK_c4cStJcjLQr_fA=zo2d9GzRFy42LkeeY3_CVYu7RxGug@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com> <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <20201003040428.GC70998@localhost.localdomain>
In-Reply-To: <20201003040428.GC70998@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem <davem@davemloft.net>, tom@herbertland.com

On Sat, Oct 3, 2020 at 12:04 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:48:55PM +0800, Xin Long wrote:
> > This patch fixes two things:
> >
> >   When skb->ip_summed = CHECKSUM_PARTIAL, skb_checksum_help() should be
> >   called do the checksum, instead of gso_make_checksum(), which is used
> >   to do the checksum for current proto after calling skb_segment(), not
> >   after the inner proto's gso_segment().
> >
> >   When offload_csum is disabled, the hardware will not do the checksum
> >   for the current proto, udp. So instead of calling gso_make_checksum(),
> >   it should calculate checksum for udp itself.
>
> Gotta say, this is odd. It is really flipping the two around. What
> about other users of this function, did you test them too?
Not yet, I couldn't found other cases to trigger this.

But I think gso_make_checksum() is not correct to be used here,
as it's trying to calculate the checksum for inner protocol
instead of UDP's. It should be skb_checksum_help(), like on
the xmit path.

>
> It makes sense to be, but would be nice if someone else could review
> this.
Fix the mail of Tom Herbert, and he is the right person to review this.
