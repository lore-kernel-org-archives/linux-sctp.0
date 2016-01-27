From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 27 Jan 2016 18:35:18 +0000
Subject: Re: [RFC PATCH net-next 1/3] skbuff: export skb_gro_receive
Message-Id: <1453919718.20722.15.camel@edumazet-glaptop2.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1453913331.git.marcelo.leitner@gmail.com>
	 <c4f95e89023018417b7daf2bcec9db8859b65eaa.1453913331.git.marcelo.leitner@gmail.com>
In-Reply-To: <c4f95e89023018417b7daf2bcec9db8859b65eaa.1453913331.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, brouer@redhat.com, alexander.duyck@gmail.com, alexei.starovoitov@gmail.com, borkmann@iogearbox.net, marek@cloudflare.com, hannes@stressinduktion.org, fw@strlen.de, pabeni@redhat.com, john.r.fastabend@intel.com, linux-sctp@vger.kernel.org

On Wed, 2016-01-27 at 15:06 -0200, Marcelo Ricardo Leitner wrote:
> sctp GSO requires it and sctp can be compiled as a module, so export
> this function.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/core/skbuff.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index b2df375ec9c2173a8132b8efa1c3062f0510284b..704b69682085dec77f3d0f990aaf0024afd705b9 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3312,6 +3312,7 @@ done:
>  	NAPI_GRO_CB(skb)->same_flow = 1;
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(skb_gro_receive);
>  
>  void __init skb_init(void)
>  {


Normally, all the offloading support belongs in vmlinux, so this export
is not needed.

For instance, we support GRO IPV6 even if IPv6 is not enabled on the
host.

Ie all these net/ipv6 files are included in vmlinux if CONFIG_INET is
enabled

ip6_offload.o tcpv6_offload.o udp_offload.o exthdrs_offload.o



