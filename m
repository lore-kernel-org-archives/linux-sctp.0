From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 14 Jun 2010 16:36:27 +0000
Subject: Re: [PATCH 4/6] sctp multistream scheduling: extend socket API
Message-Id: <4C165A8B.1060008@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTilW6Ym_vL02rVk4QFPIC3Dr0BC12oAxdjE9RXpf@mail.gmail.com>	<4C07C927.4090901@hp.com> <AANLkTilGROAVnKE5odR6qy6LrVjPSHxkqCrPhAtHtjlQ@mail.gmail.com>
In-Reply-To: <AANLkTilGROAVnKE5odR6qy6LrVjPSHxkqCrPhAtHtjlQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yaogong Wang <ywang15@ncsu.edu>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org



Yaogong Wang wrote:

> There is an important design issue here: when should the user set this
> socket option?
> 
> My current assumption is that the user choose the scheduling algorithm
> after declaring the socket but before the establishment of any
> association. Therefore, the granularity of control is socket-based
> rather than association-based. In one-to-many style socket case, all
> associations inherit the scheduling algorithm of the socket. The
> problems with this approach are:
> 1. Cannot specify different scheduling algorithm for each association
> under the same socket
> 2. Since the option is set before the establishment of any
> association, it doesn't know how many streams would be negotiated. It
> could only consult initmsg for the intended number of outgoing
> streams.
> 
> If we go with the association-based approach, the above problems can
> be solved. But the question is: in this case, when should the user set
> this option? In one-to-many style socket, associations are implicitly
> established. There isn't a point where association is established but
> data transfer hasn't started yet so that the user can choose the
> scheduling algorithm. Any suggestion on this dilemma?

I've been thinking about this and trying to come up with scenarios of
when performing this function at association level may be useful.

The most compelling example is really in a 1-1 or peeled off case.  Currently,
one can not change the scheduling on a peeled off association and that
might be a rather useful feature.  Typically, associations are peeled
off just so that they can provide additional performance.  Such association
may wants the additional benefit of stream prioritization.

I can however see the issues on both side of this.  A good counter argument is
that if a server should provide the same level of service for a given port.
In the end, I think I'll leave it up to you.  My initial question was from the
API perspective.

Now there are some technical challenges in allowing per-association option.
a)How do we deal with changing algorithms that require additional storage?
b)What do we do with DATA that's been queued before algorithm is chosen?
There may be others ones I haven't though off yet.

The simplest answer to a) is that such operations are forbidden until the
queue is drained.  That's the simplest to implement and may not be that
bad for the application, considering we have a SENDER_DRY event that can
allow the application to control when the call is made.

As for b), we might have to go with a lobby or a 2 level queue approach.
For this, we can probably re-use the socket send queue, that can be drained
when association can send DATA.  This might be a good thing to have anyway
so that we do not waste space for streams that haven't been negotiated.

-vlad
