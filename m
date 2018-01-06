From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Sat, 06 Jan 2018 17:29:15 +0000
Subject: Re: KASAN: use-after-free Read in sctp_packet_transmit
Message-Id: <CAOJe8K0XkGCd198eYdR2EHPcTWrT8pUsuVFomubJv3anpzEBgw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <94eb2c1fcf4cf899b405620eaa66@google.com>
In-Reply-To: <94eb2c1fcf4cf899b405620eaa66@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On 1/5/18, syzbot <syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzkaller hit the following crash on
> 8a4816cad00bf14642f0ed6043b32d29a05006ce
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> Unfortunately, I don't have any reproducer for this bug yet.
>
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> =================================
> BUG: KASAN: use-after-free in sctp_packet_transmit+0x3505/0x3750
> net/sctp/output.c:643
> Read of size 8 at addr ffff8801bda9fb80 by task modprobe/23740
>

This can be related to the following corruption during send:
 #6 [ffff8805945ff940] invalid_op at ffffffff8100c15b
    [exception RIP: sctp_chunk_put+91]
    RIP: ffffffffa039db3b  RSP: ffff8805945ff9f8  RFLAGS: 00010212
    RAX: ffff8808b025cb01  RBX: ffff880dbb1b0d80  RCX: ffff8805945ff818
    RDX: 0000000000000020  RSI: ffff8809a84746d8  RDI: ffff880dbb1b0d80
    RBP: ffff8805945ffa08   R8: ffff880dbb13a0c0   R9: 0000000000000000
    R10: ffff880000023820  R11: 0000000000000000  R12: ffff880dbb1b0d80
    R13: 0000000000000000  R14: ffff8808b025cb80  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff8805945ffa10] sctp_datamsg_put at ffffffffa039c543 [sctp]
 #8 [ffff8805945ffa60] sctp_datamsg_free at ffffffffa039c9dd [sctp]
 #9 [ffff8805945ffa80] sctp_sendmsg at ffffffffa03a9440 [sctp]
#10 [ffff8805945ffb70] inet_sendmsg at ffffffff814ef0ba
#11 [ffff8805945ffbb0] sock_sendmsg at ffffffff8146b4c7
#12 [ffff8805945ffd60] __sys_sendmsg at ffffffff8146b976
#13 [ffff8805945fff10] sys_sendmsg at ffffffff8146bb99

In this case we have the chunk with 0 refcounter:
struct sctp_chunk {
  list = {
    next = 0xffff8809a84746d8,
    prev = 0xffff880dbb1b0e80
  },
  refcnt = {
    counter = 0
  },
  transmitted_list = {
    next = 0xffff880dbb1b0d98,
    prev = 0xffff880dbb1b0d98
  },
  frag_list = {
    next = 0xffff880dbb1b0da8,
    prev = 0xffff880dbb1b0da8
  },
  skb = 0xffff880dbb1a4700,
  param_hdr = {
    v = 0x0,
    p = 0x0,
    life = 0x0,
    dns = 0x0,
    cookie = 0x0,
....

Previous chunk in the list has the refcounter set to 2:
struct sctp_chunk {
  list = {
    next = 0xffff880dbb1b0d80,
    prev = 0xffff880c657160c0
  },
  refcnt = {
    counter = 2
  },
  transmitted_list = {
    next = 0xffff880dbb1b0e98,
    prev = 0xffff880dbb1b0e98
  },
  frag_list = {
    next = 0xffff8808b025c300,
    prev = 0xffff8808b025c300
  },
  skb = 0xffff880dbb1a4840,
  param_hdr = {
    v = 0x0,
    p = 0x0,
    life = 0x0,
    dns = 0x0,
    cookie = 0x0,
...
