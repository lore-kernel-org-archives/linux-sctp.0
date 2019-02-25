From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 25 Feb 2019 13:20:44 +0000
Subject: Re: [PATCH net] sctp: get sctphdr by offset in sctp_compute_cksum
Message-Id: <CADvbK_cC4q1D5w1AHAVQjCTW4Pm6H+-ZOVg7xCp+eiOkkRJ8SQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2aee76766861ac9e46b7acf123d5d6e8f2adf8e0.1551093937.git.lucien.xin@gmail.com>
 <20190225124614.GB30699@hmswarspite.think-freely.org>
In-Reply-To: <20190225124614.GB30699@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Feb 25, 2019 at 8:47 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Mon, Feb 25, 2019 at 07:25:37PM +0800, Xin Long wrote:
> > sctp_hdr(skb) only works when skb->transport_header is set properly.
> >
> > But in the path of nf_conntrack_in: sctp_packet() -> sctp_error()
> >
> > skb->transport_header is not guaranteed to be right value for sctp.
> > It will cause to fail to check the checksum for sctp packets.
> >
> > So fix it by using offset, which is always right in all places.
> >
> > Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> > Reported-by: Li Shuang <shuali@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/sctp/checksum.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
> > index 32ee65a..1c6e6c0 100644
> > --- a/include/net/sctp/checksum.h
> > +++ b/include/net/sctp/checksum.h
> > @@ -61,7 +61,7 @@ static inline __wsum sctp_csum_combine(__wsum csum, __wsum csum2,
> >  static inline __le32 sctp_compute_cksum(const struct sk_buff *skb,
> >                                       unsigned int offset)
> >  {
> > -     struct sctphdr *sh = sctp_hdr(skb);
> > +     struct sctphdr *sh = (struct sctphdr *)(skb->data + offset);
> >       const struct skb_checksum_ops ops = {
> >               .update  = sctp_csum_update,
> >               .combine = sctp_csum_combine,
> > --
> > 2.1.0
> >
> >
> Shouldn't you use skb_set_transport_header and skb_transport_header here?
you mean:
skb_set_transport_header(skb, offset);
sh = sctp_hdr(skb);
?

There's no place counting on here to set transport_header.
It will be a kinda redundant job, yet skb is 'const'.
