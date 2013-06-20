From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 20 Jun 2013 13:24:30 +0000
Subject: Re: [PATCH net-next 0/5] Further SCTP changes
Message-Id: <20130620132430.GA17872@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371545720-22950-1-git-send-email-dborkman@redhat.com>
 <20130619.183903.2165829460238667637.davem@davemloft.net>
In-Reply-To: <20130619.183903.2165829460238667637.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Wed, Jun 19, 2013 at 06:39:03PM -0700, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Tue, 18 Jun 2013 10:55:15 +0200
> 
> > Mostly it's all about getting rid of unnecessary code, and/or making
> > it more clean and readable.
> > 
> > Code has been tested with lksctp-tools functional test suite and
> > also my small sctp stress test helper that was used to discover
> > the recent null-ptr derefs. This test was also sucessfully run against
> > auth_enabled=0 and auth_enabled=1, where I also previously applied
> > the following two patches:
> > 
> >   - http://marc.info/?l=linux-crypto-vger&m7121898331017&w=2
> >     -> not yet applied, still pending review for crypto tree
> >   - 1abd165 (net: sctp: fix NULL pointer dereference in socket destruction)
> >     -> cherry picked from net tree
> > 
> > Daniel Borkmann (5):
> >   net: sctp: remove TEST_FRAME ifdef
> >   ktime: add ms_to_ktime() and ktime_add_ms() helpers
> >   net: sctp: migrate cookie life from timeval to ktime
> >   net: sctp: decouple cleaning socket data from endpoint
> >   net: sctp: minor: sctp_seq_dump_local_addrs add missing newline
> 
> The discussion of this patch series has taken a tangent towards a
> talk about how to do TX based socket accounting differently.
> 
> While that's interesting, it'd be good to get ACKs for Daniel's
> patches meanwhile, I think they are fine personally.
Yeah, given that the sk_wmem_alloc thing has been clarified for me, it looks ok
to me

For the series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
