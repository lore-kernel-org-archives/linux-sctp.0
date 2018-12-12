From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 12 Dec 2018 12:00:15 +0000
Subject: Re: [PATCHv2 net 0/3] net: add support for flex_array_resize in flex_array
Message-Id: <20181212120015.GA7637@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1544163962.git.lucien.xin@gmail.com>
 <20181211.225000.726755542677275663.davem@davemloft.net>
In-Reply-To: <20181211.225000.726755542677275663.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, dave.hansen@linux.intel.com, rientjes@google.com, eparis@redhat.com, khorenko@virtuozzo.com

On Tue, Dec 11, 2018 at 10:50:00PM -0800, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Fri,  7 Dec 2018 14:30:32 +0800
> 
> > Without the support for the total_nr_elements's growing or shrinking
> > dynamically, flex_array is not that 'flexible'. Like when users want
> > to change the size, they have to redo flex_array_alloc and copy all
> > the elements from the old to the new one.  The worse thing is every
> > element's memory gets changed.
> > 
> > To implement flex_array_resize based on current code, the difficult
> > thing is to process the size border of FLEX_ARRAY_BASE_BYTES_LEFT,
> > where the base data memory may change to an array for the 2nd level
> > data memory for growing, likewise for shrinking.
> > 
> > To make this part easier, we separate the base data memory and define
> > FLEX_ARRAY_BASE_SIZE as a same value of FLEX_ARRAY_PART_SIZE, as Neil
> > suggested.  When new size is crossing the border, the base memory is
> > allocated as the array for the 2nd level data memory and its part[0]
> > is pointed to the old base memory, and do the opposite for shrinking.
> > 
> > But it doesn't do any memory allocation or shrinking for elements in
> > flex_array_resize, as which should be done by flex_array_prealloc or
> > flex_array_shrink called by users.  No memory leaks can be caused by
> > that.
> > 
> > SCTP has benefited a lot from flex_array_resize() for managing its
> > stream memory so far.
> > 
> > v1->v2:
> >   Cc LKML and more developers.
> 
> So I don't know what to do about this series.
> 
> One of the responses stated that it has been proposed to remove flex_array
> and I don't know what to make of that, nor can I tell if that makes this
> series inappropriate or not.
> 


I suggest xin respond to messageid 20180523011821.12165-6-kent.overstreet@gmail.com>
and send a NAK, indicating that his patch seems like it will break the build,
as, looking through it, it never removes flex_array calls from the sctp code.
If kent reposts with a conversion of the sctp code to radix trees, we're done.
If not, you can move forward with this commit.

Neil
