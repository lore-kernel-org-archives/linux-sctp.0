From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 19 May 2020 19:47:10 +0000
Subject: Re: sctp doesn't honour net.ipv6.bindv6only
Message-Id: <20200519194710.GP2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
In-Reply-To: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

On Tue, May 19, 2020 at 10:47:17AM +0000, David Laight wrote:
> The sctp code doesn't use sk->sk_ipv6only (which is initialised
> from net.ipv6.bindv6only) but instead uses its own flag

It actually does, via [__]ipv6_only_sock() calls since 7dab83de50c7
("sctp: Support ipv6only AF_INET6 sockets.").

> sp->v4mapped which always defaults to 1.
> 
> There may also be an expectation that
>   [gs]etsockopt(sctp_fd, IPPROTO_IPV6, IPV6_V6ONLY,...)
> will access the flag that sctp uses internally.
> (Matching TCP and UDP.)

My understanding is that these are slightly different.

v4mapped, if false, will allow the socket to deal with both address
types, without mapping. If true, it will map v4 into v6.
v6only, if false, it will do mapping for tcp/udp, but sctp won't use
it. If true, it will deny using v4, which is complementary to v4mapped
for sctp.

Did I miss anything?
 
  Marcelo
