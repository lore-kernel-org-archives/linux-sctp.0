From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 16 Nov 2017 04:17:48 +0000
Subject: [PATCH net] net/sctp: Always set scope_id in sctp_inet6_skb_msgname
Message-Id: <871skyzwk3.fsf_-_@xmission.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171031161445.GA140874@beast>
        <1509471094.3828.26.camel@edumazet-glaptop3.roam.corp.google.com>
        <871slikvvf.fsf@xmission.com>
        <CAGXu5jJAepjBcLki0G-fa4JNH93szZAoWWFORvo3zxPWDQLjGQ@mail.gmail.com>
        <CAG_fn=UUB6ep_hdiQq7CyGUnc93R-13mGZERyM-yi3b11hLRdQ@mail.gmail.com>
In-Reply-To: <CAG_fn=UUB6ep_hdiQq7CyGUnc93R-13mGZERyM-yi3b11hLRdQ@mail.gmail.com>
        (Alexander Potapenko's message of "Wed, 15 Nov 2017 09:22:39 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <keescook@chromium.org>, Eric Dumazet <eric.dumazet@gmail.com>, Kostya Serebryany <kcc@google.com>, Andrey Konovalov <andreyknvl@google.com>, Eric Dumazet <edumazet@google.com>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, security@kernel.org, Alexander Potapenko <glider@google.com>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>


Alexandar Potapenko while testing the kernel with KMSAN and syzkaller
discovered that in some configurations sctp would leak 4 bytes of
kernel stack.

Working with his reproducer I discovered that those 4 bytes that
are leaked is the scope id of an ipv6 address returned by recvmsg.

With a little code inspection and a shrewd guess I discovered that
sctp_inet6_skb_msgname only initializes the scope_id field for link
local ipv6 addresses to the interface index the link local address
pertains to instead of initializing the scope_id field for all ipv6
addresses.

That is almost reasonable as scope_id's are meaniningful only for link
local addresses.  Set the scope_id in all other cases to 0 which is
not a valid interface index to make it clear there is nothing useful
in the scope_id field.

There should be no danger of breaking userspace as the stack leak
guaranteed that previously meaningless random data was being returned.

Cc: stable@vger.kernel.org
Fixes: 372f525b495c ("SCTP:  Resync with LKSCTP tree.")
History-tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sctp/ipv6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index a6dfa86c0201..3b18085e3b10 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -807,9 +807,10 @@ static void sctp_inet6_skb_msgname(struct sk_buff *skb, char *msgname,
 		addr->v6.sin6_flowinfo = 0;
 		addr->v6.sin6_port = sh->source;
 		addr->v6.sin6_addr = ipv6_hdr(skb)->saddr;
-		if (ipv6_addr_type(&addr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) {
+		if (ipv6_addr_type(&addr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
 			addr->v6.sin6_scope_id = sctp_v6_skb_iif(skb);
-		}
+		else
+			addr->v6.sin6_scope_id = 0;
 	}
 
 	*addr_len = sctp_v6_addr_to_user(sctp_sk(skb->sk), addr);
-- 
2.14.1

