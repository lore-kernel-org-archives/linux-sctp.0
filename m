From: Thomas Graf <tgraf@infradead.org>
Date: Tue, 20 Dec 2011 09:39:10 +0000
Subject: Re: [PATCH] sctp: Do not account for sizeof(struct sk_buff) in
Message-Id: <20111220093910.GB21801@canuck.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPgLHd-JL8cjMBSqO5Lc5nEt42zqj8qAn+qHaM35HTmnhOHg7w@mail.gmail.com>
In-Reply-To: <CAPgLHd-JL8cjMBSqO5Lc5nEt42zqj8qAn+qHaM35HTmnhOHg7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org

On Tue, Dec 20, 2011 at 01:00:48PM +0800, Wei Yongjun wrote:
> I saw you discussed this with Vlad in old mail:
>     http://www.spinics.net/lists/linux-sctp/msg01365.html
> 
> You said you will update patch to include a per packet overhead,
> but it does not include in this patch, what's wrong with in?

It's not possible because upon retransmission of a chunk we need
to readd the overhead to the rwnd. There is no longer a reference
to a packet so we can't know how much to add. This explanation is
also in the original mail thread.
