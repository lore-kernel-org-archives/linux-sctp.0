From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Fri, 20 Dec 2013 13:58:07 +0000
Subject: Re: randconfig build error with next-20131220, in net/sctp/input.c
Message-Id: <20131220135807.GE32129@order.stressinduktion.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CA+r1ZhjYQoZJQLFO=t=mtV8g4CQD5HPU1NjCcYG_HGH=L=xiZw@mail.gmail.com>
In-Reply-To: <CA+r1ZhjYQoZJQLFO=t=mtV8g4CQD5HPU1NjCcYG_HGH=L=xiZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Fri, Dec 20, 2013 at 06:51:20AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> net/sctp/input.c: In function ‘sctp_icmp_frag_needed’:
> net/sctp/input.c:392:2: error: implicit declaration of function
> ‘ip6_sk_accept_pmtu’ [-Werror=implicit-function-declaration]
>   if (!ip6_sk_accept_pmtu(sk))
>   ^
> cc1: some warnings being treated as errors
> make[2]: *** [net/sctp/input.o] Error 1

Sorry, for that. I already proposed a patch:
<http://patchwork.ozlabs.org/patch/303308/>

Greetings,

  Hannes

