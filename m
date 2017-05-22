From: Davide Caratti <dcaratti@redhat.com>
Date: Mon, 22 May 2017 16:09:16 +0000
Subject: Re: [PATCH net] sctp: fix ICMP processing if skb is non-linear
Message-Id: <1495469356.5672.6.camel@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cb2535a6a40a84684f26d7c7d26788cc3f8a2010.1495207495.git.dcaratti@redhat.com>
         <CADvbK_c81ju-D6h4TLm5_Lxvkaiw69Lt9TXR3Z_8gOJpQdXpXQ@mail.gmail.com>
In-Reply-To: <CADvbK_c81ju-D6h4TLm5_Lxvkaiw69Lt9TXR3Z_8gOJpQdXpXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>

hello Xin Long,
On Sat, 2017-05-20 at 02:40 +0800, Xin Long wrote:
> On Fri, May 19, 2017 at 11:34 PM, Davide Caratti <dcaratti@redhat.com> wrote:
> > @@ -515,14 +515,23 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
> >          * or the chunk type or the Initiate Tag does not match, silently
> >          * discard the packet.
> >          */
> > +       offset = skb_transport_offset(skb);
> > +       sctphdr = skb_header_pointer(skb, offset, sizeof(_sctphdr), &_sctphdr);
> > +       if (unlikely(!sctphdr))
> > +               goto out;
> > +
> > +       vtag = ntohl(sctphdr->vtag);
> >         if (vtag = 0) {
> > -               chunkhdr = (void *)sctphdr + sizeof(struct sctphdr);
> > -               if (len < sizeof(struct sctphdr) + sizeof(sctp_chunkhdr_t)
> > -                         + sizeof(__be32) ||
> > +               offset += sizeof(_sctphdr);
> 
> will be nice to delete this line, and use
> > +               /* chunk header + first 4 octects of init header */
> > +               chunkhdr = skb_header_pointer(skb, offset,
> 
> chunkhdr = skb_header_pointer(skb, offset + sizeof(_sctphdr), ;)
> wdyt?

that's right, 'offset' does not need the re-assignment: I will post the v2
soon. Thanks!

--
davide
