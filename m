From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:34 +0000
Subject: [PATCH 00/13] lib/generic-radix-tree: genradix bug fix and optimisations.
Message-Id: <21289d79b0474811b21ed8478c465159@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

The genradix code is used by SCTP for accessing per-stream data.
This means there are quite a lot of lookups but the code wasn't
really optimised at all.

Patch 1 fixes a rather nasty bug that could cause all sorts of oddities
including having a loop in a tree.
Fortunately the only 2 users of the genradix code in the kernel source
tree and neither can possibly hit the bug.

Patches 2 through 11 all reduce codepath. Especially for the common
case (for both users) where all the data fits in one page.

Patch 12 inlines the common lookup function for 1 page trees.
This also remove the '% constant' calcuation from the lookups.
However it will increase code size (but not codepath) because
of the number of callers.

Patch 13 removes part of the optimisation for 1 page tress
under the assumption that the lookup will have been inlined.
The code still works even if inlining didn't happen.

David Laight (13):
    01/13: Fix potentially corrupt tree
    02/13: Optimise out ilog2(variable).
    03/13: Always use low 8 bits of 'root' for depth.
    04/13: Optimise __genradix_ptr()
    05/13: Optimise __genradix_ptr_alloc()
    06/13: Rename gfp_mask to gfp to shorten lines.
    07/13: Optimise __genradix_iter_peek()
    08/13: Save number of bits to shift instead of tree level.
    09/13: Check sizeof(_type) when defining a tree.
    10/13: Simplify offset calculation:
    11/13: Pass the root pointer to __genradix_ptr.
    12/13: Inline genradix_ptr() for simple trees.
    13/13: Simplify __genradix_ptr()

 include/linux/generic-radix-tree.h |  54 ++++---
 lib/generic-radix-tree.c           | 224 ++++++++++++++++-------------
 2 files changed, 162 insertions(+), 116 deletions(-)

-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
