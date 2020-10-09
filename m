From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 09 Oct 2020 01:48:45 +0000
Subject: Re: [PATCHv2 net-next 02/17] udp6: move the mss check after udp gso tunnel processing
Message-Id: <CADvbK_en7mePKdmMaLr9V8hTdmjf2bSVpSrid2CjharJtvD6YQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602150362.git.lucien.xin@gmail.com> <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <CA+FuTScNHkYu2F2xPBjLj9ivfLRXVbTPypgjvtEZrebatpJJfQ@mail.gmail.com>
In-Reply-To: <CA+FuTScNHkYu2F2xPBjLj9ivfLRXVbTPypgjvtEZrebatpJJfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, David Miller <davem@davemloft.net>

On Thu, Oct 8, 2020 at 8:45 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 5:48 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
> > gso_size. When using UDP to encapsulate its packet, it will
> > return error in udp6_ufo_fragment() as skb->len < gso_size,
> > and it will never go to the gso tunnel processing.
> >
> > So we should move this check after udp gso tunnel processing,
> > the same as udp4_ufo_fragment() does. While at it, also tidy
> > the variables up.
>
> Please don't mix a new feature and code cleanup.
Hi, Willem,

Tidying up variables are not worth a single patch, that's what I was
thinking. I can leave the variables as it is if you wish in this patch.

>
> This patch changes almost every line of the function due to
> indentation changes. But the only relevant part is
>
> "
>         mss = skb_shinfo(skb)->gso_size;
>         if (unlikely(skb->len <= mss))
>                 goto out;
>
>         if (skb->encapsulation && skb_shinfo(skb)->gso_type &
>             (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
>                 segs = skb_udp_tunnel_segment(skb, features, true);
>         else {
>                 /* irrelevant here */
>         }
>
> out:
>         return segs;
> }
> "
>
> Is it a sufficient change to just skip the mss check if mss = GSO_BY_FRAGS?
It is sufficient.

But I think we'd better keep the code here consistent with ipv4's if
there's no other reason to do 'skb->len <= mss' check at the first.

We can go with if-else as you showed above now, then do a cleanup in
the future. What do you think?
