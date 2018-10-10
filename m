From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 10 Oct 2018 15:28:12 +0000
Subject: Re: KASAN: use-after-free Read in sctp_id2assoc
Message-Id: <CACT4Y+YVRWSF+VyoBB1vwDevt0gwZYz69bSAivmZDG6r4J-kaA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000007e767d05776336da@google.com> <20181005145855.GB6761@localhost.localdomain>
In-Reply-To: <20181005145855.GB6761@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+c7dd55d7aec49d48e49a@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>

On Fri, Oct 5, 2018 at 4:58 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Thu, Oct 04, 2018 at 01:48:03AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    4e6d47206c32 tls: Add support for inplace records encryp=
tion
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13834b81400000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=E569aa5632ebd4=
36
>> dashboard link: https://syzkaller.appspot.com/bug?extid=C7dd55d7aec49d48=
e49a
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commi=
t:
>> Reported-by: syzbot+c7dd55d7aec49d48e49a@syzkaller.appspotmail.com
>>
>> netlink: 'syz-executor1': attribute type 1 has an invalid length.
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: use-after-free in sctp_id2assoc+0x3a7/0x3e0
>> net/sctp/socket.c:276
>> Read of size 8 at addr ffff880195b3eb20 by task syz-executor2/15454
>>
>> CPU: 1 PID: 15454 Comm: syz-executor2 Not tainted 4.19.0-rc5+ #242
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
>>  print_address_description.cold.8+0x9/0x1ff mm/kasan/report.c:256
>>  kasan_report_error mm/kasan/report.c:354 [inline]
>>  kasan_report.cold.9+0x242/0x309 mm/kasan/report.c:412
>>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
>>  sctp_id2assoc+0x3a7/0x3e0 net/sctp/socket.c:276
>
> I'm not seeing yet how this could happen.
> All sockopts here are serialized by sock_lock.
> do_peeloff here would create another socket, but the issue was
> triggered before that.
> The same function that freed this memory, also removes the entry from
> idr mapping, so this entry shouldn't be there anymore.
>
> I have only two theories so far:
> - an issue with IDR/RCU.
> - something else happened that just the call stacks are not revealing.

The "asoc->base.sk !=3D sk" check after idr_find suggests that we don't
actually know what sock it belongs to. And if we don't know then
locking this sock can't help keeping another sock association alive.
Am I missing something obvious here? Should we take assoc ref while we
are still holding sctp_assocs_id_lock?
