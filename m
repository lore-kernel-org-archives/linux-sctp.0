From: David Miller <davem@davemloft.net>
Date: Thu, 28 Jan 2016 23:59:59 +0000
Subject: Re: [PATCH net 0/3] fix the transport dead race check by using atomic_add_unless on refcnt
Message-Id: <20160128.155959.916092147593687503.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1453398443.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1453398443.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 22 Jan 2016 01:49:06 +0800

> Xin Long (3):
>   sctp: fix the transport dead race check by using atomic_add_unless on
>     refcnt
>   sctp: hold transport before we access t->asoc in sctp proc
>   sctp: remove the dead field of sctp_transport

Applied, thanks.
