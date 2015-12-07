From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 07 Dec 2015 14:44:49 +0000
Subject: Re: use-after-free in ip6_xmit
Message-Id: <CACT4Y+bGbGT4jA1XKG3_2e8eQgC=oD79FkXEiyELg2UcMZMqMA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+aJdFhzX-QKQR3ZNZ=MHPoNQdoS6arFaVn0c4GgUzfb0g@mail.gmail.com>
 <1449498980.25029.57.camel@edumazet-glaptop2.roam.corp.google.com> <1449499144.25029.59.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1449499144.25029.59.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>

Yes, seems to be fixed on master of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git. Just
can't pull in all fixes from all trees. Sorry.
When will it be merged into Linus tree?



On Mon, Dec 7, 2015 at 3:39 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Mon, 2015-12-07 at 06:36 -0800, Eric Dumazet wrote:
>
>
>> Thanks
>>
>
> Also note that Dave Jones reported a SCTP problem fixed by :
>
> https://patchwork.ozlabs.org/patch/553068/
>
>
