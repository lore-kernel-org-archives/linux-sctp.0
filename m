From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 10 Dec 2015 17:06:57 +0000
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20151210170647.GA1547@salvia>
List-Id: <linux-sctp.vger.kernel.org>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
 <20151210140625.GC3886@mrl.redhat.com>
In-Reply-To: <20151210140625.GC3886@mrl.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz

On Thu, Dec 10, 2015 at 12:06:25PM -0200, Marcelo Ricardo Leitner wrote:
> On Thu, Dec 10, 2015 at 02:42:47PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Dec 10, 2015 at 11:16:04AM -0200, Marcelo Ricardo Leitner wrote:
> >
> > You can use a mask in expectations for wildcard matching, I think
> > you're basically doing this in your patch. So it would be just one
> > single expectation for that combination with the permanent flags set
> > on. I think we may need another flag to make new conntracks
> 
> Yes
> 
> > independent from the master (IIRC currently if the master conntrack is
> > gone, related ones will be gone too and we don't want this to happen
> > in this case).
> 
> Ah yes, that too.
> 
> If such entry times out, we could promote a related entry to master,
> maybe.
>
> Because with this link in there we are able to remove all the
> entries when we see a shutdown/abort instead of leaving them to timeout.

I think in this case it doesn't make sense to have a pointer to the
master conntrack for a new sctp flow that got established via
expectation. That new sctp flow would be completely independent. I
would need to audit the core code to evaluate the impact of having a
conntrack with the IPS_EXPECTED_BIT set with no master set. It would
be good if you can investigate this.

> > > This was the main reason that I didn't use expectations.  Yet this
> > > req changed when I realized that we can't process ASCONF chunks without
> > > validating the AUTH chunk first, which we just can't just when in the middle
> > > of the communication.
> > 
> > OK, so that's why we cannot create expectations for specific
> > addresses, right?
> 
> Right. We would be trusting un-trusty data.

I see, but without IP source and destination address in the
expectation, how is this effective from a security point of view? My
concerns go in the direction of possible spoofing that result in holes
in the firewall for sctp traffic.

> > > After that went down it's just two other:
> > > - by removing the addresses from it, we have the possibility that a host may
> > > use multiple addresses but not for a single sctp association, but like
> > > running two distinct assocs, one using each IP address, but same ports, and
> > > same vtags. It could happen.. it would cause a clash as the expectation
> > > would be the same but for different masters.
> > > 
> > > - adding vtag to it increases nf_conntrack_tuple by 4 bytes, so 8 bytes per
> > > nf_conn, while this feature will be off for the majority of the
> > > installations.> > 
> > 
> > Yes, there is a bit more extra memory.
> > 
> > I think we can shrink this back by moving the expectation master
> > pointer to an extension (they are rarely used). Another one to
> > consider is secmark, I don't know of many using this but I may be wrong.
> 
> Ok

Anyway, it would be good to evaluate the performance impact on
enlarging the tuple. Not only extra memory, the hashing for lookups
will take 4 extra bytes per packet after such change.

I would need to have a look, but there must be a nice way to
accomodate this into the expectation infrastructure without having any
impact on that front. Probably we can have a per-protocol family
expectation table (instead of a global table) where the hashing to
look up for expectations depends on the protocol (so in the sctp case,
we can include the vtag from the ct->state in the hash lookup).

Just an idea, we should avoid any significant impact on performance
for everyone else just to handle this sctp multihoming case.

> > > The possibility of using RELATED is very attractive, though. Would make more
> > > sense, I think.
> > 
> > OK.
> > 
> > > The extra bytes, we might do it, but for that conflict, only if we
> > > require the usage of conntrack zones in such cases. It would work
> > > for me..
> > 
> > Not sure what you mean.
> 
> That we can go this other way if you think it's best, not a problem. :-)
> 
> For not breaking d7ee35190427 ("netfilter: nf_ct_sctp: minimal
> multihoming support"), we would still need that sysctl, something like
> 'expected_heartbeats', still defaulting to false.

You mean we need that new sysctl to explicitly enable multihoming
tracking in any case, right?

Thanks.
