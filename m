From: David Miller <davem@davemloft.net>
Date: Mon, 12 Mar 2018 16:57:37 +0000
Subject: Re: [PATCH] Fix double free in sctp_sendmsg_to_asoc
Message-Id: <20180312.125737.2298514616330071416.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180312160131.13403-1-nhorman@tuxdriver.com>
In-Reply-To: <20180312160131.13403-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 12 Mar 2018 12:01:31 -0400

> syzbot/kasan detected a double free in sctp_sendmsg_to_asoc:
> BUG: KASAN: use-after-free in sctp_association_free+0x7b7/0x930
> net/sctp/associola.c:332
> Read of size 8 at addr ffff8801d8006ae0 by task syzkaller914861/4202
 ...
> This was introduced by commit:
> f84af33 sctp: factor out sctp_sendmsg_to_asoc from sctp_sendmsg
> 
> As the newly refactored function moved the wait_for_sndbuf call to a
> point after the association was connected, allowing for peeloff events
> to occur, which in turn caused wait_for_sndbuf to return -EPIPE which
> was not caught by the logic that determines if an association should be
> freed or not.
> 
> Fix it the easy way by returning the ordering of
> sctp_primitive_ASSOCIATE and sctp_wait_for_sndbuf to the old order, to
> ensure that EPIPE will not happen.
> 
> Tested by myself using the syzbot reproducers with positive results
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: davem@davemloft.net
> CC: Xin Long <lucien.xin@gmail.com>
> Reported-by: syzbot+a4e4112c3aff00c8cfd8@syzkaller.appspotmail.com

Hope this will be sent to netdev when it's ready...
