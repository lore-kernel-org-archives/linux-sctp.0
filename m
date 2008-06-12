From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Jun 2008 15:07:16 +0000
Subject: Re: [PATCH] SCTP: enable cookie-echo retransmission transport switch
Message-Id: <48513BA4.9030403@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4850A7F2.6090906@cn.fujitsu.com>
In-Reply-To: <4850A7F2.6090906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>

Gui Jianfeng wrote:
> Vlad,
> This patch enables cookie-echo retransmission transport switch
> feature. If COOKIE-ECHO retransmission happens, it will be sent 
> to the address other than the one last sent to.
> 

NAK.

You can't blindly choose a different transport since they could
be unconfirmed and can't really be used until we confirm them
with HBs.  So, you can only do this when the user issued an
sctp_connectx() and we have multiple confirmed transports.

In this case only confirmed transports are allowed, otherwise
there is a possibility of hijacking associations.


Also, looking at this, the same problem exists in current
code for selection INIT transports.

We don't correctly treat peers passed to connectx() as confirmed
and don't select the correct transport.

Once you fix that above, you can just re-use the function and
re-use init_last_sent_to.

-vlad

