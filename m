From: "Horacio Sanson" <hsanson@gmail.com>
Date: Thu, 18 Dec 2008 10:03:14 +0000
Subject: Re: [PATCH] lksctp: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <6156dd8b0812180203i20b37831r4b653d393cb30308@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="----=_Part_38224_11416414.1229594594822"
List-Id: <linux-sctp.vger.kernel.org>
References: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
In-Reply-To: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
To: linux-sctp@vger.kernel.org

------=_Part_38224_11416414.1229594594822
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Dec 18, 2008 at 6:24 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> Horacio Sanson wrote:
>> From: Horacio Sanson <hsanson@skillupjapan.co.jp>
>>
>> Modified all relevant structures in all header and source files to
>> replace the deprecated sinfo_timetolive field with the newer
>> sinfo_pr_policy and sinfo_pr_value.
>>
>> Added a new sctp_sinfo_pr_policy enum that contains the different PR policy
>> definitions: SCTP_PR_SCTP_NONE and SCTP_PR_SCTP_TTL. And modified the
>> values of sctp_sinfo_flags so they use the higher byte only and leave the
>> lower byte free for sctp_pr_policy values.
>
> need you sign-off.
>

Done, just added "-s" to the commit command....

>> ---
>>  include/net/sctp/structs.h |   10 ++++++----
>>  include/net/sctp/user.h    |   22 +++++++++++++++++-----
>>  net/sctp/associola.c       |    3 ++-
>>  net/sctp/chunk.c           |   30 +++++++++++++++++++-----------
>>  net/sctp/output.c          |    2 +-
>>  net/sctp/socket.c          |   27 ++++++++++++++-------------
>>  net/sctp/ulpevent.c        |    3 ++-
>>  7 files changed, 61 insertions(+), 36 deletions(-)
>>
>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>> index 9661d7b..2a86944 100644
>> --- a/include/net/sctp/structs.h
>> +++ b/include/net/sctp/structs.h
>> @@ -281,8 +281,9 @@ struct sctp_sock {
>>       __u16 default_stream;
>>       __u32 default_ppid;
>>       __u16 default_flags;
>> +     __u16 default_pr_policy;
>>       __u32 default_context;
>> -     __u32 default_timetolive;
>> +     __u32 default_pr_value;
>>       __u32 default_rcv_context;
>>       int max_burst;
>>
>> @@ -626,13 +627,13 @@ struct sctp_datamsg {
>>       struct list_head track;
>>       /* Reference counting. */
>>       atomic_t refcnt;
>> +     /* Policy used to determine how expires_at is interpreted */
>> +     unsigned long expires_policy;
>>       /* When is this message no longer interesting to the peer? */
>>       unsigned long expires_at;
>>       /* Did the messenge fail to send? */
>>       int send_error;
>>       char send_failed;
>> -     /* Control whether chunks from this message can be abandoned. */
>> -     char can_abandon;
>>  };
>>
>>  struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
>> @@ -1759,9 +1760,10 @@ struct sctp_association {
>>       /* Default send parameters. */
>>       __u16 default_stream;
>>       __u16 default_flags;
>> +     __u16 default_pr_policy;
>>       __u32 default_ppid;
>>       __u32 default_context;
>> -     __u32 default_timetolive;
>> +     __u32 default_pr_value;
>>
>>       /* Default receive parameters */
>>       __u32 default_rcv_context;
>> diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
>> index f205b10..55ecc4a 100644
>> --- a/include/net/sctp/user.h
>> +++ b/include/net/sctp/user.h
>> @@ -183,9 +183,10 @@ struct sctp_sndrcvinfo {
>>       __u16 sinfo_stream;
>>       __u16 sinfo_ssn;
>>       __u16 sinfo_flags;
>> +     __u16 sinfo_pr_policy;
>>       __u32 sinfo_ppid;
>>       __u32 sinfo_context;
>> -     __u32 sinfo_timetolive;
>> +     __u32 sinfo_pr_value;
>>       __u32 sinfo_tsn;
>>       __u32 sinfo_cumtsn;
>>       sctp_assoc_t sinfo_assoc_id;
>> @@ -199,12 +200,23 @@ struct sctp_sndrcvinfo {
>>   */
>>
>>  enum sctp_sinfo_flags {
>> -     SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
>> -     SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
>> -     SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
>> -     SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */
>> +     SCTP_EOF       = MSG_FIN,    /* Initiate graceful shutdown process. (0x0200) */
>> +     SCTP_UNORDERED = 0x0400,     /* Send/receive message unordered. */
>> +     SCTP_ADDR_OVER = 0x0800,     /* Override the primary destination. */
>> +     SCTP_ABORT     = 0x1000,     /* Send an ABORT message to the peer. */
>>  };
>>
>
> Why?

These values, except for SCTP_EOF, are exactly the same values used in
the FreeBSD implementation. This scheme allows the lower byte to be
used for sctp_sinfo_pr_policy values.

I modified all these flags so they coincide with FreeBSD
implementation that is also the same code base used for MacOSX and
Windows implementations to avoid any incompatibilities between
implementations. At least sinfo_pr_policy is transported between peers
in an association and having standard values is a good idea.

>
>> +/*
>> + *  sinfo_pr_policy: 16 bits (unsigned integer)
>> + *
>> + *   This field may contain the partial reliability used to
>> + *   send the message.
>> + */
>> +
>> +enum sctp_sinfo_pr_policy {
>> +     SCTP_PR_SCTP_NONE = 0x0000,  /* Reliable transmission */
>> +     SCTP_PR_SCTP_TTL  = 0x0001,  /* Timed partial reliability */
>> +};
>>
>>  typedef union {
>>       __u8                    raw;
>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
>> index f4b2304..c178139 100644
>> --- a/net/sctp/associola.c
>> +++ b/net/sctp/associola.c
>> @@ -302,7 +302,8 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
>>       asoc->default_ppid = sp->default_ppid;
>>       asoc->default_flags = sp->default_flags;
>>       asoc->default_context = sp->default_context;
>> -     asoc->default_timetolive = sp->default_timetolive;
>> +     asoc->default_pr_policy = sp->default_pr_policy;
>> +     asoc->default_pr_value = sp->default_pr_value;
>>       asoc->default_rcv_context = sp->default_rcv_context;
>>
>>       /* AUTH related initializations */
>> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
>> index 1748ef9..d499962 100644
>> --- a/net/sctp/chunk.c
>> +++ b/net/sctp/chunk.c
>> @@ -56,7 +56,7 @@ static void sctp_datamsg_init(struct sctp_datamsg *msg)
>>       atomic_set(&msg->refcnt, 1);
>>       msg->send_failed = 0;
>>       msg->send_error = 0;
>> -     msg->can_abandon = 0;
>> +     msg->expires_policy = SCTP_PR_SCTP_NONE;
>>       msg->expires_at = 0;
>>       INIT_LIST_HEAD(&msg->chunks);
>>  }
>> @@ -170,13 +170,17 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>>       /* Note: Calculate this outside of the loop, so that all fragments
>>        * have the same expiration.
>>        */
>> -     if (sinfo->sinfo_timetolive) {
>> -             /* sinfo_timetolive is in milliseconds */
>> -             msg->expires_at = jiffies +
>> -                                 msecs_to_jiffies(sinfo->sinfo_timetolive);
>> -             msg->can_abandon = 1;
>> -             SCTP_DEBUG_PRINTK("%s: msg:%p expires_at: %ld jiffies:%ld\n",
>> -                               __func__, msg, msg->expires_at, jiffies);
>> +
>> +     msg->expires_policy = sinfo->sinfo_pr_policy;
>> +
>> +     if(msg->expires_policy) {
>> +             switch(msg->expires_policy) {
>> +                     case SCTP_PR_SCTP_TTL:
>> +                             /* sinfo_timetolive is in milliseconds */
>> +                                     msg->expires_at = jiffies +
>> +                                             msecs_to_jiffies(sinfo->sinfo_pr_value);
>> +                             break;
>> +             }
>
> The one problem with this approach is if the user is still using the older structure that might have
> value uninitialized.  I will most likely be 0, not 1, but also could be something entirely bogus if
> the user didn't zero-out the structure.  So, I think the TTL policy should be a default assumption and
> the sinfo_pr_value (equivalent to the old sinfo_timetoliv) needs to be checked to see if the TTL policy
> applies.
>
> Also, msg->expires_policy needs to be set only if sinfo_pr_policy is truly set correctly.
>

I need the ability to set sinfo_pr_policy to SCTP_PR_SCTP_TTL and
sinfo_pr_value equal to zero as a way to enable a completely
unreliable service (i.e. no retransmissions at all), similar to UDP
but with congestion control (maybe DCCP emulation??).

I believe this functionality added to unordered delivery can be useful
for several applications and allows SCTP to cover all the reliability
spectrum from ordered reliable, ordered unreliable, unordered
reliable, unordered unreliable, ordered partial reliable and unordered
partial reliable.

Another alternative would be to define a new partial reliability
profile, something like SCTP_PR_SCTP_UNR, that forces sinfo_pr_value
to zero and never retransmits.

About validating sinfo_pr_value and sinfo_pr_policy I added validating
code on the sctp_msghdr_parse method. I think this is the best place
to make this validation. This would also make sure that the user gets
an error message if the sinfo_pr_value or sinfo_pr_policy values are
not initialized correctly (me thinks).

>>       }
>>
>>       max = asoc->frag_point;
>> @@ -291,11 +295,15 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
>>  {
>>       struct sctp_datamsg *msg = chunk->msg;
>>
>> -     if (!msg->can_abandon)
>> +     if (!msg->expires_policy)
>>               return 0;
>>
>> -     if (time_after(jiffies, msg->expires_at))
>> -             return 1;
>> +     switch(msg->expires_policy) {
>> +             case SCTP_PR_SCTP_TTL:
>> +                     if(time_after(jiffies, msg->expires_at))
>> +                             return 1;
>> +                     break;
>> +     }
>>
>>       return 0;
>>  }
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index c3f417f..b344a9d 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -745,7 +745,7 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
>>       asoc->peer.rwnd = rwnd;
>>       /* Has been accepted for transmission. */
>>       if (!asoc->peer.prsctp_capable)
>> -             chunk->msg->can_abandon = 0;
>> +             chunk->msg->expires_policy = SCTP_PR_SCTP_NONE;
>>
>>  finish:
>>       return retval;
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index a1b9045..eef5842 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -1698,7 +1698,8 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>>               default_sinfo.sinfo_flags = asoc->default_flags;
>>               default_sinfo.sinfo_ppid = asoc->default_ppid;
>>               default_sinfo.sinfo_context = asoc->default_context;
>> -             default_sinfo.sinfo_timetolive = asoc->default_timetolive;
>> +             default_sinfo.sinfo_pr_policy = asoc->default_pr_policy;
>> +             default_sinfo.sinfo_pr_value = asoc->default_pr_value;
>>               default_sinfo.sinfo_assoc_id = sctp_assoc2id(asoc);
>>               sinfo = &default_sinfo;
>>       }
>> @@ -2539,7 +2540,7 @@ static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, int opt
>>   *   in to this call the sctp_sndrcvinfo structure defined in Section
>>   *   5.2.2) The input parameters accepted by this call include
>>   *   sinfo_stream, sinfo_flags, sinfo_ppid, sinfo_context,
>> - *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
>> + *   sinfo_pr_value.  The user must provide the sinfo_assoc_id field in
>>   *   to this call if the caller is using the UDP model.
>>   */
>>  static int sctp_setsockopt_default_send_param(struct sock *sk,
>> @@ -2563,13 +2564,15 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
>>               asoc->default_flags = info.sinfo_flags;
>>               asoc->default_ppid = info.sinfo_ppid;
>>               asoc->default_context = info.sinfo_context;
>> -             asoc->default_timetolive = info.sinfo_timetolive;
>> +             asoc->default_pr_policy = info.sinfo_pr_policy;
>> +             asoc->default_pr_value = info.sinfo_pr_value;
>>       } else {
>>               sp->default_stream = info.sinfo_stream;
>>               sp->default_flags = info.sinfo_flags;
>>               sp->default_ppid = info.sinfo_ppid;
>>               sp->default_context = info.sinfo_context;
>> -             sp->default_timetolive = info.sinfo_timetolive;
>> +             sp->default_pr_policy = info.sinfo_pr_policy;
>> +             sp->default_pr_value = info.sinfo_pr_value;
>>       }
>>
>
> Need to do validation on the pr_policy value to make sure it's valid.

As mentioned above I added all this validations in a single place
(sctp_msghdr_parse).

>
>>       return 0;
>> @@ -3524,7 +3527,8 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
>>       sp->default_ppid = 0;
>>       sp->default_flags = 0;
>>       sp->default_context = 0;
>> -     sp->default_timetolive = 0;
>> +     sp->default_pr_policy = 0;
>
> Initialize policy to the enum you defined.

done

>
>> +     sp->default_pr_value = 0;
>>
>>       sp->default_rcv_context = 0;
>>       sp->max_burst = sctp_max_burst;
>> @@ -4824,7 +4828,7 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
>>   *   in to this call the sctp_sndrcvinfo structure defined in Section
>>   *   5.2.2) The input parameters accepted by this call include
>>   *   sinfo_stream, sinfo_flags, sinfo_ppid, sinfo_context,
>> - *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
>> + *   sinfo_pr_value.  The user must provide the sinfo_assoc_id field in
>>   *   to this call if the caller is using the UDP model.
>>   *
>>   *   For getsockopt, it get the default sctp_sndrcvinfo structure.
>> @@ -4854,13 +4858,15 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
>>               info.sinfo_flags = asoc->default_flags;
>>               info.sinfo_ppid = asoc->default_ppid;
>>               info.sinfo_context = asoc->default_context;
>> -             info.sinfo_timetolive = asoc->default_timetolive;
>> +             info.sinfo_pr_policy = asoc->default_pr_policy;
>> +             info.sinfo_pr_value = asoc->default_pr_value;
>>       } else {
>>               info.sinfo_stream = sp->default_stream;
>>               info.sinfo_flags = sp->default_flags;
>>               info.sinfo_ppid = sp->default_ppid;
>>               info.sinfo_context = sp->default_context;
>> -             info.sinfo_timetolive = sp->default_timetolive;
>> +             info.sinfo_pr_policy = sp->default_pr_policy;
>> +             info.sinfo_pr_value = sp->default_pr_value;
>>       }
>>
>>       if (put_user(len, optlen))
>> @@ -6106,11 +6112,6 @@ SCTP_STATIC int sctp_msghdr_parse(const struct msghdr *msg,
>>                       cmsgs->info =
>>                               (struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
>>
>> -                     /* Minimally, validate the sinfo_flags. */
>> -                     if (cmsgs->info->sinfo_flags &
>> -                         ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
>> -                           SCTP_ABORT | SCTP_EOF))
>> -                             return -EINVAL;
>
> Why?

The new sinfo_pr_policy flags caused this to fail. I have added a new
validation check and additionally added validation for sinfo_pr_policy
and sinfo_pr_value. See attached new patch.


regrads
Horacio

>
>>                       break;
>>
>>               default:
>> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
>> index 5f186ca..2c6f111 100644
>> --- a/net/sctp/ulpevent.c
>> +++ b/net/sctp/ulpevent.c
>> @@ -948,7 +948,8 @@ void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
>>       sinfo.sinfo_context = event->asoc->default_rcv_context;
>>
>>       /* These fields are not used while receiving. */
>> -     sinfo.sinfo_timetolive = 0;
>> +     sinfo.sinfo_pr_policy = 0;
>> +     sinfo.sinfo_pr_value = 0;
>>
>>       put_cmsg(msghdr, IPPROTO_SCTP, SCTP_SNDRCV,
>>                sizeof(struct sctp_sndrcvinfo), (void *)&sinfo);
>
>
> -vlad
>

------=_Part_38224_11416414.1229594594822
Content-Type: text/x-diff;
 name=0001-lksctp-replace-sinfo_timetolive-with-sinfo_pr_value.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fov8x87f0
Content-Disposition: attachment;
 filename=0001-lksctp-replace-sinfo_timetolive-with-sinfo_pr_value.patch

RnJvbSA0M2IxN2I2YzczYTBkNzJkZDQyMWIyMDBmZDNlOGQ0ODQ1Y2RmODg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIb3JhY2lvIFNhbnNvbiA8aHNhbnNvbkBza2lsbHVwamFwYW4u
Y28uanA+CkRhdGU6IFRodSwgMTggRGVjIDIwMDggMTg6NTc6NTEgKzA5MDAKU3ViamVjdDogW1BB
VENIXSBsa3NjdHA6IHJlcGxhY2Ugc2luZm9fdGltZXRvbGl2ZSB3aXRoIHNpbmZvX3ByX3ZhbHVl
LgoKTW9kaWZpZWQgYWxsIHJlbGV2YW50IHN0cnVjdHVyZXMgaW4gYWxsIGhlYWRlciBhbmQgc291
cmNlIGZpbGVzIHRvCnJlcGxhY2UgdGhlIGRlcHJlY2F0ZWQgc2luZm9fdGltZXRvbGl2ZSBmaWVs
ZCB3aXRoIHRoZSBuZXdlcgpzaW5mb19wcl9wb2xpY3kgYW5kIHNpbmZvX3ByX3ZhbHVlLgoKQWRk
ZWQgYSBuZXcgc2N0cF9zaW5mb19wcl9wb2xpY3kgZW51bSB0aGF0IGNvbnRhaW5zIHRoZSBkaWZm
ZXJlbnQgUFIgcG9saWN5CmRlZmluaXRpb25zOiBTQ1RQX1BSX1NDVFBfTk9ORSBhbmQgU0NUUF9Q
Ul9TQ1RQX1RUTC4gQW5kIG1vZGlmaWVkIHRoZQp2YWx1ZXMgb2Ygc2N0cF9zaW5mb19mbGFncyBz
byB0aGV5IHVzZSB0aGUgaGlnaGVyIGJ5dGUgb25seSBhbmQgbGVhdmUgdGhlCmxvd2VyIGJ5dGUg
ZnJlZSBmb3Igc2N0cF9wcl9wb2xpY3kgdmFsdWVzLgpTaWduZWQtb2ZmLWJ5OiBIb3JhY2lvIFNh
bnNvbiA8aG9yYWNpb0Bza2lsbHVwamFwYW4uY28uanA+Ci0tLQogaW5jbHVkZS9uZXQvc2N0cC9z
dHJ1Y3RzLmggfCAgIDEwICsrKysrKy0tLS0KIGluY2x1ZGUvbmV0L3NjdHAvdXNlci5oICAgIHwg
ICAyMiArKysrKysrKysrKysrKysrKy0tLS0tCiBuZXQvc2N0cC9hc3NvY2lvbGEuYyAgICAgICB8
ICAgIDMgKystCiBuZXQvc2N0cC9jaHVuay5jICAgICAgICAgICB8ICAgMzAgKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tCiBuZXQvc2N0cC9vdXRwdXQuYyAgICAgICAgICB8ICAgIDIgKy0K
IG5ldC9zY3RwL3NvY2tldC5jICAgICAgICAgIHwgICAzNSArKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLQogbmV0L3NjdHAvdWxwZXZlbnQuYyAgICAgICAgfCAgICAzICsrLQogNyBm
aWxlcyBjaGFuZ2VkLCA3MSBpbnNlcnRpb25zKCspLCAzNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL25ldC9zY3RwL3N0cnVjdHMuaCBiL2luY2x1ZGUvbmV0L3NjdHAvc3RydWN0
cy5oCmluZGV4IDk2NjFkN2IuLjJhODY5NDQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L3NjdHAv
c3RydWN0cy5oCisrKyBiL2luY2x1ZGUvbmV0L3NjdHAvc3RydWN0cy5oCkBAIC0yODEsOCArMjgx
LDkgQEAgc3RydWN0IHNjdHBfc29jayB7CiAJX191MTYgZGVmYXVsdF9zdHJlYW07CiAJX191MzIg
ZGVmYXVsdF9wcGlkOwogCV9fdTE2IGRlZmF1bHRfZmxhZ3M7CisJX191MTYgZGVmYXVsdF9wcl9w
b2xpY3k7CiAJX191MzIgZGVmYXVsdF9jb250ZXh0OwotCV9fdTMyIGRlZmF1bHRfdGltZXRvbGl2
ZTsKKwlfX3UzMiBkZWZhdWx0X3ByX3ZhbHVlOwogCV9fdTMyIGRlZmF1bHRfcmN2X2NvbnRleHQ7
CiAJaW50IG1heF9idXJzdDsKIApAQCAtNjI2LDEzICs2MjcsMTMgQEAgc3RydWN0IHNjdHBfZGF0
YW1zZyB7CiAJc3RydWN0IGxpc3RfaGVhZCB0cmFjazsKIAkvKiBSZWZlcmVuY2UgY291bnRpbmcu
ICovCiAJYXRvbWljX3QgcmVmY250OworCS8qIFBvbGljeSB1c2VkIHRvIGRldGVybWluZSBob3cg
ZXhwaXJlc19hdCBpcyBpbnRlcnByZXRlZCAqLworCXVuc2lnbmVkIGxvbmcgZXhwaXJlc19wb2xp
Y3k7CiAJLyogV2hlbiBpcyB0aGlzIG1lc3NhZ2Ugbm8gbG9uZ2VyIGludGVyZXN0aW5nIHRvIHRo
ZSBwZWVyPyAqLwogCXVuc2lnbmVkIGxvbmcgZXhwaXJlc19hdDsKIAkvKiBEaWQgdGhlIG1lc3Nl
bmdlIGZhaWwgdG8gc2VuZD8gKi8KIAlpbnQgc2VuZF9lcnJvcjsKIAljaGFyIHNlbmRfZmFpbGVk
OwotCS8qIENvbnRyb2wgd2hldGhlciBjaHVua3MgZnJvbSB0aGlzIG1lc3NhZ2UgY2FuIGJlIGFi
YW5kb25lZC4gKi8KLQljaGFyIGNhbl9hYmFuZG9uOwogfTsKIAogc3RydWN0IHNjdHBfZGF0YW1z
ZyAqc2N0cF9kYXRhbXNnX2Zyb21fdXNlcihzdHJ1Y3Qgc2N0cF9hc3NvY2lhdGlvbiAqLApAQCAt
MTc1OSw5ICsxNzYwLDEwIEBAIHN0cnVjdCBzY3RwX2Fzc29jaWF0aW9uIHsKIAkvKiBEZWZhdWx0
IHNlbmQgcGFyYW1ldGVycy4gKi8KIAlfX3UxNiBkZWZhdWx0X3N0cmVhbTsKIAlfX3UxNiBkZWZh
dWx0X2ZsYWdzOworCV9fdTE2IGRlZmF1bHRfcHJfcG9saWN5OwogCV9fdTMyIGRlZmF1bHRfcHBp
ZDsKIAlfX3UzMiBkZWZhdWx0X2NvbnRleHQ7Ci0JX191MzIgZGVmYXVsdF90aW1ldG9saXZlOwor
CV9fdTMyIGRlZmF1bHRfcHJfdmFsdWU7CiAKIAkvKiBEZWZhdWx0IHJlY2VpdmUgcGFyYW1ldGVy
cyAqLwogCV9fdTMyIGRlZmF1bHRfcmN2X2NvbnRleHQ7CmRpZmYgLS1naXQgYS9pbmNsdWRlL25l
dC9zY3RwL3VzZXIuaCBiL2luY2x1ZGUvbmV0L3NjdHAvdXNlci5oCmluZGV4IGYyMDViMTAuLjU1
ZWNjNGEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L3NjdHAvdXNlci5oCisrKyBiL2luY2x1ZGUv
bmV0L3NjdHAvdXNlci5oCkBAIC0xODMsOSArMTgzLDEwIEBAIHN0cnVjdCBzY3RwX3NuZHJjdmlu
Zm8gewogCV9fdTE2IHNpbmZvX3N0cmVhbTsKIAlfX3UxNiBzaW5mb19zc247CiAJX191MTYgc2lu
Zm9fZmxhZ3M7CisJX191MTYgc2luZm9fcHJfcG9saWN5OwogCV9fdTMyIHNpbmZvX3BwaWQ7CiAJ
X191MzIgc2luZm9fY29udGV4dDsKLQlfX3UzMiBzaW5mb190aW1ldG9saXZlOworCV9fdTMyIHNp
bmZvX3ByX3ZhbHVlOwogCV9fdTMyIHNpbmZvX3RzbjsKIAlfX3UzMiBzaW5mb19jdW10c247CiAJ
c2N0cF9hc3NvY190IHNpbmZvX2Fzc29jX2lkOwpAQCAtMTk5LDEyICsyMDAsMjMgQEAgc3RydWN0
IHNjdHBfc25kcmN2aW5mbyB7CiAgKi8KIAogZW51bSBzY3RwX3NpbmZvX2ZsYWdzIHsKLQlTQ1RQ
X1VOT1JERVJFRCA9IDEsICAvKiBTZW5kL3JlY2VpdmUgbWVzc2FnZSB1bm9yZGVyZWQuICovCi0J
U0NUUF9BRERSX09WRVIgPSAyLCAgLyogT3ZlcnJpZGUgdGhlIHByaW1hcnkgZGVzdGluYXRpb24u
ICovCi0JU0NUUF9BQk9SVD00LCAgICAgICAgLyogU2VuZCBhbiBBQk9SVCBtZXNzYWdlIHRvIHRo
ZSBwZWVyLiAqLwotCVNDVFBfRU9GPU1TR19GSU4sICAgIC8qIEluaXRpYXRlIGdyYWNlZnVsIHNo
dXRkb3duIHByb2Nlc3MuICovCQorCVNDVFBfRU9GICAgICAgID0gTVNHX0ZJTiwgICAgLyogSW5p
dGlhdGUgZ3JhY2VmdWwgc2h1dGRvd24gcHJvY2Vzcy4gKDB4MDIwMCkgKi8KKwlTQ1RQX1VOT1JE
RVJFRCA9IDB4MDQwMCwgICAgIC8qIFNlbmQvcmVjZWl2ZSBtZXNzYWdlIHVub3JkZXJlZC4gKi8K
KwlTQ1RQX0FERFJfT1ZFUiA9IDB4MDgwMCwgICAgIC8qIE92ZXJyaWRlIHRoZSBwcmltYXJ5IGRl
c3RpbmF0aW9uLiAqLworCVNDVFBfQUJPUlQgICAgID0gMHgxMDAwLCAgICAgLyogU2VuZCBhbiBB
Qk9SVCBtZXNzYWdlIHRvIHRoZSBwZWVyLiAqLwogfTsKIAorLyoKKyAqICBzaW5mb19wcl9wb2xp
Y3k6IDE2IGJpdHMgKHVuc2lnbmVkIGludGVnZXIpCisgKgorICogICBUaGlzIGZpZWxkIG1heSBj
b250YWluIHRoZSBwYXJ0aWFsIHJlbGlhYmlsaXR5IHVzZWQgdG8KKyAqICAgc2VuZCB0aGUgbWVz
c2FnZS4KKyAqLworCitlbnVtIHNjdHBfc2luZm9fcHJfcG9saWN5IHsKKwlTQ1RQX1BSX1NDVFBf
Tk9ORSA9IDB4MDAwMCwgIC8qIFJlbGlhYmxlIHRyYW5zbWlzc2lvbiAqLworCVNDVFBfUFJfU0NU
UF9UVEwgID0gMHgwMDAxLCAgLyogVGltZWQgcGFydGlhbCByZWxpYWJpbGl0eSAqLworfTsKIAog
dHlwZWRlZiB1bmlvbiB7CiAJX191OCAgIAkJCXJhdzsKZGlmZiAtLWdpdCBhL25ldC9zY3RwL2Fz
c29jaW9sYS5jIGIvbmV0L3NjdHAvYXNzb2Npb2xhLmMKaW5kZXggZjRiMjMwNC4uYzE3ODEzOSAx
MDA2NDQKLS0tIGEvbmV0L3NjdHAvYXNzb2Npb2xhLmMKKysrIGIvbmV0L3NjdHAvYXNzb2Npb2xh
LmMKQEAgLTMwMiw3ICszMDIsOCBAQCBzdGF0aWMgc3RydWN0IHNjdHBfYXNzb2NpYXRpb24gKnNj
dHBfYXNzb2NpYXRpb25faW5pdChzdHJ1Y3Qgc2N0cF9hc3NvY2lhdGlvbiAqYQogCWFzb2MtPmRl
ZmF1bHRfcHBpZCA9IHNwLT5kZWZhdWx0X3BwaWQ7CiAJYXNvYy0+ZGVmYXVsdF9mbGFncyA9IHNw
LT5kZWZhdWx0X2ZsYWdzOwogCWFzb2MtPmRlZmF1bHRfY29udGV4dCA9IHNwLT5kZWZhdWx0X2Nv
bnRleHQ7Ci0JYXNvYy0+ZGVmYXVsdF90aW1ldG9saXZlID0gc3AtPmRlZmF1bHRfdGltZXRvbGl2
ZTsKKwlhc29jLT5kZWZhdWx0X3ByX3BvbGljeSA9IHNwLT5kZWZhdWx0X3ByX3BvbGljeTsKKwlh
c29jLT5kZWZhdWx0X3ByX3ZhbHVlID0gc3AtPmRlZmF1bHRfcHJfdmFsdWU7CiAJYXNvYy0+ZGVm
YXVsdF9yY3ZfY29udGV4dCA9IHNwLT5kZWZhdWx0X3Jjdl9jb250ZXh0OwogCiAJLyogQVVUSCBy
ZWxhdGVkIGluaXRpYWxpemF0aW9ucyAqLwpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvY2h1bmsuYyBi
L25ldC9zY3RwL2NodW5rLmMKaW5kZXggMTc0OGVmOS4uZDQ5OTk2MiAxMDA2NDQKLS0tIGEvbmV0
L3NjdHAvY2h1bmsuYworKysgYi9uZXQvc2N0cC9jaHVuay5jCkBAIC01Niw3ICs1Niw3IEBAIHN0
YXRpYyB2b2lkIHNjdHBfZGF0YW1zZ19pbml0KHN0cnVjdCBzY3RwX2RhdGFtc2cgKm1zZykKIAlh
dG9taWNfc2V0KCZtc2ctPnJlZmNudCwgMSk7CiAJbXNnLT5zZW5kX2ZhaWxlZCA9IDA7CiAJbXNn
LT5zZW5kX2Vycm9yID0gMDsKLQltc2ctPmNhbl9hYmFuZG9uID0gMDsKKwltc2ctPmV4cGlyZXNf
cG9saWN5ID0gU0NUUF9QUl9TQ1RQX05PTkU7CiAJbXNnLT5leHBpcmVzX2F0ID0gMDsKIAlJTklU
X0xJU1RfSEVBRCgmbXNnLT5jaHVua3MpOwogfQpAQCAtMTcwLDEzICsxNzAsMTcgQEAgc3RydWN0
IHNjdHBfZGF0YW1zZyAqc2N0cF9kYXRhbXNnX2Zyb21fdXNlcihzdHJ1Y3Qgc2N0cF9hc3NvY2lh
dGlvbiAqYXNvYywKIAkvKiBOb3RlOiBDYWxjdWxhdGUgdGhpcyBvdXRzaWRlIG9mIHRoZSBsb29w
LCBzbyB0aGF0IGFsbCBmcmFnbWVudHMKIAkgKiBoYXZlIHRoZSBzYW1lIGV4cGlyYXRpb24uCiAJ
ICovCi0JaWYgKHNpbmZvLT5zaW5mb190aW1ldG9saXZlKSB7Ci0JCS8qIHNpbmZvX3RpbWV0b2xp
dmUgaXMgaW4gbWlsbGlzZWNvbmRzICovCi0JCW1zZy0+ZXhwaXJlc19hdCA9IGppZmZpZXMgKwot
CQkJCSAgICBtc2Vjc190b19qaWZmaWVzKHNpbmZvLT5zaW5mb190aW1ldG9saXZlKTsKLQkJbXNn
LT5jYW5fYWJhbmRvbiA9IDE7Ci0JCVNDVFBfREVCVUdfUFJJTlRLKCIlczogbXNnOiVwIGV4cGly
ZXNfYXQ6ICVsZCBqaWZmaWVzOiVsZFxuIiwKLQkJCQkgIF9fZnVuY19fLCBtc2csIG1zZy0+ZXhw
aXJlc19hdCwgamlmZmllcyk7CisKKwltc2ctPmV4cGlyZXNfcG9saWN5ID0gc2luZm8tPnNpbmZv
X3ByX3BvbGljeTsKKworCWlmKG1zZy0+ZXhwaXJlc19wb2xpY3kpIHsKKwkJc3dpdGNoKG1zZy0+
ZXhwaXJlc19wb2xpY3kpIHsKKwkJCWNhc2UgU0NUUF9QUl9TQ1RQX1RUTDoKKwkJCQkvKiBzaW5m
b190aW1ldG9saXZlIGlzIGluIG1pbGxpc2Vjb25kcyAqLworCQkJCQltc2ctPmV4cGlyZXNfYXQg
PSBqaWZmaWVzICsKKwkJCQkJCW1zZWNzX3RvX2ppZmZpZXMoc2luZm8tPnNpbmZvX3ByX3ZhbHVl
KTsKKwkJCQlicmVhazsKKwkJfQogCX0KIAogCW1heCA9IGFzb2MtPmZyYWdfcG9pbnQ7CkBAIC0y
OTEsMTEgKzI5NSwxNSBAQCBpbnQgc2N0cF9jaHVua19hYmFuZG9uZWQoc3RydWN0IHNjdHBfY2h1
bmsgKmNodW5rKQogewogCXN0cnVjdCBzY3RwX2RhdGFtc2cgKm1zZyA9IGNodW5rLT5tc2c7CiAK
LQlpZiAoIW1zZy0+Y2FuX2FiYW5kb24pCisJaWYgKCFtc2ctPmV4cGlyZXNfcG9saWN5KQogCQly
ZXR1cm4gMDsKIAotCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIG1zZy0+ZXhwaXJlc19hdCkpCi0J
CXJldHVybiAxOworCXN3aXRjaChtc2ctPmV4cGlyZXNfcG9saWN5KSB7CisJCWNhc2UgU0NUUF9Q
Ul9TQ1RQX1RUTDoKKwkJCWlmKHRpbWVfYWZ0ZXIoamlmZmllcywgbXNnLT5leHBpcmVzX2F0KSkK
KwkJCQlyZXR1cm4gMTsKKwkJCWJyZWFrOworCX0KIAogCXJldHVybiAwOwogfQpkaWZmIC0tZ2l0
IGEvbmV0L3NjdHAvb3V0cHV0LmMgYi9uZXQvc2N0cC9vdXRwdXQuYwppbmRleCBjM2Y0MTdmLi5i
MzQ0YTlkIDEwMDY0NAotLS0gYS9uZXQvc2N0cC9vdXRwdXQuYworKysgYi9uZXQvc2N0cC9vdXRw
dXQuYwpAQCAtNzQ1LDcgKzc0NSw3IEBAIHN0YXRpYyBzY3RwX3htaXRfdCBzY3RwX3BhY2tldF9h
cHBlbmRfZGF0YShzdHJ1Y3Qgc2N0cF9wYWNrZXQgKnBhY2tldCwKIAlhc29jLT5wZWVyLnJ3bmQg
PSByd25kOwogCS8qIEhhcyBiZWVuIGFjY2VwdGVkIGZvciB0cmFuc21pc3Npb24uICovCiAJaWYg
KCFhc29jLT5wZWVyLnByc2N0cF9jYXBhYmxlKQotCQljaHVuay0+bXNnLT5jYW5fYWJhbmRvbiA9
IDA7CisJCWNodW5rLT5tc2ctPmV4cGlyZXNfcG9saWN5ID0gU0NUUF9QUl9TQ1RQX05PTkU7CiAK
IGZpbmlzaDoKIAlyZXR1cm4gcmV0dmFsOwpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvc29ja2V0LmMg
Yi9uZXQvc2N0cC9zb2NrZXQuYwppbmRleCBhMWI5MDQ1Li5hNzQxYzgyIDEwMDY0NAotLS0gYS9u
ZXQvc2N0cC9zb2NrZXQuYworKysgYi9uZXQvc2N0cC9zb2NrZXQuYwpAQCAtMTY5OCw3ICsxNjk4
LDggQEAgU0NUUF9TVEFUSUMgaW50IHNjdHBfc2VuZG1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0
cnVjdCBzb2NrICpzaywKIAkJZGVmYXVsdF9zaW5mby5zaW5mb19mbGFncyA9IGFzb2MtPmRlZmF1
bHRfZmxhZ3M7CiAJCWRlZmF1bHRfc2luZm8uc2luZm9fcHBpZCA9IGFzb2MtPmRlZmF1bHRfcHBp
ZDsKIAkJZGVmYXVsdF9zaW5mby5zaW5mb19jb250ZXh0ID0gYXNvYy0+ZGVmYXVsdF9jb250ZXh0
OwotCQlkZWZhdWx0X3NpbmZvLnNpbmZvX3RpbWV0b2xpdmUgPSBhc29jLT5kZWZhdWx0X3RpbWV0
b2xpdmU7CisJCWRlZmF1bHRfc2luZm8uc2luZm9fcHJfcG9saWN5ID0gYXNvYy0+ZGVmYXVsdF9w
cl9wb2xpY3k7CisJCWRlZmF1bHRfc2luZm8uc2luZm9fcHJfdmFsdWUgPSBhc29jLT5kZWZhdWx0
X3ByX3ZhbHVlOwogCQlkZWZhdWx0X3NpbmZvLnNpbmZvX2Fzc29jX2lkID0gc2N0cF9hc3NvYzJp
ZChhc29jKTsKIAkJc2luZm8gPSAmZGVmYXVsdF9zaW5mbzsKIAl9CkBAIC0yNTM5LDcgKzI1NDAs
NyBAQCBzdGF0aWMgaW50IHNjdHBfc2V0c29ja29wdF9pbml0bXNnKHN0cnVjdCBzb2NrICpzaywg
Y2hhciBfX3VzZXIgKm9wdHZhbCwgaW50IG9wdAogICogICBpbiB0byB0aGlzIGNhbGwgdGhlIHNj
dHBfc25kcmN2aW5mbyBzdHJ1Y3R1cmUgZGVmaW5lZCBpbiBTZWN0aW9uCiAgKiAgIDUuMi4yKSBU
aGUgaW5wdXQgcGFyYW1ldGVycyBhY2NlcHRlZCBieSB0aGlzIGNhbGwgaW5jbHVkZQogICogICBz
aW5mb19zdHJlYW0sIHNpbmZvX2ZsYWdzLCBzaW5mb19wcGlkLCBzaW5mb19jb250ZXh0LAotICog
ICBzaW5mb190aW1ldG9saXZlLiAgVGhlIHVzZXIgbXVzdCBwcm92aWRlIHRoZSBzaW5mb19hc3Nv
Y19pZCBmaWVsZCBpbgorICogICBzaW5mb19wcl92YWx1ZS4gIFRoZSB1c2VyIG11c3QgcHJvdmlk
ZSB0aGUgc2luZm9fYXNzb2NfaWQgZmllbGQgaW4KICAqICAgdG8gdGhpcyBjYWxsIGlmIHRoZSBj
YWxsZXIgaXMgdXNpbmcgdGhlIFVEUCBtb2RlbC4KICAqLwogc3RhdGljIGludCBzY3RwX3NldHNv
Y2tvcHRfZGVmYXVsdF9zZW5kX3BhcmFtKHN0cnVjdCBzb2NrICpzaywKQEAgLTI1NjMsMTMgKzI1
NjQsMTUgQEAgc3RhdGljIGludCBzY3RwX3NldHNvY2tvcHRfZGVmYXVsdF9zZW5kX3BhcmFtKHN0
cnVjdCBzb2NrICpzaywKIAkJYXNvYy0+ZGVmYXVsdF9mbGFncyA9IGluZm8uc2luZm9fZmxhZ3M7
CiAJCWFzb2MtPmRlZmF1bHRfcHBpZCA9IGluZm8uc2luZm9fcHBpZDsKIAkJYXNvYy0+ZGVmYXVs
dF9jb250ZXh0ID0gaW5mby5zaW5mb19jb250ZXh0OwotCQlhc29jLT5kZWZhdWx0X3RpbWV0b2xp
dmUgPSBpbmZvLnNpbmZvX3RpbWV0b2xpdmU7CisJCWFzb2MtPmRlZmF1bHRfcHJfcG9saWN5ID0g
aW5mby5zaW5mb19wcl9wb2xpY3k7CisJCWFzb2MtPmRlZmF1bHRfcHJfdmFsdWUgPSBpbmZvLnNp
bmZvX3ByX3ZhbHVlOwogCX0gZWxzZSB7CiAJCXNwLT5kZWZhdWx0X3N0cmVhbSA9IGluZm8uc2lu
Zm9fc3RyZWFtOwogCQlzcC0+ZGVmYXVsdF9mbGFncyA9IGluZm8uc2luZm9fZmxhZ3M7CiAJCXNw
LT5kZWZhdWx0X3BwaWQgPSBpbmZvLnNpbmZvX3BwaWQ7CiAJCXNwLT5kZWZhdWx0X2NvbnRleHQg
PSBpbmZvLnNpbmZvX2NvbnRleHQ7Ci0JCXNwLT5kZWZhdWx0X3RpbWV0b2xpdmUgPSBpbmZvLnNp
bmZvX3RpbWV0b2xpdmU7CisJCXNwLT5kZWZhdWx0X3ByX3BvbGljeSA9IGluZm8uc2luZm9fcHJf
cG9saWN5OworCQlzcC0+ZGVmYXVsdF9wcl92YWx1ZSA9IGluZm8uc2luZm9fcHJfdmFsdWU7CiAJ
fQogCiAJcmV0dXJuIDA7CkBAIC0zNTI0LDcgKzM1MjcsOCBAQCBTQ1RQX1NUQVRJQyBpbnQgc2N0
cF9pbml0X3NvY2soc3RydWN0IHNvY2sgKnNrKQogCXNwLT5kZWZhdWx0X3BwaWQgPSAwOwogCXNw
LT5kZWZhdWx0X2ZsYWdzID0gMDsKIAlzcC0+ZGVmYXVsdF9jb250ZXh0ID0gMDsKLQlzcC0+ZGVm
YXVsdF90aW1ldG9saXZlID0gMDsKKwlzcC0+ZGVmYXVsdF9wcl9wb2xpY3kgPSBTQ1RQX1BSX1ND
VFBfTk9ORTsKKwlzcC0+ZGVmYXVsdF9wcl92YWx1ZSA9IDA7CiAKIAlzcC0+ZGVmYXVsdF9yY3Zf
Y29udGV4dCA9IDA7CiAJc3AtPm1heF9idXJzdCA9IHNjdHBfbWF4X2J1cnN0OwpAQCAtNDgyNCw3
ICs0ODI4LDcgQEAgc3RhdGljIGludCBzY3RwX2dldHNvY2tvcHRfYWRhcHRhdGlvbl9sYXllcihz
dHJ1Y3Qgc29jayAqc2ssIGludCBsZW4sCiAgKiAgIGluIHRvIHRoaXMgY2FsbCB0aGUgc2N0cF9z
bmRyY3ZpbmZvIHN0cnVjdHVyZSBkZWZpbmVkIGluIFNlY3Rpb24KICAqICAgNS4yLjIpIFRoZSBp
bnB1dCBwYXJhbWV0ZXJzIGFjY2VwdGVkIGJ5IHRoaXMgY2FsbCBpbmNsdWRlCiAgKiAgIHNpbmZv
X3N0cmVhbSwgc2luZm9fZmxhZ3MsIHNpbmZvX3BwaWQsIHNpbmZvX2NvbnRleHQsCi0gKiAgIHNp
bmZvX3RpbWV0b2xpdmUuICBUaGUgdXNlciBtdXN0IHByb3ZpZGUgdGhlIHNpbmZvX2Fzc29jX2lk
IGZpZWxkIGluCisgKiAgIHNpbmZvX3ByX3ZhbHVlLiAgVGhlIHVzZXIgbXVzdCBwcm92aWRlIHRo
ZSBzaW5mb19hc3NvY19pZCBmaWVsZCBpbgogICogICB0byB0aGlzIGNhbGwgaWYgdGhlIGNhbGxl
ciBpcyB1c2luZyB0aGUgVURQIG1vZGVsLgogICoKICAqICAgRm9yIGdldHNvY2tvcHQsIGl0IGdl
dCB0aGUgZGVmYXVsdCBzY3RwX3NuZHJjdmluZm8gc3RydWN0dXJlLgpAQCAtNDg1NCwxMyArNDg1
OCwxNSBAQCBzdGF0aWMgaW50IHNjdHBfZ2V0c29ja29wdF9kZWZhdWx0X3NlbmRfcGFyYW0oc3Ry
dWN0IHNvY2sgKnNrLAogCQlpbmZvLnNpbmZvX2ZsYWdzID0gYXNvYy0+ZGVmYXVsdF9mbGFnczsK
IAkJaW5mby5zaW5mb19wcGlkID0gYXNvYy0+ZGVmYXVsdF9wcGlkOwogCQlpbmZvLnNpbmZvX2Nv
bnRleHQgPSBhc29jLT5kZWZhdWx0X2NvbnRleHQ7Ci0JCWluZm8uc2luZm9fdGltZXRvbGl2ZSA9
IGFzb2MtPmRlZmF1bHRfdGltZXRvbGl2ZTsKKwkJaW5mby5zaW5mb19wcl9wb2xpY3kgPSBhc29j
LT5kZWZhdWx0X3ByX3BvbGljeTsKKwkJaW5mby5zaW5mb19wcl92YWx1ZSA9IGFzb2MtPmRlZmF1
bHRfcHJfdmFsdWU7CiAJfSBlbHNlIHsKIAkJaW5mby5zaW5mb19zdHJlYW0gPSBzcC0+ZGVmYXVs
dF9zdHJlYW07CiAJCWluZm8uc2luZm9fZmxhZ3MgPSBzcC0+ZGVmYXVsdF9mbGFnczsKIAkJaW5m
by5zaW5mb19wcGlkID0gc3AtPmRlZmF1bHRfcHBpZDsKIAkJaW5mby5zaW5mb19jb250ZXh0ID0g
c3AtPmRlZmF1bHRfY29udGV4dDsKLQkJaW5mby5zaW5mb190aW1ldG9saXZlID0gc3AtPmRlZmF1
bHRfdGltZXRvbGl2ZTsKKwkJaW5mby5zaW5mb19wcl9wb2xpY3kgPSBzcC0+ZGVmYXVsdF9wcl9w
b2xpY3k7CisJCWluZm8uc2luZm9fcHJfdmFsdWUgPSBzcC0+ZGVmYXVsdF9wcl92YWx1ZTsKIAl9
CiAKIAlpZiAocHV0X3VzZXIobGVuLCBvcHRsZW4pKQpAQCAtNjEwNiwxMSArNjExMiwxOCBAQCBT
Q1RQX1NUQVRJQyBpbnQgc2N0cF9tc2doZHJfcGFyc2UoY29uc3Qgc3RydWN0IG1zZ2hkciAqbXNn
LAogCQkJY21zZ3MtPmluZm8gPQogCQkJCShzdHJ1Y3Qgc2N0cF9zbmRyY3ZpbmZvICopQ01TR19E
QVRBKGNtc2cpOwogCi0JCQkvKiBNaW5pbWFsbHksIHZhbGlkYXRlIHRoZSBzaW5mb19mbGFncy4g
Ki8KLQkJCWlmIChjbXNncy0+aW5mby0+c2luZm9fZmxhZ3MgJgorCQkJaWYgKChjbXNncy0+aW5m
by0+c2luZm9fZmxhZ3MgJiAweGZmMDApICYKIAkJCSAgICB+KFNDVFBfVU5PUkRFUkVEIHwgU0NU
UF9BRERSX09WRVIgfAotCQkJICAgICAgU0NUUF9BQk9SVCB8IFNDVFBfRU9GKSkKKwkJCSAgICBT
Q1RQX0FCT1JUIHwgU0NUUF9FT0YpKQogCQkJCXJldHVybiAtRUlOVkFMOworCisJCQlpZihjbXNn
cy0+aW5mby0+c2luZm9fcHJfcG9saWN5ICE9IFNDVFBfUFJfU0NUUF9OT05FICYmCisJCQkgICAg
Y21zZ3MtPmluZm8tPnNpbmZvX3ByX3BvbGljeSAhPSBTQ1RQX1BSX1NDVFBfVFRMKQorCQkJCXJl
dHVybiAtRUlOVkFMOworCisJCQlpZihjbXNncy0+aW5mby0+c2luZm9fcHJfdmFsdWUgPCAwKQor
CQkJCXJldHVybiAtRUlOVkFMOworCiAJCQlicmVhazsKIAogCQlkZWZhdWx0OgpkaWZmIC0tZ2l0
IGEvbmV0L3NjdHAvdWxwZXZlbnQuYyBiL25ldC9zY3RwL3VscGV2ZW50LmMKaW5kZXggNWYxODZj
YS4uOTUxN2U0NyAxMDA2NDQKLS0tIGEvbmV0L3NjdHAvdWxwZXZlbnQuYworKysgYi9uZXQvc2N0
cC91bHBldmVudC5jCkBAIC05NDgsNyArOTQ4LDggQEAgdm9pZCBzY3RwX3VscGV2ZW50X3JlYWRf
c25kcmN2aW5mbyhjb25zdCBzdHJ1Y3Qgc2N0cF91bHBldmVudCAqZXZlbnQsCiAJc2luZm8uc2lu
Zm9fY29udGV4dCA9IGV2ZW50LT5hc29jLT5kZWZhdWx0X3Jjdl9jb250ZXh0OwogCiAJLyogVGhl
c2UgZmllbGRzIGFyZSBub3QgdXNlZCB3aGlsZSByZWNlaXZpbmcuICovCi0Jc2luZm8uc2luZm9f
dGltZXRvbGl2ZSA9IDA7CisJc2luZm8uc2luZm9fcHJfcG9saWN5ID0gU0NUUF9QUl9TQ1RQX05P
TkU7CisJc2luZm8uc2luZm9fcHJfdmFsdWUgPSAwOwogCiAJcHV0X2Ntc2cobXNnaGRyLCBJUFBS
T1RPX1NDVFAsIFNDVFBfU05EUkNWLAogCQkgc2l6ZW9mKHN0cnVjdCBzY3RwX3NuZHJjdmluZm8p
LCAodm9pZCAqKSZzaW5mbyk7Ci0tIAoxLjUuNi4zCgo=
------=_Part_38224_11416414.1229594594822--
