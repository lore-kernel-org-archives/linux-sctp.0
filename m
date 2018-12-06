From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 06 Dec 2018 05:48:40 +0000
Subject: Re: [PATCH net 1/3] flex_array: make FLEX_ARRAY_BASE_SIZE the same value of FLEX_ARRAY_PART_SIZE
Message-Id: <CADvbK_fLgF7gAj=FagHcw+bkMVGahKF4_Bcc+JaZdALT2DXf5g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1543992464.git.lucien.xin@gmail.com> <afecf0734c4f583e9179d2b2e069b969647f29bb.1543992464.git.lucien.xin@gmail.com>
 <20181205.203836.864527645836497612.davem@davemloft.net>
In-Reply-To: <20181205.203836.864527645836497612.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

On Thu, Dec 6, 2018 at 1:38 PM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Wed,  5 Dec 2018 14:49:40 +0800
>
> > This patch is to separate the base data memory from struct flex_array and
> > save it into a page. With this change, total_nr_elements of a flex_array
> > can grow or shrink without having the old element's memory changed when
> > the new size of the flex_arry crosses FLEX_ARRAY_BASE_SIZE, which will
> > be added in the next patch.
> >
> > Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> This needs to be reviewed by the flex array hackers and lkml.
>
> It can't just get reviewed on netdev alone.
Will repost with CCing lkml and
the author:
  "Dave Hansen <dave.hansen@linux.intel.com>"
and two contributors:
  "David Rientjes <rientjes@google.com>", "Eric Paris <eparis@redhat.com>"

Thanks.
