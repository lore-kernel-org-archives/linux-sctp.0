From: Eric Dumazet <edumazet@google.com>
Date: Thu, 03 Dec 2015 14:48:45 +0000
Subject: Re: use-after-free in sctp_do_sm
Message-Id: <CANn89iKEv-q6EFi1eX+Hk_2+jNfZ0ayUqUn_Fh1U7RTs9xjdXg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+ZnWRZfQC25uW=GXHAJB=GX0L6tJQUy43P6WNR3=hwT8Q@mail.gmail.com>
	<20151203130525.GB4164@mrl.redhat.com>
	<CACT4Y+ZMshfGvb81VhCGuZzbSec2sCBaJUNFb1QQ-ccyH9BPkQ@mail.gmail.com>
In-Reply-To: <CACT4Y+ZMshfGvb81VhCGuZzbSec2sCBaJUNFb1QQ-ccyH9BPkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>

>
> No, I don't. But pr_debug always computes its arguments. See no_printk
> in printk.h. So this use-after-free happens for all users.

Hmm.

pr_debug() should be a nop unless either DEBUG or CONFIG_DYNAMIC_DEBUG are set

On our production kernels, pr_debug() is a nop.

Can you double check ? Thanks !
