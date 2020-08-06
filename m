From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 06 Aug 2020 22:21:25 +0000
Subject: Re: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Message-Id: <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-26-hch@lst.de>
In-Reply-To: <20200723060908.50081-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org, mptcp@lists.01.org, lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org, Stefan Schmidt <stefan@datenfreihafen.org>



On 7/22/20 11:09 PM, Christoph Hellwig wrote:
> Rework the remaining setsockopt code to pass a sockptr_t instead of a
> plain user pointer.  This removes the last remaining set_fs(KERNEL_DS)
> outside of architecture specific code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org> [ieee802154]
> ---


...

> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 594e01ad670aa6..874f01cd7aec42 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -972,13 +972,13 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  }
>  

...

>  static int do_rawv6_setsockopt(struct sock *sk, int level, int optname,
> -			    char __user *optval, unsigned int optlen)
> +			       sockptr_t optval, unsigned int optlen)
>  {
>  	struct raw6_sock *rp = raw6_sk(sk);
>  	int val;
>  
> -	if (get_user(val, (int __user *)optval))
> +	if (copy_from_sockptr(&val, optval, sizeof(val)))
>  		return -EFAULT;
>  

converting get_user(...)   to  copy_from_sockptr(...) really assumed the optlen
has been validated to be >= sizeof(int) earlier.

Which is not always the case, for example here.

User application can fool us passing optlen=0, and a user pointer of exactly TASK_SIZE-1
