From: David Miller <davem@davemloft.net>
Date: Sun, 06 Dec 2015 03:24:00 +0000
Subject: Re: [PATCH net 0/3] sctp: packet timestamp fixes
Message-Id: <20151205.222400.709085792565221050.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20151203184316.GF4164@mrl.redhat.com>
	<cover.1449249050.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1449249050.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, eric.dumazet@gmail.com, syzkaller@googlegroups.com, linux-sctp@vger.kernel.org, kcc@google.com, glider@google.com, sasha.levin@oracle.com, maze@google.com, dvyukov@google.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri,  4 Dec 2015 15:14:02 -0200

> These a couple of fixes regarding sctp/packet timestamps.
> 
> Dmitry Vyukov <dvyukov@google.com> reported the counter leak on missing
> net_enable_timestamp() (2nd patch) and further testing here revealed the
> other two issues.
> 
> Please consider these to -stable.

Thanks for this, applied and queued up for -stable.
