From: Wenwen Wang <wang6495@umn.edu>
Date: Thu, 03 May 2018 13:43:03 +0000
Subject: Re: [PATCH] sctp: fix a potential missing-check bug
Message-Id: <CAAa=b7d-jws4=DC9SQ=JL-UZtV+1=AMYCe9feXk3y2H8p3xLzg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1525310145-28102-1-git-send-email-wang6495@umn.edu>
 <20180503012402.GK5105@localhost.localdomain> <CAAa=b7f+dfDUZR7tHvmSQgTcNDmGjvCn9ZK9eevKGF+bNd2Aqg@mail.gmail.com>
 <20180503014838.GL5105@localhost.localdomain> <CAAa=b7eebr23Pjs2LE0Ri0=gki8ZDAbLmfPWOqzWHO0i6E2aNA@mail.gmail.com>
 <20180503124629.GM5105@localhost.localdomain> <CAAa=b7dvAFnVbFuMuUsCfEUJiKFgbW0UoNSuHEXwmVPdb_pWuA@mail.gmail.com>
 <20180503133945.GN5105@localhost.localdomain>
In-Reply-To: <20180503133945.GN5105@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Kangjie Lu <kjlu@umn.edu>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Wenwen Wang <wang6495@umn.edu>

On Thu, May 3, 2018 at 8:39 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Thu, May 03, 2018 at 08:31:28AM -0500, Wenwen Wang wrote:
>> On Thu, May 3, 2018 at 7:46 AM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>> > On Thu, May 03, 2018 at 07:01:51AM -0500, Wenwen Wang wrote:
>> >> On Wed, May 2, 2018 at 8:48 PM, Marcelo Ricardo Leitner
>> >> <marcelo.leitner@gmail.com> wrote:
>> >> > On Wed, May 02, 2018 at 08:27:05PM -0500, Wenwen Wang wrote:
>> >> >> On Wed, May 2, 2018 at 8:24 PM, Marcelo Ricardo Leitner
>> >> >> <marcelo.leitner@gmail.com> wrote:
>> >> >> > On Wed, May 02, 2018 at 08:15:45PM -0500, Wenwen Wang wrote:
>> >> >> >> In sctp_setsockopt_maxseg(), the integer 'val' is compared against min_len
>> >> >> >> and max_len to check whether it is in the appropriate range. If it is not,
>> >> >> >> an error code -EINVAL will be returned. This is enforced by a security
>> >> >> >> check. But, this check is only executed when 'val' is not 0. In fact, if
>> >> >> >> 'val' is 0, it will be assigned with a new value (if the return value of
>> >> >> >> the function sctp_id2assoc() is not 0) in the following execution. However,
>> >> >> >> this new value of 'val' is not checked before it is used to assigned to
>> >> >> >> asoc->user_frag. That means it is possible that the new value of 'val'
>> >> >> >> could be out of the expected range. This can cause security issues
>> >> >> >> such as buffer overflows, e.g., the new value of 'val' is used as an index
>> >> >> >> to access a buffer.
>> >> >> >>
>> >> >> >> This patch inserts a check for the new value of 'val' to see if it is in
>> >> >> >> the expected range. If it is not, an error code -EINVAL will be returned.
>> >> >> >>
>> >> >> >> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
>> >> >> >> ---
>> >> >> >>  net/sctp/socket.c | 22 +++++++++++-----------
>> >> >> >>  1 file changed, 11 insertions(+), 11 deletions(-)
>> >> >> >
>> >> >> > ?
>> >> >> > This patch is the same as previous one. git send-email <old file>
>> >> >> > maybe?
>> >> >> >
>> >> >> >   Marcelo
>> >> >>
>> >> >> Thanks for your suggestion, Marcelo. I can send the old file. But, I
>> >> >> have added a line of comment in this patch.
>> >> >
>> >> > I meant if you had sent the old patch again by accident, because you
>> >> > said you worked on an old version of the tree, but then posted a patch
>> >> > that also doesn't use the new MTU function I mentioned.
>> >> >
>> >> >   Marcelo
>> >>
>> >> I worked on the latest kernel. But, I didn't find the MTU function
>> >> sctp_mtu_payload().
>> >
>> > Which tree are you using?
>> > [a] git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
>> >    or
>> > [b] git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>> > ?
>> >
>> > The function isn't on [a] yet, but it is on [b].
>> >
>> >   Marcelo
>>
>> Many thanks for your patience, Marcelo :)
>>
>> The tree I am working on is:
>> git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>
> Ahh! That explains the discrepancy :)
> For networking patches, please refer to
> Documentation/networking/netdev-FAQ.txt
> It describes what the 2 trees I pointed out are and how they should be
> used.
> In short, both net and net-next are always newer than the one you're
> using for networking subsystem.
>
> Regards,
> Marcelo

I see now. Will work on the new networking trees. Thanks!

Wenwen
