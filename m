From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 07 Dec 2017 11:07:49 +0000
Subject: Re: [PATCH net-next 00/12] sctp: Implement Stream Interleave: The I-DATA Chunk Supporting User Messa
Message-Id: <20171207110749.GA32093@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <20171205173005.GB3328@localhost.localdomain>
 <CADvbK_ck6w7T-fT9TSYQ2qKx0DGFB_5zkad6JvNLj7FQFxypzg@mail.gmail.com>
 <20171206152001.GB10595@hmswarspite.think-freely.org>
In-Reply-To: <20171206152001.GB10595@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>

On Wed, Dec 06, 2017 at 10:20:01AM -0500, Neil Horman wrote:
> On Wed, Dec 06, 2017 at 11:21:46AM +0800, Xin Long wrote:
> > On Wed, Dec 6, 2017 at 1:30 AM, Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > > On Tue, Dec 05, 2017 at 11:15:57PM +0800, Xin Long wrote:
> > >> Stream Interleave would be Implemented in two Parts:
> > >>    1. The I-DATA Chunk Supporting User Message Interleaving
> > >>    2. Interaction with Other SCTP Extensions
> > >>
> > >
> > > I have reviewed this patchset a couple of times already before the
> > > posting and other than the missing blank line (heh), it looks good to
> > > me. Would ack it now but we'll need a respin for the newline.
> > OK, thanks !
> > 
> > >
> > > Xin, please wait a bit before respining it. Maybe Neil and others have
> > > more comments on it.
> > Sure,
> > 
> > I added the part 2 (Interaction with Other SCTP Extensions) only
> > as an attachment here, so that it would be more clear to know the
> > big picture by checking it. (patchset_2.tar.gz)
> > 
> > 
> > I also added the test cases here I've done, based on sctp-tests
> > (conformance.tar.gz). It includes:
> > idata with ulp layer process
> > idata with stream reconfig
> > idata with stream scheduler
> > idata with sctp prsctp
> > idata with auth
> > 
> > (idata with sctp-tests others old tests)
> > 
> > and note that another file (debug.tar.gz) is some patches for sctp
> > to make these tests easier to be done.
> 
> 
> 
> Thanks, I'll look at this shortly
> Neil
> 
> 

Given the follow on patchset, I think this all looks pretty good.

For the series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

