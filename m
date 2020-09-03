From: Petr Malat <oss@malat.biz>
Date: Thu, 03 Sep 2020 11:21:48 +0000
Subject: Re: [PATCH] sctp: Honour SCTP_PARTIAL_DELIVERY_POINT even under memory pressure
Message-Id: <20200903112147.GA17627@bordel.klfree.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200901090007.31061-1-oss@malat.biz>
 <20200902145835.GC2444@localhost.localdomain>
In-Reply-To: <20200902145835.GC2444@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org

Hi!
On Wed, Sep 02, 2020 at 11:58:35AM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Sep 01, 2020 at 11:00:07AM +0200, Petr Malat wrote:
> > Command SCTP_CMD_PART_DELIVER issued under memory pressure calls
> > sctp_ulpq_partial_delivery(), which tries to fetch and partially deliver
> > the first message it finds without checking if the message is longer than
> > SCTP_PARTIAL_DELIVERY_POINT. According to the RFC 6458 paragraph 8.1.21.
> > such a behavior is invalid. Fix it by returning the first message only if
> > its part currently available is longer than SCTP_PARTIAL_DELIVERY_POINT.
> 
> Okay but AFAICT this patch then violates the basic idea behind partial
> delivery. It will cause such small message to just not be delivered
> anymore, and keep using the receive buffer which it is trying to free
> some bits at this moment.
By default the pd_point is set to 0, so there will not be a change in the
behavior, but if the user changes it to some other value, it should be
respected by the stack - for example when the largest message the user
exchanges is 1kB and the user sets it to 1kB, his application is not
prepared to handle fragmented messages at all and it's not a good idea to
pass such a message to the app.
 
> Btw, you also need to Cc netdev@vger.kernel.org for patches to
> actually get applied by DaveM.
Thanks, I will add it to this message and bounce the original patch message
as well.
  Petr
