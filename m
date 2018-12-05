From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 05 Dec 2018 12:34:08 +0000
Subject: Re: [PATCH net 0/3] net: add support for flex_array_resize in flex_array
Message-Id: <20181205123408.GC6752@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1543992464.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1543992464.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

On Wed, Dec 05, 2018 at 02:49:39PM +0800, Xin Long wrote:
> Without the support for the total_nr_elements's growing or shrinking
> dynamically, flex_array is not that 'flexible'. Like when users want
> to change the size, they have to redo flex_array_alloc and copy all
> the elements from the old to the new one.  The worse thing is every
> element's memory gets changed.
> 
> To implement flex_array_resize based on current code, the difficult
> thing is to process the size border of FLEX_ARRAY_BASE_BYTES_LEFT,
> where the base data memory may change to an array for the 2nd level
> data memory for growing, likewise for shrinking.
> 
> To make this part easier, we separate the base data memory and define
> FLEX_ARRAY_BASE_SIZE as a same value of FLEX_ARRAY_PART_SIZE, as Neil
> suggested.  When new size is crossing the border, the base memory is
> allocated as the array for the 2nd level data memory and its part[0]
> is pointed to the old base memory, and do the opposite for shrinking.
> 
> But it doesn't do any memory allocation or shrinking for elements in
> flex_array_resize, as which should be done by flex_array_prealloc or
> flex_array_shrink called by users.  No memory leaks can be caused by
> that.
> 
> SCTP has benefited a lot from flex_array_resize() for managing its
> stream memory so far.
> 
> Xin Long (3):
>   flex_array: make FLEX_ARRAY_BASE_SIZE the same value of
>     FLEX_ARRAY_PART_SIZE
>   flex_array: support flex_array_resize
>   sctp: fa_resize sctp stream instead of redo fa_alloc
> 
>  include/linux/flex_array.h | 40 ++++++++++-----------
>  lib/flex_array.c           | 73 ++++++++++++++++++++++++++++++++++++--
>  net/sctp/stream.c          | 87 +++++++++++++++++++++-------------------------
>  3 files changed, 130 insertions(+), 70 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
