From: Qiujun Huang <hqjagain@gmail.com>
Date: Wed, 18 Mar 2020 04:22:59 +0000
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjofnjzO9ZZ12Ccxz1gBDiDt5Kt=E7Z2q4=vpcwY5AkOB9A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200317155536.10227-1-hqjagain@gmail.com> <20200317173039.GA3828@localhost.localdomain>
 <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com>
 <20200318035549.GC3756@localhost.localdomain> <CAJRQjoeGtALzDHUS+OUJfK-JqQ_T-_RX74Opt-TLTxufVAQN7g@mail.gmail.com>
In-Reply-To: <CAJRQjoeGtALzDHUS+OUJfK-JqQ_T-_RX74Opt-TLTxufVAQN7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

[ T8813] [1]put skb 0xffff888099ebbe80 back. sctp_check_transmitted, 1533
[ T8813] [1]put back to queue 0xffff888096b2c280 sctp_check_transmitted, 1683
Something wrong happens here, 0xffff888099ebbe80 not changed to newsk
[ T8813] [1]before sk 0xffff88809621e7c0 sctp_sock_migrate, 9592

cause

[ T8811] [0]skb 0xffff888099ebbe80 0xffff8880a3bb2800: truesize
131328, sk alloc 296449 sctp_wfree 9101
               real sk 0xffff88809621e7c0

it's sk is still oldsk.
