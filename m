From: David Miller <davem@davemloft.net>
Date: Thu, 06 Jun 2019 00:14:48 +0000
Subject: Re: [PATCH V2] Fix memory leak in sctp_process_init
Message-Id: <20190605.171448.1980183910828510087.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000097abb90589e804fd@google.com>
        <20190603203259.21508-1-nhorman@tuxdriver.com>
In-Reply-To: <20190603203259.21508-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon,  3 Jun 2019 16:32:59 -0400

> syzbot found the following leak in sctp_process_init
> BUG: memory leak
> unreferenced object 0xffff88810ef68400 (size 1024):
 ...
> The problem was that the peer.cookie value points to an skb allocated
> area on the first pass through this function, at which point it is
> overwritten with a heap allocated value, but in certain cases, where a
> COOKIE_ECHO chunk is included in the packet, a second pass through
> sctp_process_init is made, where the cookie value is re-allocated,
> leaking the first allocation.
> 
> Fix is to always allocate the cookie value, and free it when we are done
> using it.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com

Applied and queued up for -stable.
