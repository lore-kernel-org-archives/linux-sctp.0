From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Fri, 03 Jan 2014 15:33:48 +0000
Subject: [lksctp-tools] [1.0.15] Regression test broken due to test_1_to_1_sockopt - SO_SNDBUF
Message-Id: <52C6D85C.2020407@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello sctp folks, 

sctp regression suite is currently broken due to test_1_to_1_sockopt.

Problem is following:

TEST17 sets SO_SNDBUF to 2048

TEST18 gets SO_SNDBUF, expected is 2x2048, but obtained value is 4480

> test_1_to_1_sockopt.c 17 PASS : setsockopt() SO_SNDBUF - SUCCESS
> test_1_to_1_sockopt.c 18 PASS : getsockopt() SO_SNDBUF - SUCCESS
> test_1_to_1_sockopt.c 19 BROK : Comparison failed:Set value and got value differs Set Value@96 Get ValueD80

reason lies is net/core/sock.c

> 	case SO_SNDBUF:
> 		/* Don't error on this BSD doesn't and if you think
> 		 * about it this is right. Otherwise apps have to
> 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
> 		 * are treated in BSD as hints
> 		 */
> 		val = min_t(u32, val, sysctl_wmem_max);
> set_sndbuf:
> 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
> 		sk->sk_sndbuf = max_t(u32, val * 2, SOCK_MIN_SNDBUF);

since SOCK_MIN_SNDBUF is defined as:

include/net/sock.h
> /* Since sk_{r,w}mem_alloc sums skb->truesize, even a small frame might
>  * need sizeof(sk_buff) + MTU + padding, unless net driver perform copybreak.
>  * Note: for send buffers, TCP works better if we can build two skbs at
>  * minimum.
>  */
> #define TCP_SKB_MIN_TRUESIZE	(2048 + SKB_DATA_ALIGN(sizeof(struct sk_buff)))
> 
> #define SOCK_MIN_SNDBUF		(TCP_SKB_MIN_TRUESIZE * 2)
> #define SOCK_MIN_RCVBUF		 TCP_SKB_MIN_TRUESIZE

we can observe that value for which we set SO_SNDBUF in TEST17 in test_1_to_1_sockopt.c needs to be increased

Version is visible in subject, 1.0.15, I hope http://sourceforge.net/projects/lksctp/files/ is still valid place to get it.

Best regards,

Matija
 
PS: happy new year!
