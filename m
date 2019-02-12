From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 12 Feb 2019 19:19:20 +0000
Subject: Re: KASAN: use-after-free Read in sctp_outq_tail
Message-Id: <20190212191920.GI10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000002015db0581b71858@google.com>
In-Reply-To: <0000000000002015db0581b71858@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Tue, Feb 12, 2019 at 11:04:27AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    d4104460aec1 Add linux-next specific files for 20190211
> git tree:       linux-next

I can't find this commit. How can I know for sure which commits are in?
Recent patches are involved with this code, but not sure what was
included on the test.

  Marcelo
