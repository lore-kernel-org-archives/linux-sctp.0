From: David Miller <davem@davemloft.net>
Date: Mon, 19 Dec 2011 20:10:04 +0000
Subject: Re: [PATCH] sctp: Do not account for sizeof(struct sk_buff) in
Message-Id: <20111219.151004.851224380823448122.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1324303900-8360-1-git-send-email-tgraf@redhat.com>
In-Reply-To: <1324303900-8360-1-git-send-email-tgraf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tgraf@redhat.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Thomas Graf <tgraf@redhat.com>
Date: Mon, 19 Dec 2011 15:11:40 +0100

> When checking whether a DATA chunk fits into the estimated rwnd a
> full sizeof(struct sk_buff) is added to the needed chunk size. This
> quickly exhausts the available rwnd space and leads to packets being
> sent which are much below the PMTU limit. This can lead to much worse
> performance.
 ...

Vlad, please review this.

Thanks.
