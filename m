From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 26 May 2018 15:36:02 +0000
Subject: Re: INFO: rcu detected stall in sctp_generate_heartbeat_event
Message-Id: <CACT4Y+bpPTOWhVw=XehkdUeHutZbdOp-eFWmhsvybsa+cPEp7A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000062c1c056bacd39f@google.com> <20180508120643.GM4977@localhost.localdomain>
In-Reply-To: <20180508120643.GM4977@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+e4a5bbd54260c93014f9@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>

On Tue, May 8, 2018 at 2:06 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Tue, May 08, 2018 at 12:35:02AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    90278871d4b0 Merge git://git.kernel.org/pub/scm/linux/ke=
rn..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=119a7237800000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=AEa320d3af5ef9=
9d
>> dashboard link: https://syzkaller.appspot.com/bug?extid=E4a5bbd54260c930=
14f9
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>
> A reproducer will be welcomed. With just these traces, I don't think
> we have enough information.


#syz fix: sctp: not allow to set rto_min with a value below 200 msecs
