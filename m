From: David Miller <davem@davemloft.net>
Date: Wed, 11 Apr 2018 16:40:43 +0000
Subject: Re: [PATCH net] sctp: do not check port in sctp_inet6_cmp_addr
Message-Id: <20180411.124043.1093527105189345576.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180411143607.GA4141@hmswarspite.think-freely.org>
        <20180411145910.GC3711@localhost.localdomain>
        <CADvbK_egknPZCHRkZoLZ2MuGhRyaYKcMCaqG9Apt=QJ3-o-D6A@mail.gmail.com>
In-Reply-To: <CADvbK_egknPZCHRkZoLZ2MuGhRyaYKcMCaqG9Apt=QJ3-o-D6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: marcelo.leitner@gmail.com, nhorman@tuxdriver.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 12 Apr 2018 00:16:58 +0800

> What do you think of:
> 
> static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
>                             const union sctp_addr *addr2)
> {
>         return __sctp_v6_cmp_addr(addr1, addr2) &&
>                addr1->v6.sin_port = addr2->v6.sin_port;
> }
> 
> (v6.sin_port and v4.sin_port have the same offset in union sctp_addr,
>  we've exploited this in many places in SCTP)

From my perspective this is OK.
