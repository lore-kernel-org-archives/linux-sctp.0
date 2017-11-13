From: Richard Haines <richard_c_haines@btinternet.com>
Date: Mon, 13 Nov 2017 20:50:17 +0000
Subject: Re: [RFC PATCH 4/5] netlabel: Add SCTP support
Message-Id: <1510606217.2636.4.camel@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171017135854.4343-1-richard_c_haines@btinternet.com>
	<CAHC9VhT1T+ZMreYNa33YVA-drHN=Tg6xQb4nmMWUuX+8OYO9fQ@mail.gmail.com>
In-Reply-To: <CAHC9VhT1T+ZMreYNa33YVA-drHN=Tg6xQb4nmMWUuX+8OYO9fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Mon, 2017-11-06 at 18:15 -0500, Paul Moore wrote:
> On Tue, Oct 17, 2017 at 9:58 AM, Richard Haines
> <richard_c_haines@btinternet.com> wrote:
> > Add support to label SCTP associations and cater for a situation
> > where
> > family = PF_INET6 with an ip_hdr(skb)->version = 4.
> > 
> > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > ---
> >  include/net/netlabel.h            |  3 ++
> >  net/netlabel/netlabel_kapi.c      | 80
> > +++++++++++++++++++++++++++++++++++++++
> >  net/netlabel/netlabel_unlabeled.c | 10 +++++
> >  3 files changed, 93 insertions(+)
> > 
> > diff --git a/include/net/netlabel.h b/include/net/netlabel.h
> > index 72d6435..7348966 100644
> > --- a/include/net/netlabel.h
> > +++ b/include/net/netlabel.h
> > @@ -494,6 +494,9 @@ int netlbl_conn_setattr(struct sock *sk,
> >                         const struct netlbl_lsm_secattr *secattr);
> >  int netlbl_req_setattr(struct request_sock *req,
> >                        const struct netlbl_lsm_secattr *secattr);
> > +int netlbl_sctp_setattr(struct sock *sk,
> > +                       struct sk_buff *skb,
> > +                       const struct netlbl_lsm_secattr *secattr);
> >  void netlbl_req_delattr(struct request_sock *req);
> >  int netlbl_skbuff_setattr(struct sk_buff *skb,
> >                           u16 family,
> > diff --git a/net/netlabel/netlabel_kapi.c
> > b/net/netlabel/netlabel_kapi.c
> > index ea7c670..1c82bbe 100644
> > --- a/net/netlabel/netlabel_kapi.c
> > +++ b/net/netlabel/netlabel_kapi.c
> > @@ -1121,6 +1121,7 @@ int netlbl_conn_setattr(struct sock *sk,
> >         switch (addr->sa_family) {
> >         case AF_INET:
> >                 addr4 = (struct sockaddr_in *)addr;
> > +
> 
> I'm guessing this bit of extra whitespace was an accident; but just
> in
> case, drop it from this patch please.
Done
> 
> >                 entry = netlbl_domhsh_getentry_af4(secattr->domain,
> >                                                    addr4-
> > >sin_addr.s_addr);
> >                 if (entry = NULL) {
> > @@ -1177,6 +1178,85 @@ int netlbl_conn_setattr(struct sock *sk,
> >  }
> > 
> >  /**
> > + * netlbl_sctp_setattr - Label an incoming sctp association socket
> > using
> > + * the correct protocol
> > + * @sk: the socket to label
> > + * @skb: the packet
> > + * @secattr: the security attributes
> > + *
> > + * Description:
> > + * Attach the correct label to the given socket using the security
> > attributes
> > + * specified in @secattr.  Returns zero on success, negative
> > values on failure.
> > + *
> > + */
> > +int netlbl_sctp_setattr(struct sock *sk,
> > +                       struct sk_buff *skb,
> > +                       const struct netlbl_lsm_secattr *secattr)
> > +{
> > +       int ret_val = -EINVAL;
> > +       struct netlbl_dommap_def *entry;
> > +       struct iphdr *hdr4;
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +       struct ipv6hdr *hdr6;
> > +#endif
> > +
> > +       rcu_read_lock();
> > +       switch (sk->sk_family) {
> > +       case AF_INET:
> > +               hdr4 = ip_hdr(skb);
> > +
> > +               entry = netlbl_domhsh_getentry_af4(secattr->domain,
> > +                                                  hdr4->saddr);
> > +               if (entry = NULL) {
> > +                       ret_val = -ENOENT;
> > +                       goto sctp_setattr_return;
> > +               }
> > +               switch (entry->type) {
> > +               case NETLBL_NLTYPE_CIPSOV4:
> > +                       ret_val = cipso_v4_sock_setattr(sk, entry-
> > >cipso,
> > +                                                       secattr);
> > +                       break;
> > +               case NETLBL_NLTYPE_UNLABELED:
> > +                       netlbl_sock_delattr(sk);
> > +                       ret_val = 0;
> > +                       break;
> > +               default:
> > +                       ret_val = -ENOENT;
> > +               }
> > +               break;
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +       case AF_INET6:
> > +               hdr6 = ipv6_hdr(skb);
> > +               entry = netlbl_domhsh_getentry_af6(secattr->domain,
> > +                                                  &hdr6->saddr);
> > +               if (entry = NULL) {
> > +                       ret_val = -ENOENT;
> > +                       goto sctp_setattr_return;
> > +               }
> > +               switch (entry->type) {
> > +               case NETLBL_NLTYPE_CALIPSO:
> > +                       ret_val = calipso_sock_setattr(sk, entry-
> > >calipso,
> > +                                                      secattr);
> > +                       break;
> > +               case NETLBL_NLTYPE_UNLABELED:
> > +                       netlbl_sock_delattr(sk);
> > +                       ret_val = 0;
> > +                       break;
> > +               default:
> > +                       ret_val = -ENOENT;
> > +               }
> > +               break;
> > +#endif /* IPv6 */
> > +       default:
> > +               ret_val = -EPROTONOSUPPORT;
> > +       }
> > +
> > +sctp_setattr_return:
> > +       rcu_read_unlock();
> > +       return ret_val;
> > +}
> 
> It seems like we should try to leverage the code in
> netlbl_conn_setattr() a bit more.  I would suggest either tweaking
> the
> callers to use a sockaddr struct and netlbl_conn_setattr(), or
> implement netlbl_sctp_setattr() as a simple wrapper around
> netlbl_conn_setattr() ... the former seems a bit cleaner, but I
> suspect patch 5/5 will make it clear which approach is better.

I've now modified selinux_netlbl_sctp_assoc_request() to extract the ip
address info from skb and add to a sockaddr struct, then call
netlbl_conn_setattr(). This removes any specific SCTP code from
netlabel_kapi.c

> 
> > diff --git a/net/netlabel/netlabel_unlabeled.c
> > b/net/netlabel/netlabel_unlabeled.c
> > index 22dc1b9..c070dfc 100644
> > --- a/net/netlabel/netlabel_unlabeled.c
> > +++ b/net/netlabel/netlabel_unlabeled.c
> > @@ -1472,6 +1472,16 @@ int netlbl_unlabel_getattr(const struct
> > sk_buff *skb,
> >                 iface = rcu_dereference(netlbl_unlhsh_def);
> >         if (iface = NULL || !iface->valid)
> >                 goto unlabel_getattr_nolabel;
> > +
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +       /* When resolving a fallback label, check the sk_buff
> > version as
> > +        * it is possible (e.g. SCTP) to have family = PF_INET6
> > while
> > +        * receiving ip_hdr(skb)->version = 4.
> > +        */
> > +       if (family = PF_INET6 && ip_hdr(skb)->version = 4)
> > +               family = PF_INET;
> > +#endif /* IPv6 */
> > +
> 
> It seems like this should be pulled out into it's own patch as a fix
> that extends beyond SCTP, what do you think?

I'll submit this as a separate NetLabel patch today.

Thanks for all your comments on the patchset, will probably take a few
weeks to respond to them all.
> 
