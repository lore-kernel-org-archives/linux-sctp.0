From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 01 Feb 2019 00:39:41 +0000
Subject: Re: [PATCHv2 net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <20190201003941.GD10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <8a5df8eb5cc41dfc3d08e294147b9729bbe90aa0.1543473776.git.lucien.xin@gmail.com>
 <20190129120531.GC10665@localhost.localdomain>
 <1689af9c618.2807.d241da8dbb85b87157d6a44ac288e71f@tuxdriver.com>
In-Reply-To: <1689af9c618.2807.d241da8dbb85b87157d6a44ac288e71f@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tuxdriver <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Tue, Jan 29, 2019 at 07:58:07PM +0100, Tuxdriver wrote:
> I was initially under the impression that with Kent's repost, the radixtree
> (which is what I think you meant by rhashtables) updates would be merged

Oops! Yep.. I had meant flex_arrays actually.

> imminently, but that doesn't seem to be the case.  I'd really like to know
> what the hold up there is, as that patch seems to have been stalled for
> months.  I hate the notion of breaking the radixtree patch, but if it's
> status is indeterminate, then, yes, we probably need to go with xins patch
> for the short term, and let Kent fix it up in due course.

Dave, can you please consider applying this patch? The conflict
resolution will be easy: just ignore the changes introduced by this
patch.

This is the radixtree converstion:
https://lwn.net/ml/linux-kernel/20181217131929.11727-1-kent.overstreet@gmail.com/
Seems that went to a limbo after
https://lwn.net/ml/linux-kernel/20181217210021.GA7144@kmo-pixel/
Maybe Kent should have reposted, but he didn't reply either.

My reasoning is below. Just please also notice that this is
triggerable by users and remotely, as remote peers may request to add
'in' streams and that implies in adding 'out' streams on local peer.
(https://tools.ietf.org/html/rfc6525#section-5.2.6)

> 
> Neil
> 
> On January 29, 2019 1:06:33 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> 
> > On Thu, Nov 29, 2018 at 02:42:56PM +0800, Xin Long wrote:
> > > Now when using stream reconfig to add out streams, stream->out
> > > will get re-allocated, and all old streams' information will
> > > be copied to the new ones and the old ones will be freed.
> > > 
> > > So without stream->out_curr updated, next time when trying to
> > > send from stream->out_curr stream, a panic would be caused.
> > > 
> > > This patch is to check and update stream->out_curr when
> > > allocating stream_out.
> > > 
> > > v1->v2:
> > >   - define fa_index() to get elem index from stream->out_curr.
> > > 
> > > Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> > > Reported-by: Ying Xu <yinxu@redhat.com>
> > > Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > 
> > We are sort of mixing things up here. We have a bug on SCTP stack that
> > triggers panics. As good practices recommends, the code should be as
> > generic as possible and the SCTP-only was dropped in favor of a more
> > generic one, fixing rhashtables instead. Okay. But then we discovered
> > rhashtables are going away and we are now waiting on a restructing
> > to fix the panic. That's not good, especially because it cannot and
> > should not be backported into -stable trees.
> > 
> > That said, we should not wait for the restructuring to _implicitly_
> > fix the bug. We should pursuit both fixes here:
> > - Apply this patch, to fix SCTP stack and allow it to be easily
> >  backportable.
> > - Apply the generic fix, which is the restructuring, whenever it
> >  actually lands.
> > 
> > Thoughts?
> > 
> > Thanks,
> > Marcelo
> 
> 
> Sent with AquaMail for Android
> https://www.mobisystems.com/aqua-mail
> 
> 
