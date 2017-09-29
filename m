From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 Sep 2017 17:10:29 +0000
Subject: Re: [PATCH net-next 09/10] sctp: introduce priority based stream scheduler
Message-Id: <20170929171029.GB19750@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1506536044.git.marcelo.leitner@gmail.com>
 <2220047f36cd5018571ef4f87c252dde3a5a8263.1506536044.git.marcelo.leitner@gmail.com>
 <20170929165458.GB19460@hmswarspite.think-freely.org>
In-Reply-To: <20170929165458.GB19460@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>, David Laight <David.Laight@ACULAB.COM>

On Fri, Sep 29, 2017 at 12:54:58PM -0400, Neil Horman wrote:
> On Thu, Sep 28, 2017 at 05:25:22PM -0300, Marcelo Ricardo Leitner wrote:
> > This patch introduces RFC Draft ndata section 3.4 Priority Based
> > Scheduler (SCTP_SS_PRIO).
> > 
> > It works by having a struct sctp_stream_priority for each priority
> > configured. This struct is then enlisted on a queue ordered per priority
> > if, and only if, there is a stream with data queued, so that dequeueing
> > is very straightforward: either finish current datamsg or simply dequeue
> > from the highest priority queued, which is the next stream pointed, and
> > that's it.
> > 
> > If there are multiple streams assigned with the same priority and with
> > data queued, it will do round robin amongst them while respecting
> > datamsgs boundaries (when not using idata chunks), to be reasonably
> > fair.
> > 
> > We intentionally don't maintain a list of priorities nor a list of all
> > streams with the same priority to save memory. The first would mean at
> > least 2 other pointers per priority (which, for 1000 priorities, that
> > can mean 16kB) and the second would also mean 2 other pointers but per
> > stream. As SCTP supports up to 65535 streams on a given asoc, that's
> > 1MB. This impacts when giving a priority to some stream, as we have to
> > find out if the new priority is already being used and if we can free
> > the old one, and also when tearing down.
> > 
> > The new fields in struct sctp_stream_out_ext and sctp_stream are added
> > under a union because that memory is to be shared with other schedulers.
> > It could be defined as an opaque area like skb->cb, but that would make
> > the list handling a nightmare.
> > 
> > See-also: https://tools.ietf.org/html/draft-ietf-tsvwg-sctp-ndata-13
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> I presume here that it will be up to the application to rate limit its own
> throughput so as to prevent starvation of lower priority streams within an
> association?

That's my expection as well. If it cannot manage its own throughput,
then it should use another scheduler.

  Marcelo
