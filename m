From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 07 Dec 2010 06:35:38 +0000
Subject: Re: [Lksctp-developers] SCTP_SET_PEER_PRIMARY_ADDR v4 mapped?
Message-Id: <4CFDD5BA.2030301@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Chris Hegarty,

> On 12/ 6/10 06:23 AM, Wei Yongjun wrote:
>>
>>> Hi,
>>>
>>> I've noticed a difference in the way SCTP_SET_PEER_PRIMARY_ADDR&
>>> SCTP_PRIMARY_ADDR socket options accept socket addresses. When setting
>>> SCTP_PRIMARY_ADDR it appears that a v4 mapped address is accepted, but
>>> when setting SCTP_SET_PEER_PRIMARY_ADDR it gives "Cannot assign
>>> requested address" as if the address is not a valid local address. But
>>> when I use the IPv4 address it appears to work as expected.
>>>
>>
>> With SCTP_SET_PEER_PRIMARY_ADDR, we checked whether
>> this address is a valid peer address, not local address. The peer
>> must have this address in its address list after estab. Also, peer
>> must support v4 mapped address.
>
> Thanks for your reply. Sorry, but I'm still confused here.
>
> "7.3.1. Set Peer Primary Address (SCTP_SET_PEER_PRIMARY_ADDR)
>
>    Requests that the peer marks the enclosed address as the association
>    primary (see [RFC5061]).  The enclosed address must be one of the
>    association's locally bound addresses."
>
> So the address passed when setting SCTP_SET_PEER_PRIMARY_ADDR must be
> one of the locally bound addresses, not the peer address, right?
>
> My question is related more to the user interface when using AF_INET6
> sockets. Why would the given address have to be an IPv4 address for
> setting SCTP_SET_PEER_PRIMARY_ADDR, but when setting SCTP_PRIMARY_ADDR
> it must be an IPv4 mapped address? I would expect the user interface
> to behave consistently across these two options.

Can you try the following patch?

[PATCH] SCTP: Fix SCTP_SET_PEER_PRIMARY_ADDR to accpet v4mapped address

SCTP_SET_PEER_PRIMARY_ADDR does not accpet v4mapped address, this
patch will fix it by map v4mapped address to v4 address if allowed.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6bd5543..0b9ee34 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2932,6 +2932,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	struct sctp_association	*asoc = NULL;
 	struct sctp_setpeerprim	prim;
 	struct sctp_chunk	*chunk;
+	struct sctp_af		*af;
 	int 			err;
 
 	sp = sctp_sk(sk);
@@ -2959,6 +2960,13 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (!sctp_state(asoc, ESTABLISHED))
 		return -ENOTCONN;
 
+	af = sctp_get_af_specific(prim.sspp_addr.ss_family);
+	if (!af)
+		return -EINVAL;
+
+	if (!af->addr_valid((union sctp_addr *)&prim.sspp_addr, sp, NULL))
+		return -EADDRNOTAVAIL;
+
 	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim.sspp_addr))
 		return -EADDRNOTAVAIL;
 
-- 
1.6.5.2


