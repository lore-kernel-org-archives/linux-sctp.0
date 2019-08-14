From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 14 Aug 2019 02:22:32 +0000
Subject: Re: [PATCH net] sctp: fix the transport error_count check
Message-Id: <20190813192232.02f49f1f@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <55b2fe3e5123958ccd7983e0892bc604aa717132.1565614152.git.lucien.xin@gmail.com>
        <20190813162734.GA2870@localhost.localdomain>
In-Reply-To: <20190813162734.GA2870@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Tue, 13 Aug 2019 13:27:34 -0300, Marcelo Ricardo Leitner wrote:
> On Mon, Aug 12, 2019 at 08:49:12PM +0800, Xin Long wrote:
> > As the annotation says in sctp_do_8_2_transport_strike():
> > 
> >   "If the transport error count is greater than the pf_retrans
> >    threshold, and less than pathmaxrtx ..."
> > 
> > It should be transport->error_count checked with pathmaxrxt,
> > instead of asoc->pf_retrans.
> > 
> > Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>  
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.

> Dave, please consider this one for stable. Thanks.

Ack.
