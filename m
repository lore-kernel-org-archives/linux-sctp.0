From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 11 Apr 2013 17:30:32 +0000
Subject: Re: [PATCH] sctp: Add buffer utilization fields to /proc/net/sctp/assocs
Message-Id: <20130411173032.GF8986@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BC2A2E3B1AB5441B4415258B8908D4D10DBD103@G2W2530.americas.hpqcorp.net>
In-Reply-To: <4BC2A2E3B1AB5441B4415258B8908D4D10DBD103@G2W2530.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Apr 11, 2013 at 01:04:59PM -0400, Dilip Daya wrote:
> Hi Neil,
> 
> On Thu, 2013-04-11 at 09:28 -0400, Neil Horman wrote:
> > On Wed, Apr 10, 2013 at 09:02:19PM +0000, Daya, Dilip (Telco Linux) wrote:
> > > From: Dilip Daya <dilip.daya@hp.com>
> > > 
> > > This patch adds the following fields to /proc/net/sctp/assocs output:
> > > 
> > > 	- sk->sk_wmem_alloc      (transmit queue bytes committed)
> > > 	- sk->sk_wmem_queued  (persistent queue size)
> > > 	- sk->sk_sndbuf              (size of send buffer in bytes)
> > > 	- sk->sk_rcvbuf               (size of receive buffer in bytes)
> > > 
> > > When small DATA chunks containing 136 bytes data are sent the TX_QUEUE 
> > > (assoc->sndbuf_used) reaches a maximum of 40.9% of sk_sndbuf value when
> > > peer.rwnd = 0. This was diagnosed from sk_wmem_alloc value reaching maximum
> > > value of sk_sndbuf.
> > > 
> > > TX_QUEUE (assoc->sndbuf_used), sk_wmem_alloc and sk_wmem_queued values are
> > > incremented in sctp_set_owner_w() for outgoing data chunks. Having access to
> > > the above values in /proc/net/sctp/assocs will provide a better understanding
> > > of SCTP buffer management.
> > > 
> > > With patch applied, example output when peer.rwnd = 0
> > > 
> > > where:
> > >     ASSOC ffff880132298000 is sender
> > >                  ffff880125343000 is receiver
> > > 
> > > # cat /proc/net/sctp/assocs
> > >  ASSOC           SOCK            STY SST ST  HBKT ASSOC-ID TX_QUEUE RX_QUEUE \
> > > ffff880132298000 ffff880124a0a0c0 2   1   3  29325    1      214656        0 \
> > > ffff880125343000 ffff8801237d7700 2   1   3  36210    2           0   524520 \
> > > 
> > > UID   INODE LPORT  RPORT LADDRS <-> RADDRS       HBINT   INS  OUTS \
> > >   0   25108 3455   3456  *10.4.8.3 <-> *10.5.8.3  7500     2     2 \
> > >   0   27819 3456   3455  *10.5.8.3 <-> *10.4.8.3  7500     2     2 \
> > > 
> > > MAXRT T1X  T2X     RTXC sk_wmem_alloc sk_wmem_queued sk_sndbuf sk_rcvbuf
> > >     4   0   0        72      525633         440320      524288    524288
> > >     4   0   0         0           1              0      524288    524288
> > > 
> > > 
> > > 
> > > Signed-off-by: Dilip Daya <dilip.daya@hp.com>
Its still a bit risky, but we've done it before, so I don't see a problem with
this at this point.  Thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

