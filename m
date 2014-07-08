From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 08 Jul 2014 10:47:35 +0000
Subject: RE: [PATCH net-next 2/5] net: sctp: implement rfc6458, 5.3.4. SCTP_SNDINFO cmsg support
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1726E33B@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Daniel Borkmann
> On 07/07/2014 10:46 AM, David Laight wrote:
> ...
> >> @@ -1858,8 +1870,8 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
> >>   	pr_debug("%s: we have a valid association\n", __func__);
> >>
> >>   	if (!sinfo) {
> >> -		/* If the user didn't specify SNDRCVINFO, make up one with
> >> -		 * some defaults.
> >> +		/* If the user didn't specify SNDINFO/SNDRCVINFO, make up
> >> +		 * one with some defaults.
> >>   		 */
> >>   		memset(&default_sinfo, 0, sizeof(default_sinfo));
> >
> > Is this memset() needed?
> 
> This patch is not changing it, so feel free to propose one. If you zero
> out the remaining fields only used for rx, you should be able to drop it,
> but I guess all these micro-optimizations won't be that visible when we
> have much more fundamental things to solve in SCTP stack's performance.

Yes, I'm not even sure the protocol itself was designed to be code or
network bandwidth efficient.
The Linux implementation certainly doesn't give the impression of being
written for code speed. Never mind worries about cache line occupancy.

I suspect the memset/memcpy cost more than the cache line alignment issues
and gains from annotating with un/likely.

The largest gain probably comes from killing the 'command queue'.
Some actions do need deferring - for instance sending SACK should be deferred
until all the data chunks have been processed.
Once that is gone, other things might be more obvious.

	David



