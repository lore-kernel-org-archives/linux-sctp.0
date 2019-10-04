From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 04 Oct 2019 14:48:41 +0000
Subject: Re: [PATCH] lib/generic-radix-tree.c: add kmemleak annotations
Message-Id: <20191004144841.GI638@arrakis.emea.arm.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+aGjg_JTL-OPMSi1wS4=Zy4xFAizWW5fa8_KMOFpfMeXg@mail.gmail.com>
 <20191004065039.727564-1-ebiggers@kernel.org>
In-Reply-To: <20191004065039.727564-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, Kent Overstreet <kent.overstreet@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Thu, Oct 03, 2019 at 11:50:39PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Kmemleak is falsely reporting a leak of the slab allocation in
> sctp_stream_init_ext():
> 
> BUG: memory leak
> unreferenced object 0xffff8881114f5d80 (size 96):
>    comm "syz-executor934", pid 7160, jiffies 4294993058 (age 31.950s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000ce7a1326>] kmemleak_alloc_recursive  include/linux/kmemleak.h:55 [inline]
>      [<00000000ce7a1326>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000ce7a1326>] slab_alloc mm/slab.c:3326 [inline]
>      [<00000000ce7a1326>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>      [<000000007abb7ac9>] kmalloc include/linux/slab.h:547 [inline]
>      [<000000007abb7ac9>] kzalloc include/linux/slab.h:742 [inline]
>      [<000000007abb7ac9>] sctp_stream_init_ext+0x2b/0xa0  net/sctp/stream.c:157
>      [<0000000048ecb9c1>] sctp_sendmsg_to_asoc+0x946/0xa00  net/sctp/socket.c:1882
>      [<000000004483ca2b>] sctp_sendmsg+0x2a8/0x990 net/sctp/socket.c:2102
>      [...]
> 
> But it's freed later.  Kmemleak misses the allocation because its
> pointer is stored in the generic radix tree sctp_stream::out, and the
> generic radix tree uses raw pages which aren't tracked by kmemleak.
> 
> Fix this by adding the kmemleak hooks to the generic radix tree code.
> 
> Reported-by: syzbot+7f3b6b106be8dcdcdeec@syzkaller.appspotmail.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
