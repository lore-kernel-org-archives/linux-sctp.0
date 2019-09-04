From: Baolin Wang <baolin.wang@linaro.org>
Date: Wed, 04 Sep 2019 02:38:40 +0000
Subject: Re: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before some freeing functions is not ne
Message-Id: <CAMz4kuJMfAR6w+SpiTA-EWMB3MQ_wiuW+_-DfL-8zdrCagmS0Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1567492316.git.baolin.wang@linaro.org> <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
 <20190903145206.GB3499@localhost.localdomain> <20190903183331.GB26562@kroah.com>
In-Reply-To: <20190903183331.GB26562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <greg@kroah.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "# 3.4.x" <stable@vger.kernel.org>, vyasevich@gmail.com, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org, Networking <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Orson Zhai <orsonzhai@gmail.com>, Vincent Guittot <vincent.guittot@linaro.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, 4 Sep 2019 at 02:33, Greg KH <greg@kroah.com> wrote:
>
> On Tue, Sep 03, 2019 at 11:52:06AM -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, Sep 03, 2019 at 02:58:16PM +0800, Baolin Wang wrote:
> > > From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> > >
> > > This patch removes NULL checks before calling kfree.
> > >
> > > fixes below issues reported by coccicheck
> > > net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> > > net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> > > net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> > > net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> >
> > Hi. This doesn't seem the kind of patch that should be backported to
> > such old/stable releases. After all, it's just a cleanup.
>
> I agree, this does not seem necessary _unless_ it is needed for a later
> real fix.

It can remove warnings from our product kernel since this patch
(c4964bfaf433 sctp: Free cookie before we memdup a new one) was merged
into stable, we still need backport it to our product kernel manually.

But if you still think this is unnecessary, please ignore this patch.
Thanks for your comments.

-- 
Baolin Wang
Best Regards
