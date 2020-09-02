From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 Sep 2020 14:58:35 +0000
Subject: Re: [PATCH] sctp: Honour SCTP_PARTIAL_DELIVERY_POINT even under memory pressure
Message-Id: <20200902145835.GC2444@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200901090007.31061-1-oss@malat.biz>
In-Reply-To: <20200901090007.31061-1-oss@malat.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Petr Malat <oss@malat.biz>
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org

On Tue, Sep 01, 2020 at 11:00:07AM +0200, Petr Malat wrote:
> Command SCTP_CMD_PART_DELIVER issued under memory pressure calls
> sctp_ulpq_partial_delivery(), which tries to fetch and partially deliver
> the first message it finds without checking if the message is longer than
> SCTP_PARTIAL_DELIVERY_POINT. According to the RFC 6458 paragraph 8.1.21.
> such a behavior is invalid. Fix it by returning the first message only if
> its part currently available is longer than SCTP_PARTIAL_DELIVERY_POINT.

Okay but AFAICT this patch then violates the basic idea behind partial
delivery. It will cause such small message to just not be delivered
anymore, and keep using the receive buffer which it is trying to free
some bits at this moment.

Btw, you also need to Cc netdev@vger.kernel.org for patches to
actually get applied by DaveM.

  Marcelo
