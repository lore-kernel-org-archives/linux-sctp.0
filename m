From: Qiujun Huang <hqjagain@gmail.com>
Date: Wed, 18 Mar 2020 04:07:58 +0000
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjoeGtALzDHUS+OUJfK-JqQ_T-_RX74Opt-TLTxufVAQN7g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200317155536.10227-1-hqjagain@gmail.com> <20200317173039.GA3828@localhost.localdomain>
 <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com> <20200318035549.GC3756@localhost.localdomain>
In-Reply-To: <20200318035549.GC3756@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Wed, Mar 18, 2020 at 11:55 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Mar 18, 2020 at 10:45:51AM +0800, Qiujun Huang wrote:
>
> Hmm, not sure how you got that out of that debug msg, but okay.
> Even if so, how would this trouble skb be accounted on the wrong sk by
> then?
>
> Asking because the fix that we want may be a better locking, to
> prevent this situation from happening, than compensating for it in
> sctp_wfree(). But for that we need to understand how this happened.
>

Yes, I should find the root cause. Here is the log

[   86.507432][ T8813] [1]skb 0xffff88809fdfc800 0xffff88809621e7c0:
truesize 768, sk alloc 769 sctp_set_owner_w 137
[   86.532042][ T8813] [1]skb 0xffff888099ebbe80 0xffff88809621e7c0:
truesize 131328, sk alloc 132353 sctp_set_owner_w 137
[   86.543426][ T8813] [1]skb 0xffff88809ef55cc0 0xffff88809621e7c0:
truesize 131328, sk alloc 263937 sctp_set_owner_w 137
[   86.563229][ T8813] [1]skb 0xffff88809ef557c0 0xffff88809621e7c0:
truesize 131328, sk alloc 395521 sctp_set_owner_w 137
[   86.589332][ T8813] [1]skb 0xffff88809ef55a40 0xffff88809621e7c0:
truesize 33024, sk alloc 428801 sctp_set_owner_w 137
[   86.602211][ T8813] [1]deal with transmitted 0xffff8880910b0a80
from transport 0xffff8880910b0800  __sctp_outq_teardown, 216
[   86.616336][ T8813] [1]put back to queue 0xffff888091dc8770
sctp_check_transmitted, 1683
[   86.625610][ T8813] [1]get packet 0xffff888099ebbe80 from queue
0xffff888096b2c280  sctp_check_transmitted, 1437
[   86.637105][ T8813] [1]put skb 0xffff888099ebbe80 back.
sctp_check_transmitted, 1533
[   86.646284][ T8813] [1]put back to queue 0xffff888096b2c280
sctp_check_transmitted, 1683          ----
[   86.687575][ T8813] [1]before sk 0xffff88809621e7c0
sctp_sock_migrate, 9592                               ----I think
something wrong opens here. 0xffff888099ebbe80 not changed to newsk
[   86.696296][ T8813] [1]skb 0xffff88809ef55cc0 0xffff88809621e7c0:
truesize 131328, sk alloc 429057 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   86.721891][ T8813] [1]transmitted done queue 0xffff888091dc83d0
sctp_for_each_tx_datachunk, 166
[   86.757260][ T8813] [1]retransmit done queue 0xffff888091dc8770
sctp_for_each_tx_datachunk, 171
[   86.771065][ T8813] [1]sacked done queue 0xffff888091dc8760
sctp_for_each_tx_datachunk, 176
[   86.797487][ T8813] [1]abandoned done queue 0xffff888091dc8780
sctp_for_each_tx_datachunk, 181
[   86.814856][ T8813] [0]skb 0xffff88809ef557c0 0xffff88809621e7c0:
truesize 131328, sk alloc 297473 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   86.831799][ T8813] [0]skb 0xffff88809ef55a40 0xffff88809621e7c0:
truesize 33024, sk alloc 165889 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   86.845473][ T8813] [0]out_chunk_list done queue 0xffff888091dc8730
sctp_for_each_tx_datachunk, 186
[   86.866011][ T8813] [0]skb 0xffff88809ef55cc0 0xffff8880a3bb2800:
truesize 131328, sk alloc 131329 sctp_set_owner_w 137
[   86.884811][ T8813] [0]transmitted done queue 0xffff888091dc83d0
sctp_for_each_tx_datachunk, 166
[   86.896150][ T8813] [0]retransmit done queue 0xffff888091dc8770
sctp_for_each_tx_datachunk, 171
[   86.907233][ T8813] [0]sacked done queue 0xffff888091dc8760
sctp_for_each_tx_datachunk, 176
[   86.916825][ T8813] [0]abandoned done queue 0xffff888091dc8780
sctp_for_each_tx_datachunk, 181
[   86.927458][ T8813] [0]skb 0xffff88809ef557c0 0xffff8880a3bb2800:
truesize 131328, sk alloc 262913 sctp_set_owner_w 137
[   86.957446][ T8813] [0]skb 0xffff88809ef55a40 0xffff8880a3bb2800:
truesize 33024, sk alloc 296193 sctp_set_owner_w 137
[   86.971810][ T8813] [0]out_chunk_list done queue 0xffff888091dc8730
sctp_for_each_tx_datachunk, 186
[   86.992386][ T8813] [0]after sk 0xffff8880a3bb2800 sctp_sock_migrate, 9597
[   87.091320][ T8811] [1]deal with transmitted 0xffff8880a6f52280
from transport 0xffff8880a6f52000  __sctp_outq_teardown, 216
[   87.110552][ T8811] [1]skb 0xffff88809fdfc800 0xffff88809621e7c0:
truesize 768, sk alloc 132609 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   87.180238][ T8811] [0]deal with transmitted 0xffff888096b2c280
from transport 0xffff888096b2c000  __sctp_outq_teardown, 216
[   87.264062][ T8811] [0]skb 0xffff888099ebbe80 0xffff8880a3bb2800:
truesize 131328, sk alloc 296449 sctp_wfree 9101 real sk
0xffff88809621e7c0       --->the trouble skb
[   87.289730][ T8811] [1]skb 0xffff88809ef55cc0 0xffff8880a3bb2800:
truesize 131328, sk alloc 296193 sctp_wfree 9101 real sk
0xffff8880a3bb2800
[   87.314206][ T8811] [1]skb 0xffff88809ef557c0 0xffff8880a3bb2800:
truesize 131328, sk alloc 164609 sctp_wfree 9101 real sk
0xffff8880a3bb2800
[   87.329602][ T8811] [1]skb 0xffff88809ef55a40 0xffff8880a3bb2800:
truesize 33024, sk alloc 33025 sctp_wfree 9101 real sk
0xffff8880a3bb2800

>   Marcelo
