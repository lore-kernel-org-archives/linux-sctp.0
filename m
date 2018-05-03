From: Wenwen Wang <wang6495@umn.edu>
Date: Thu, 03 May 2018 12:01:51 +0000
Subject: Re: [PATCH] sctp: fix a potential missing-check bug
Message-Id: <CAAa=b7eebr23Pjs2LE0Ri0=gki8ZDAbLmfPWOqzWHO0i6E2aNA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1525310145-28102-1-git-send-email-wang6495@umn.edu>
 <20180503012402.GK5105@localhost.localdomain> <CAAa=b7f+dfDUZR7tHvmSQgTcNDmGjvCn9ZK9eevKGF+bNd2Aqg@mail.gmail.com>
 <20180503014838.GL5105@localhost.localdomain>
In-Reply-To: <20180503014838.GL5105@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Kangjie Lu <kjlu@umn.edu>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Wenwen Wang <wang6495@umn.edu>

On Wed, May 2, 2018 at 8:48 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, May 02, 2018 at 08:27:05PM -0500, Wenwen Wang wrote:
>> On Wed, May 2, 2018 at 8:24 PM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>> > On Wed, May 02, 2018 at 08:15:45PM -0500, Wenwen Wang wrote:
>> >> In sctp_setsockopt_maxseg(), the integer 'val' is compared against min_len
>> >> and max_len to check whether it is in the appropriate range. If it is not,
>> >> an error code -EINVAL will be returned. This is enforced by a security
>> >> check. But, this check is only executed when 'val' is not 0. In fact, if
>> >> 'val' is 0, it will be assigned with a new value (if the return value of
>> >> the function sctp_id2assoc() is not 0) in the following execution. However,
>> >> this new value of 'val' is not checked before it is used to assigned to
>> >> asoc->user_frag. That means it is possible that the new value of 'val'
>> >> could be out of the expected range. This can cause security issues
>> >> such as buffer overflows, e.g., the new value of 'val' is used as an index
>> >> to access a buffer.
>> >>
>> >> This patch inserts a check for the new value of 'val' to see if it is in
>> >> the expected range. If it is not, an error code -EINVAL will be returned.
>> >>
>> >> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
>> >> ---
>> >>  net/sctp/socket.c | 22 +++++++++++-----------
>> >>  1 file changed, 11 insertions(+), 11 deletions(-)
>> >
>> > ?
>> > This patch is the same as previous one. git send-email <old file>
>> > maybe?
>> >
>> >   Marcelo
>>
>> Thanks for your suggestion, Marcelo. I can send the old file. But, I
>> have added a line of comment in this patch.
>
> I meant if you had sent the old patch again by accident, because you
> said you worked on an old version of the tree, but then posted a patch
> that also doesn't use the new MTU function I mentioned.
>
>   Marcelo

I worked on the latest kernel. But, I didn't find the MTU function
sctp_mtu_payload().

The problematic function that I found is sctp_setsockopt_maxseg()
located in the file net/sctp/socket.c.

Thanks,

Wenwen
