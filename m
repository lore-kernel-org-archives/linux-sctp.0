From: Qiujun Huang <anenbupt@gmail.com>
Date: Sun, 22 Mar 2020 06:41:02 +0000
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-Id: <CADG63jCpZWBjtJH_rjzBjTyTfYV0z9SHf1CzT9ic0-VY5C4AiQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADG63jB59ZXWSUFKieXKGGEbPT9=z5OPARBjGqMgfh+K-k4-yQ@mail.gmail.com>
 <0000000000000f2eea05a16a1979@google.com>
In-Reply-To: <0000000000000f2eea05a16a1979@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

#syz test: https://github.com/hqj/hqjagain_test.git datamsg_list
