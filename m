From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 25 Apr 2018 18:10:40 +0000
Subject: Re: [PATCH net-next] sctp: fix identification of new acks for SFR-CACC
Message-Id: <20180425181039.GY4716@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <4e837f7eaf67a1a964d1b3418aa3cf759f512535.1524603870.git.marcelo.leitner@gmail.com>
 <20180425.132239.1603132652115291264.davem@davemloft.net>
In-Reply-To: <20180425.132239.1603132652115291264.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com

On Wed, Apr 25, 2018 at 01:22:39PM -0400, David Miller wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Tue, 24 Apr 2018 18:17:35 -0300
>
> > It's currently written as:
> >
> > if (!tchunk->tsn_gap_acked) {   [1]
> > 	tchunk->tsn_gap_acked = 1;
> > 	...
> > }
> >
> > if (TSN_lte(tsn, sack_ctsn)) {
> > 	if (!tchunk->tsn_gap_acked) {
> > 		/* SFR-CACC processing */
> > 		...
> > 	}
> > }
> >
> > Which causes the SFR-CACC processing on ack reception to never process,
> > as tchunk->tsn_gap_acked is always true by then. Block [1] was
> > moved to that position by the commit marked below.
> >
> > This patch fixes it by doing SFR-CACC processing earlier, before
> > tsn_gap_acked is set to true.
> >
> > Fixes: 31b02e154940 ("sctp: Failover transmitted list on transport delete")
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> >
> > Even though this is a -stable candidate, please apply it to net-next
> > to avoid conflicts with subsequent patches in my queue. Thanks.
>
> Applied.
>
> However, if you do want this to make it's way to -stable you'll have to get
> it integrated into 'net' first.

Ok. Will send an email by then.

  Marcelo
