From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Feb 2019 19:28:34 +0000
Subject: Re: [PATCHv2 net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <CADvbK_eY1UePmKDPYFkhTq3mZ=T6-7QGikip3v+pjfvC_BYk2w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1689af9c618.2807.d241da8dbb85b87157d6a44ac288e71f@tuxdriver.com>
 <20190201003941.GD10665@localhost.localdomain> <20190201123118.GA5970@hmswarspite.think-freely.org>
 <20190201.103812.1527503455899125278.davem@davemloft.net>
In-Reply-To: <20190201.103812.1527503455899125278.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

On Sat, Feb 2, 2019 at 2:38 AM David Miller <davem@davemloft.net> wrote:
>
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Fri, 1 Feb 2019 07:31:18 -0500
>
> > On Thu, Jan 31, 2019 at 10:39:41PM -0200, Marcelo Ricardo Leitner wrote:
> >> On Tue, Jan 29, 2019 at 07:58:07PM +0100, Tuxdriver wrote:
> >> > I was initially under the impression that with Kent's repost, the radixtree
> >> > (which is what I think you meant by rhashtables) updates would be merged
> >>
> >> Oops! Yep.. I had meant flex_arrays actually.
> >>
> >> > imminently, but that doesn't seem to be the case.  I'd really like to know
> >> > what the hold up there is, as that patch seems to have been stalled for
> >> > months.  I hate the notion of breaking the radixtree patch, but if it's
> >> > status is indeterminate, then, yes, we probably need to go with xins patch
> >> > for the short term, and let Kent fix it up in due course.
> >>
> >> Dave, can you please consider applying this patch? The conflict
> >> resolution will be easy: just ignore the changes introduced by this
> >> patch.
> >>
> > Dave I concur with Marcelo here.  Kent was very active in getting sctp fixed up
> > to use radixtrees, but now he seems to have gone to ground, and for whatever
> > reason, no one seems interested in incorporating his patch.  Its been languising
> > for months, so I think we need to take action to secure sctp now until such time
> > as his genradix changes finally move forward.
>
> I agree, please let's get this sctp patch resubmitted and back into
> patchwork and I will apply it.
reposted.
