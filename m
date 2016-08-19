From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Aug 2016 15:16:41 +0000
Subject: Re: [PATCH net 2/2] sctp: not copying duplicate addrs to the assoc's bind address list
Message-Id: <CADvbK_fo8o1nOvo58PdrkkT6ffGv7r5NhDUazBw67mwwfcwitA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1471605833.git.lucien.xin@gmail.com> <130956b1e880eab780162a795fde156d61d4de0f.1471605833.git.lucien.xin@gmail.com>
 <20160819133001.GA3578@hmsreliant.think-freely.org>
In-Reply-To: <20160819133001.GA3578@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

> Under what valid use case will multiple interfaces have the same network
> address?
>
Hi, Neil.
I'm not sure the specific valid use case.

The point is, do we trust the sctp global addr list has no duplicate
address ? In one of users' computer, he found hundreds of duplicate
addresses in INIT_ACK packets.
(https://bugzilla.redhat.com/show_bug.cgi?id08362)

If we think NETDEV_UP/DOWN event in addrs chain always come
in pairs, I can not explain how come this issue happened.

But from sctp end, we can avoid it with this patch. after all
binding any duplicate addresses is illegal, just like what
sctp_bind does.

what do you think ?
