From: syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Date: Sat, 14 Mar 2020 04:04:02 +0000
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-Id: <00000000000021721505a0c8ad76@google.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <CADG63jCSHu7dQ118GEuhXBi0H4CW3cBqB5F2qKiyeVzNb0U+wg@mail.gmail.com>
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot tried to test the proposed patch but build/boot failed:

failed to checkout kernel repo https://github.com/hqj/hqjagain_test.git/scu=
p_wfree: failed to run ["git" "fetch" "https://github.com/hqj/hqjagain_test=
.git" "scup_wfree"]: exit status 128
fatal: couldn't find remote ref scup_wfree



Tested on:

commit:         [unknown=20
git tree:       https://github.com/hqj/hqjagain_test.git scup_wfree
dashboard link: https://syzkaller.appspot.com/bug?extid=CEa71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/=
 c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
