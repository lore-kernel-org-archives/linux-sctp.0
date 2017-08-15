From: David Miller <davem@davemloft.net>
Date: Tue, 15 Aug 2017 02:40:51 +0000
Subject: Re: [PATCH v2] sctp: fully initialize the IPv6 address in sctp_v6_to_addr()
Message-Id: <20170814.194051.1408830683580606508.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170814184304.82747-1-glider@google.com>
        <CAPA1RqDzSs3LogN+z69Ba2yoE6=jniobC-tEGd3TTh3z=39qxg@mail.gmail.com>
        <20170815015814.GB18688@localhost.localdomain>
In-Reply-To: <20170815015814.GB18688@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: hideaki.yoshifuji@miraclelinux.com, glider@google.com, dvyukov@google.com, kcc@google.com, edumazet@google.com, lucien.xin@gmail.com, vyasevich@gmail.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, yoshfuji@linux-ipv6.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 Aug 2017 22:58:14 -0300

> On Tue, Aug 15, 2017 at 10:43:59AM +0900, 吉藤英明 wrote:
>> > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
>> > index 2a186b201ad2..a15d691829c6 100644
>> > --- a/net/sctp/ipv6.c
>> > +++ b/net/sctp/ipv6.c
>> > @@ -513,6 +513,8 @@ static void sctp_v6_to_addr(union sctp_addr *addr, struct in6_addr *saddr,
>> >         addr->sa.sa_family = AF_INET6;
>> >         addr->v6.sin6_port = port;
>> >         addr->v6.sin6_addr = *saddr;
>> > +       addr->v6.sin6_flowinfo = 0;
>> > +       addr->v6.sin6_scope_id = 0;
>> 
>> Please set flowinfo between port and addr.
> 
> Why?

Store buffer compression.

You want to always initialize structure member in the order
they are in memory.

No, the compiler won't do this automatically.
