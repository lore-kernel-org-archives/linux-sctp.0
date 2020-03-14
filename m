From: Qiujun Huang <anenbupt@gmail.com>
Date: Sat, 14 Mar 2020 02:54:12 +0000
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-Id: <CADG63jCSHu7dQ118GEuhXBi0H4CW3cBqB5F2qKiyeVzNb0U+wg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

#syz test: https://github.com/hqj/hqjagain_test.git scup_wfree
