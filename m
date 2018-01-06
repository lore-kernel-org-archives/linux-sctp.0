From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 06 Jan 2018 17:02:54 +0000
Subject: Re: KASAN: use-after-free Read in sctp_packet_transmit
Message-Id: <20180106170254.GH725@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <94eb2c1fcf4cf899b405620eaa66@google.com>
In-Reply-To: <94eb2c1fcf4cf899b405620eaa66@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Fri, Jan 05, 2018 at 02:07:01PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 8a4816cad00bf14642f0ed6043b32d29a05006ce
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> Unfortunately, I don't have any reproducer for this bug yet.

How can we tell if there wasn't any list corruption messages before
the panic?

  Marcelo
