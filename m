From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 18 Dec 2008 14:32:05 +0000
Subject: Re: [PATCH] lksctp: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <494A5EE5.8020903@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
In-Reply-To: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Horacio Sanson wrote:
> On Thu, Dec 18, 2008 at 6:24 AM, Vlad Yasevich
> <vladislav.yasevich@hp.com> wrote:
>> Horacio Sanson wrote:
>>> From: Horacio Sanson <hsanson@skillupjapan.co.jp>
>>>
>>> Modified all relevant structures in all header and source files to
>>> replace the deprecated sinfo_timetolive field with the newer
>>> sinfo_pr_policy and sinfo_pr_value.
>>>
>>> Added a new sctp_sinfo_pr_policy enum that contains the different PR policy
>>> definitions: SCTP_PR_SCTP_NONE and SCTP_PR_SCTP_TTL. And modified the
>>> values of sctp_sinfo_flags so they use the higher byte only and leave the
>>> lower byte free for sctp_pr_policy values.
>> need you sign-off.
>>
> 
> Done, just added "-s" to the commit command....
> 
>>> ---
>>>  include/net/sctp/structs.h |   10 ++++++----
>>>  include/net/sctp/user.h    |   22 +++++++++++++++++-----
>>>  net/sctp/associola.c       |    3 ++-
>>>  net/sctp/chunk.c           |   30 +++++++++++++++++++-----------
>>>  net/sctp/output.c          |    2 +-
>>>  net/sctp/socket.c          |   27 ++++++++++++++-------------
>>>  net/sctp/ulpevent.c        |    3 ++-
>>>  7 files changed, 61 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>>> index 9661d7b..2a86944 100644
>>> --- a/include/net/sctp/structs.h
>>> +++ b/include/net/sctp/structs.h
>>> @@ -281,8 +281,9 @@ struct sctp_sock {
>>>       __u16 default_stream;
>>>       __u32 default_ppid;
>>>       __u16 default_flags;
>>> +     __u16 default_pr_policy;
>>>       __u32 default_context;
>>> -     __u32 default_timetolive;
>>> +     __u32 default_pr_value;
>>>       __u32 default_rcv_context;
>>>       int max_burst;
>>>
>>> @@ -626,13 +627,13 @@ struct sctp_datamsg {
>>>       struct list_head track;
>>>       /* Reference counting. */
>>>       atomic_t refcnt;
>>> +     /* Policy used to determine how expires_at is interpreted */
>>> +     unsigned long expires_policy;
>>>       /* When is this message no longer interesting to the peer? */
>>>       unsigned long expires_at;
>>>       /* Did the messenge fail to send? */
>>>       int send_error;
>>>       char send_failed;
>>> -     /* Control whether chunks from this message can be abandoned. */
>>> -     char can_abandon;
>>>  };
>>>
>>>  struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
>>> @@ -1759,9 +1760,10 @@ struct sctp_association {
>>>       /* Default send parameters. */
>>>       __u16 default_stream;
>>>       __u16 default_flags;
>>> +     __u16 default_pr_policy;
>>>       __u32 default_ppid;
>>>       __u32 default_context;
>>> -     __u32 default_timetolive;
>>> +     __u32 default_pr_value;
>>>
>>>       /* Default receive parameters */
>>>       __u32 default_rcv_context;
>>> diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
>>> index f205b10..55ecc4a 100644
>>> --- a/include/net/sctp/user.h
>>> +++ b/include/net/sctp/user.h
>>> @@ -183,9 +183,10 @@ struct sctp_sndrcvinfo {
>>>       __u16 sinfo_stream;
>>>       __u16 sinfo_ssn;
>>>       __u16 sinfo_flags;
>>> +     __u16 sinfo_pr_policy;
>>>       __u32 sinfo_ppid;
>>>       __u32 sinfo_context;
>>> -     __u32 sinfo_timetolive;
>>> +     __u32 sinfo_pr_value;
>>>       __u32 sinfo_tsn;
>>>       __u32 sinfo_cumtsn;
>>>       sctp_assoc_t sinfo_assoc_id;
>>> @@ -199,12 +200,23 @@ struct sctp_sndrcvinfo {
>>>   */
>>>
>>>  enum sctp_sinfo_flags {
>>> -     SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
>>> -     SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
>>> -     SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
>>> -     SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */
>>> +     SCTP_EOF       = MSG_FIN,    /* Initiate graceful shutdown process. (0x0200) */
>>> +     SCTP_UNORDERED = 0x0400,     /* Send/receive message unordered. */
>>> +     SCTP_ADDR_OVER = 0x0800,     /* Override the primary destination. */
>>> +     SCTP_ABORT     = 0x1000,     /* Send an ABORT message to the peer. */
>>>  };
>>>
>> Why?
> 
> These values, except for SCTP_EOF, are exactly the same values used in
> the FreeBSD implementation. This scheme allows the lower byte to be
> used for sctp_sinfo_pr_policy values.
> 
> I modified all these flags so they coincide with FreeBSD
> implementation that is also the same code base used for MacOSX and
> Windows implementations to avoid any incompatibilities between
> implementations. At least sinfo_pr_policy is transported between peers
> in an association and having standard values is a good idea.

Buy you don't use it as such.  You have a separate __u16 defined.to carry
pr_policy.  So before we had a structure:

struct sctp_sndrcvinfo {
        __u16 sinfo_stream;
        __u16 sinfo_ssn;
        __u16 sinfo_flags;
                             <---- 16bit memory hole
        __u32 sinfo_ppid;
        __u32 sinfo_context;
        __u32 sinfo_timetolive;
        __u32 sinfo_tsn;
        __u32 sinfo_cumtsn;
        sctp_assoc_t sinfo_assoc_id;
};

and now we have a structure
struct sctp_sndrcvinfo {
        __u16 sinfo_stream;
        __u16 sinfo_ssn;
        __u16 sinfo_flags;
        __u16 sinfo_pr_policy;      <---- hole filled
        __u32 sinfo_ppid;
        __u32 sinfo_context;
        __u32 sinfo_pr_value;
        __u32 sinfo_tsn;
        __u32 sinfo_cumtsn;
        sctp_assoc_t sinfo_assoc_id;
};

So, I am trying to find the reason for shifting the flags.  Also, this shift
would require all the application to recompile since they would suddenly start
providing wrong flag values to the kernel (broken ABI).

> 
>>> +/*
>>> + *  sinfo_pr_policy: 16 bits (unsigned integer)
>>> + *
>>> + *   This field may contain the partial reliability used to
>>> + *   send the message.
>>> + */
>>> +
>>> +enum sctp_sinfo_pr_policy {
>>> +     SCTP_PR_SCTP_NONE = 0x0000,  /* Reliable transmission */
>>> +     SCTP_PR_SCTP_TTL  = 0x0001,  /* Timed partial reliability */
>>> +};
>>>
>>>  typedef union {
>>>       __u8                    raw;
>>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
>>> index f4b2304..c178139 100644
>>> --- a/net/sctp/associola.c
>>> +++ b/net/sctp/associola.c
>>> @@ -302,7 +302,8 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
>>>       asoc->default_ppid = sp->default_ppid;
>>>       asoc->default_flags = sp->default_flags;
>>>       asoc->default_context = sp->default_context;
>>> -     asoc->default_timetolive = sp->default_timetolive;
>>> +     asoc->default_pr_policy = sp->default_pr_policy;
>>> +     asoc->default_pr_value = sp->default_pr_value;
>>>       asoc->default_rcv_context = sp->default_rcv_context;
>>>
>>>       /* AUTH related initializations */
>>> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
>>> index 1748ef9..d499962 100644
>>> --- a/net/sctp/chunk.c
>>> +++ b/net/sctp/chunk.c
>>> @@ -56,7 +56,7 @@ static void sctp_datamsg_init(struct sctp_datamsg *msg)
>>>       atomic_set(&msg->refcnt, 1);
>>>       msg->send_failed = 0;
>>>       msg->send_error = 0;
>>> -     msg->can_abandon = 0;
>>> +     msg->expires_policy = SCTP_PR_SCTP_NONE;
>>>       msg->expires_at = 0;
>>>       INIT_LIST_HEAD(&msg->chunks);
>>>  }
>>> @@ -170,13 +170,17 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>>>       /* Note: Calculate this outside of the loop, so that all fragments
>>>        * have the same expiration.
>>>        */
>>> -     if (sinfo->sinfo_timetolive) {
>>> -             /* sinfo_timetolive is in milliseconds */
>>> -             msg->expires_at = jiffies +
>>> -                                 msecs_to_jiffies(sinfo->sinfo_timetolive);
>>> -             msg->can_abandon = 1;
>>> -             SCTP_DEBUG_PRINTK("%s: msg:%p expires_at: %ld jiffies:%ld\n",
>>> -                               __func__, msg, msg->expires_at, jiffies);
>>> +
>>> +     msg->expires_policy = sinfo->sinfo_pr_policy;
>>> +
>>> +     if(msg->expires_policy) {
>>> +             switch(msg->expires_policy) {
>>> +                     case SCTP_PR_SCTP_TTL:
>>> +                             /* sinfo_timetolive is in milliseconds */
>>> +                                     msg->expires_at = jiffies +
>>> +                                             msecs_to_jiffies(sinfo->sinfo_pr_value);
>>> +                             break;
>>> +             }
>> The one problem with this approach is if the user is still using the older structure that might have
>> value uninitialized.  I will most likely be 0, not 1, but also could be something entirely bogus if
>> the user didn't zero-out the structure.  So, I think the TTL policy should be a default assumption and
>> the sinfo_pr_value (equivalent to the old sinfo_timetoliv) needs to be checked to see if the TTL policy
>> applies.
>>
>> Also, msg->expires_policy needs to be set only if sinfo_pr_policy is truly set correctly.
>>
> 
> I need the ability to set sinfo_pr_policy to SCTP_PR_SCTP_TTL and
> sinfo_pr_value equal to zero as a way to enable a completely
> unreliable service (i.e. no retransmissions at all), similar to UDP
> but with congestion control (maybe DCCP emulation??).

OK.  So you need to have a default case, where the expires_policy is
junk and in that case you verify pr_value before setting msg->expires_policy.

In essence, you need to cover the case of user using the new structure as
well as using an old structure that had a memory hole.

> 
> I believe this functionality added to unordered delivery can be useful
> for several applications and allows SCTP to cover all the reliability
> spectrum from ordered reliable, ordered unreliable, unordered
> reliable, unordered unreliable, ordered partial reliable and unordered
> partial reliable.
> 
> Another alternative would be to define a new partial reliability
> profile, something like SCTP_PR_SCTP_UNR, that forces sinfo_pr_value
> to zero and never retransmits.

I think what you are looking for a retransmit policy (SCTP_PR_RTX) with the
number of retransmits set 0.  You don't want to do this as a timer policy with
a timeout of 0 milliseconds, because you may end up discarding packets
as fast as your app can generate them and never send anything.

> 
> About validating sinfo_pr_value and sinfo_pr_policy I added validating
> code on the sctp_msghdr_parse method. I think this is the best place
> to make this validation. This would also make sure that the user gets
> an error message if the sinfo_pr_value or sinfo_pr_policy values are
> not initialized correctly (me thinks).

No, the user may be using an old structure and and old api/abi.  We can't break
them.  This has been my gripe with this draft for a long time... it keeps
breaking ABI and requiring these ugly workarounds.

You can log a rate limited warning, but you can't error out since that will
break applications.

BTW, why are the constants SCTP_PR_SCTP_*.  Having SCTP there once should be
enough.  We can define BSD compatibility stuff, but having it clean in the kernel.


-vlad
