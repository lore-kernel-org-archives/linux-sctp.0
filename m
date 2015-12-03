From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 03 Dec 2015 15:55:44 +0000
Subject: Re: use-after-free in sctp_do_sm
Message-Id: <CACT4Y+bgeqS05zqkAHkxzAP7fuvFSkeEybwDTizw6Gp8KK28Fw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+ZnWRZfQC25uW=GXHAJB=GX0L6tJQUy43P6WNR3=hwT8Q@mail.gmail.com>
 <20151203130525.GB4164@mrl.redhat.com> <CACT4Y+ZMshfGvb81VhCGuZzbSec2sCBaJUNFb1QQ-ccyH9BPkQ@mail.gmail.com>
 <CANn89iKEv-q6EFi1eX+Hk_2+jNfZ0ayUqUn_Fh1U7RTs9xjdXg@mail.gmail.com>
In-Reply-To: <CANn89iKEv-q6EFi1eX+Hk_2+jNfZ0ayUqUn_Fh1U7RTs9xjdXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>

On Thu, Dec 3, 2015 at 3:48 PM, Eric Dumazet <edumazet@google.com> wrote:
>>
>> No, I don't. But pr_debug always computes its arguments. See no_printk
>> in printk.h. So this use-after-free happens for all users.
>
> Hmm.
>
> pr_debug() should be a nop unless either DEBUG or CONFIG_DYNAMIC_DEBUG are set
>
> On our production kernels, pr_debug() is a nop.
>
> Can you double check ? Thanks !


Why should it be nop? no_printk thing in printk.h pretty much
explicitly makes it not a nop...

Double-checked: debug_post_sfx leads to some generated code:

        debug_post_sfx();
ffffffff8229f256:       48 8b 85 58 fe ff ff    mov    -0x1a8(%rbp),%rax
ffffffff8229f25d:       48 85 c0                test   %rax,%rax
ffffffff8229f260:       74 24                   je
ffffffff8229f286 <sctp_do_sm+0x176>
ffffffff8229f262:       8b b0 a8 00 00 00       mov    0xa8(%rax),%esi
ffffffff8229f268:       48 8b 85 60 fe ff ff    mov    -0x1a0(%rbp),%rax
ffffffff8229f26f:       44 89 85 74 fe ff ff    mov    %r8d,-0x18c(%rbp)
ffffffff8229f276:       48 8b 78 20             mov    0x20(%rax),%rdi
ffffffff8229f27a:       e8 71 28 01 00          callq
ffffffff822b1af0 <sctp_id2assoc>
ffffffff8229f27f:       44 8b 85 74 fe ff ff    mov    -0x18c(%rbp),%r8d

        return error;
}
ffffffff8229f286:       48 81 c4 a0 01 00 00    add    $0x1a0,%rsp
ffffffff8229f28d:       44 89 c0                mov    %r8d,%eax
ffffffff8229f290:       5b                      pop    %rbx
ffffffff8229f291:       41 5c                   pop    %r12
ffffffff8229f293:       41 5d                   pop    %r13
ffffffff8229f295:       41 5e                   pop    %r14
ffffffff8229f297:       41 5f                   pop    %r15
ffffffff8229f299:       5d                      pop    %rbp
ffffffff8229f29a:       c3                      retq
