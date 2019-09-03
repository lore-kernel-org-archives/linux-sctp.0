From: Greg KH <greg@kroah.com>
Date: Tue, 03 Sep 2019 18:33:31 +0000
Subject: Re: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before some freeing functions is not ne
Message-Id: <20190903183331.GB26562@kroah.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
 <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
 <20190903145206.GB3499@localhost.localdomain>
In-Reply-To: <20190903145206.GB3499@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Baolin Wang <baolin.wang@linaro.org>, stable@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, arnd@arndb.de, orsonzhai@gmail.com, vincent.guittot@linaro.org, linux-kernel@vger.kernel.org

On Tue, Sep 03, 2019 at 11:52:06AM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Sep 03, 2019 at 02:58:16PM +0800, Baolin Wang wrote:
> > From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> > 
> > This patch removes NULL checks before calling kfree.
> > 
> > fixes below issues reported by coccicheck
> > net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> > net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> > net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> > net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> 
> Hi. This doesn't seem the kind of patch that should be backported to
> such old/stable releases. After all, it's just a cleanup.

I agree, this does not seem necessary _unless_ it is needed for a later
real fix.

thanks,

greg k-h
