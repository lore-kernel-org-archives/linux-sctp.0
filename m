From: syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Date: Sun, 22 Mar 2020 07:18:04 +0000
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-Id: <000000000000c909b405a16c5105@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <CADG63jCpZWBjtJH_rjzBjTyTfYV0z9SHf1CzT9ic0-VY5C4AiQ@mail.gmail.com>
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger cra=
sh:

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.c=
om

Tested on:

commit:         573a2520 datamsg_list
git tree:       https://github.com/hqj/hqjagain_test.git datamsg_list
kernel config:  https://syzkaller.appspot.com/x/.config?xmfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=CEa71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/=
 c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
