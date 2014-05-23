From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 23 May 2014 14:59:21 +0000
Subject: Re: [PATCH lksctp-tools] A few things that should get the API closer to RFC6458 compliancy
Message-Id: <537F6249.8070409@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAB7CvPO0y4jCYagHVkbL3-g4iq22WLpsucBjou30ruPtWFvUHw@mail.gmail.com>
In-Reply-To: <CAB7CvPO0y4jCYagHVkbL3-g4iq22WLpsucBjou30ruPtWFvUHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


On 05/23/2014 04:10 AM, Geir Ola Vaagland wrote:
> 
> 2014-05-23 3:39 GMT+02:00 Vlad Yasevich <vyasevich@gmail.com>:
>> On 05/22/2014 03:40 PM, Geir Ola Vaagland wrote:
>>> Hey,
>>>
>>> During my short master thesis I have come up with this code for adding
>>> the following features:
>>>
>>> * Support for sctp_sndinfo/sctp_rcvinfo/sctp_nxtinfo ancillary data.
>>> This includes the SCTP_RECV{NXT,RCV}INFO socket options.
>>> * Support for the SCTP_DEFAULT_SNDINFO socket option.
>>> * Additionally, although not really a "feature", it should set the
>>> SCTP_COMPLETE flag for complete messages now. I hope this is properly
>>> done.
>>>
>>> I have attached two patches. My recursive diff didn't catch any
>>> changes to include/uapi/sctp.h for some reason, so I had to make
>>> another one manually. (And I had to patch it with -p0, sorry.. I am
>>> new to this.)
>>>
>>> I am currently just looking for a review of the submitted code. I am
>>> curious to know whether it can be used or not.
>>>
>>
>> Hi Geir
>>
>> It's a good beginning.  It would be excellent if you could dedicate a
>> bit more time to break up the big patch into a series with
>> proper sign-offs.  Read Documentation/SubmittingPatches for
>> proper patch submissions.
>>
>> For kernel submissions, the component is 'sctp', not lksctp-tools.
>>
>>> I have ported the sctp_sendv() and sctp_recvv() functions from
>>> FreeBSD. I don't know if those are good enough to be submitted yet
>>> though. Let me know what you think. Any feedback is good feedback for
>>> my thesis.)
>>>
>>
>> I don't remember if BSD did these as system calls.  If they did, then
>> that most likely will not work.  If they are just library functions that
>> call sendmsg(), then feel free to post to linux-sctp list.  The
>> lksctp-tools project uses the same patch submission rules as the kernel.
>>
> 
> BSD did them as library functions. There is one change that I had to
> make that I'm not too sure of though. sctp_sendv() had two checks like
> this, that I just have commented out. Not sure how to do the same in
> Linux, but since it appears to be free'ing cmsgbuf, it might be
> causing a leak in some situations in my version of them.
> 
> if (addr_in->sin_len != addr_len) {
>     free(cmsgbuf);
>     errno = EINVAL;
>     return (-1);
> }
> ...
> if (addr_in6->sin6_len != addr_len) {
>     free(cmsgbuf);
>     errno = EINVAL;
>     return (-1);
> }
> 
> Where addr_in and addr_in6 are of types sockaddr_in* and sockaddr_in6
> respectively. In Linux, these does not appear to have a member
> sin_len. Do you know how to check the same length in Linux, or if it
> is not necessary for some reason?

Linux never implemented len member in the sockaddr structure.
I see that BSD is trying to validate the the address that was passed
in makes sense.  Can't really do it this way in linux, so you'd have
to assume length based on sa_family.  If someone sends in corrupt
buffer, then either the family or the port will not be valid on the
next address and we'll detect it then.  If both of those happen to
validate, then there is not much we can do and try to send to what's
there.


> 
> If you want to check it out closer the full function from FreeBSD can
> be found at https://gitorious.org/freebsd/freebsd/source/3e6fa68a2c696c93252e4ee0cc3aed119b940bc5:lib/libc/net/sctp_sys_calls.c#L1081-1092
> and the linenumbers are 1067 and 1092.
> 
> 
> 
>>> Best regards,
>>> Geir Ola
>>>
>>>
>>> full.patch
>>>
>>
>> First of all, please split up the one giant patch into a series.
>> The simplest one would probably be one patch per socket option.
>>
>>>
>>> diff -uprN -X Documentation/dontdiff ./include/net/sctp/structs.h /home/geo/buildkernel/core/linux3/src/linux-3.13/include/net/sctp/structs.h
>>> --- ./include/net/sctp/structs.h      2014-01-20 03:40:07.000000000 +0100
>>> +++ /home/geo/buildkernel/core/linux3/src/linux-3.13/include/net/sctp/structs.h       2014-05-22 03:47:12.363968071 +0200
>>> @@ -216,6 +216,9 @@ struct sctp_sock {
>>>       __u8 frag_interleave;
>>>       __u32 adaptation_ind;
>>>       __u32 pd_point;
>>> +     __u8 recvrcvinfo;
>>> +     __u8 recvnxtinfo;
>>> +
>>>
>>>       atomic_t pd_mode;
>>>       /* Receive to here while partial delivery is in effect. */
>>> @@ -1920,7 +1923,9 @@ struct sctp_chunk *sctp_get_ecne_prepend
>>>  /* A convenience structure to parse out SCTP specific CMSGs. */
>>>  typedef struct sctp_cmsgs {
>>>       struct sctp_initmsg *init;
>>> -     struct sctp_sndrcvinfo *info;
>>> +     void * info;
>>> +     __u32 cmsg_len;
>>> +     sctp_cmsg_t cmsg_type;
>>
>> cmsg_len doesn't seem to be used.  Also, I am not crazy about the usage
>> of void.  It requires some rather ugly casts when you want to use it.
>> Just define a union  and keep the type to identify which
>> member of the union to use.
>>
> 
> I don't have much experience with unions, but I should be able to change that.

typedef strut sctp_cmsgs {
    struct sctp_initmsg *init;
    union {
        struct sctp_sndrcvinfo *srinfo;
        struct sctp_sndinfo *sinfo;
        struct sctp_rcvinfo *rinfo;
    } info;
    sctp_cmsg_t sinfo_type;
} sctp_cmsgs_t;

#define sr_info info.srinfo
#define s_info  info.sinfo
#define r_info  info.rinfo

sctp_cmsgs_t cmsgs;

if (cmsgs.sinfo_type = SCTP_SNDRCV)
    /* use cmsgs.sr_info */
else if (cmsgs.sinfo_type = SCTP_RCVINFO)
   /* use cmsgs.r_info */

> 
>>>  } sctp_cmsgs_t;
>>>
>>>  /* Structure for tracking memory objects */
>>> diff -uprN -X Documentation/dontdiff ./include/net/sctp/ulpevent.h /home/geo/buildkernel/core/linux3/src/linux-3.13/include/net/sctp/ulpevent.h
>>> --- ./include/net/sctp/ulpevent.h     2014-01-20 03:40:07.000000000 +0100
>>> +++ /home/geo/buildkernel/core/linux3/src/linux-3.13/include/net/sctp/ulpevent.h      2014-05-22 03:47:12.367301620 +0200
>>> @@ -131,6 +131,10 @@ struct sctp_ulpevent *sctp_ulpevent_make
>>>
>>>  void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
>>>       struct msghdr *);
>>> +void sctp_ulpevent_read_rcvinfo(const struct sctp_ulpevent *event,
>>> +     struct msghdr *);
>>> +void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
>>> +     struct msghdr *, struct sk_buff*);
>>>  __u16 sctp_ulpevent_get_notification_type(const struct sctp_ulpevent *event);
>>>
>>>  /* Is this event type enabled? */
>>> diff -uprN -X Documentation/dontdiff ./net/sctp/socket.c /home/geo/buildkernel/core/linux3/src/linux-3.13/net/sctp/socket.c
>>> --- ./net/sctp/socket.c       2014-05-22 03:47:46.114491530 +0200
>>> +++ /home/geo/buildkernel/core/linux3/src/linux-3.13/net/sctp/socket.c        2014-05-22 03:47:12.360634500 +0200
>>> @@ -1599,6 +1599,7 @@ static int sctp_sendmsg(struct kiocb *io
>>>       struct sockaddr *msg_name = NULL;
>>>       struct sctp_sndrcvinfo default_sinfo;
>>>       struct sctp_sndrcvinfo *sinfo;
>>> +     struct sctp_sndinfo *sndinfo = NULL;
>>>       struct sctp_initmsg *sinit;
>>>       sctp_assoc_t associd = 0;
>>>       sctp_cmsgs_t cmsgs = { NULL };
>>> @@ -1648,7 +1649,18 @@ static int sctp_sendmsg(struct kiocb *io
>>>               msg_name = msg->msg_name;
>>>       }
>>>
>>> -     sinfo = cmsgs.info;
>>> +     if(cmsgs.cmsg_type = SCTP_SNDINFO){
>>> +             sndinfo = (struct sctp_sndinfo*) cmsgs.info;
>>> +             memset(&default_sinfo, 0, sizeof(default_sinfo));
>>> +             default_sinfo.sinfo_flags = sndinfo->snd_flags;
>>> +             default_sinfo.sinfo_stream = sndinfo->snd_sid;
>>> +             default_sinfo.sinfo_assoc_id = sndinfo->snd_assoc_id;
>>> +             default_sinfo.sinfo_ppid = sndinfo->snd_ppid;
>>> +             default_sinfo.sinfo_context = sndinfo->snd_context;
>>> +             sinfo = &default_sinfo;
>>> +     }else{
>>> +             sinfo = cmsgs.info;
>>> +     }
>>>       sinit = cmsgs.init;
>>>
>>>       /* Did the user specify SNDRCVINFO?  */
>>> @@ -1857,10 +1869,15 @@ static int sctp_sendmsg(struct kiocb *io
>>>       /* ASSERT: we have a valid association at this point.  */
>>>       pr_debug("%s: we have a valid association\n", __func__);
>>>
>>> -     if (!sinfo) {
>>> +     if(sndinfo){
>>> +             default_sinfo.sinfo_timetolive = asoc->default_timetolive;
>>> +     }
>>> +
>>
>> I'd stick this with the code above that sets up default_sinfo.  Then you
>> don't need the sndinfo pointer.
>>
> 
> Ok, that should be easy enough. Thanks :-)
> 
>>> +     if (!sinfo && !sndinfo) {
>>>               /* If the user didn't specify SNDRCVINFO, make up one with
>>>                * some defaults.
>>>                */
>>> +             pr_debug("%s: creating default sndrcvinfo.\n", __func__);
>>>               memset(&default_sinfo, 0, sizeof(default_sinfo));
>>>               default_sinfo.sinfo_stream = asoc->default_stream;
>>>               default_sinfo.sinfo_flags = asoc->default_flags;
>>> @@ -2048,9 +2065,9 @@ static int sctp_recvmsg(struct kiocb *io
>>>                       struct msghdr *msg, size_t len, int noblock,
>>>                       int flags, int *addr_len)
>>>  {
>>> -     struct sctp_ulpevent *event = NULL;
>>> +     struct sctp_ulpevent *event = NULL, *nxt_event = NULL;
>>>       struct sctp_sock *sp = sctp_sk(sk);
>>> -     struct sk_buff *skb;
>>> +     struct sk_buff *skb, *nxtskb;
>>>       int copied;
>>>       int err = 0;
>>>       int skb_len;
>>> @@ -2094,9 +2111,30 @@ static int sctp_recvmsg(struct kiocb *io
>>>               sp->pf->skb_msgname(skb, msg->msg_name, addr_len);
>>>       }
>>>
>>> -     /* Check if we allow SCTP_SNDRCVINFO. */
>>> -     if (sp->subscribe.sctp_data_io_event)
>>> +     if(sp->recvrcvinfo){
>>> +             sctp_ulpevent_read_rcvinfo(event, msg);
>>> +     }
>>> +
>>> +
>>> +     if(sp->recvnxtinfo){
>>> +             spin_lock_bh(&sk->sk_receive_queue.lock);
>>> +             nxtskb = skb_peek(&sk->sk_receive_queue);
>>> +             if (nxtskb)
>>> +                     atomic_inc(&nxtskb->users);
>>> +             spin_unlock_bh(&sk->sk_receive_queue.lock);
>>
>> Might be cleaner to peek at the skb by using sctp_skb_recv_datagram()
>> with proper flags.
>>
> 
> Great tip, I was feeling that bit was a bit sketchy. I just saw that
> skb_peek had been used similarly at other points in that file. I'll
> look into it.

It only used in one spot and it's better to keep there.  In fact, looks
like the locking around it might be unnecessary, but I need to look closer.

> 
>>> +
>>> +             if (nxtskb && nxtskb->len){
>>> +                     nxt_event = sctp_skb2event(nxtskb);
>>> +                     sctp_ulpevent_read_nxtinfo(nxt_event, msg, nxtskb);
>>> +             }
>>> +     }
>>> +
>>> +     if (sp->subscribe.sctp_data_io_event){
>>> +             /* Check if we allow SCTP_SNDRCVINFO. */
>>>               sctp_ulpevent_read_sndrcvinfo(event, msg);
>>> +     }
>>> +
>>> +
>>
>> You also appear to be leaking the nxtskb.
>>
> 
> Oops...I'll look into it.
> 

>>> diff -uprN -X Documentation/dontdiff ./net/sctp/ulpevent.c /home/geo/buildkernel/core/linux3/src/linux-3.13/net/sctp/ulpevent.c
>>> --- ./net/sctp/ulpevent.c     2014-01-20 03:40:07.000000000 +0100
>>> +++ /home/geo/buildkernel/core/linux3/src/linux-3.13/net/sctp/ulpevent.c      2014-05-22 03:47:12.363968071 +0200
>>> @@ -750,6 +750,15 @@ struct sctp_ulpevent *sctp_ulpevent_make
>>>               event->flags |= SCTP_UNORDERED;
>>>               event->cumtsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map);
>>>       }
>>> +
>>> +     if (chunk->chunk_hdr->flags & SCTP_DATA_FIRST_FRAG &&
>>> +         chunk->chunk_hdr->flags & SCTP_DATA_LAST_FRAG) {
>>> +             event->flags |= SCTP_COMPLETE;
>>> +     }
>>> +
>>
>> This doesn't look right.  This function is called every time
>> you try to push data up to the socket.  After this function is
>> called, we could be calling reassembly and ordering functions.
>> The above code only catches the case where the data is not a fragment.
>> If you are dealing with fragments, you'll never set SCTP_COMPLETE.
>>
>> This should probably be set in the reassembly code somewhere..
>>
> 
> I am sure you are right. I will see if I can figure it out, and if
> not, I'll just skip doing that part. It doesn't seem very important
> right now, right?

Well, it might be needed to do the new options correctly.

That's all for now.  Another thing to keep in mind, any technical
discussion need to be directed to the lists so there is a record of it
and so that one person doesn't tell you do something utterly stupid
privately and you spend a ton of your time doing something that will
be ripped apart on the list.

-vlad

> 
>>> +
>>> +
>>> +
>>>       event->tsn = ntohl(chunk->subh.data_hdr->tsn);
>>>       event->msg_flags |= chunk->chunk_hdr->flags;
>>>       event->iif = sctp_chunk_iif(chunk);
>>> @@ -900,6 +909,155 @@ __u16 sctp_ulpevent_get_notification_typ
>>>       return notification->sn_header.sn_type;
>>>  }
>>>
>>> +
>>> +void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
>>> +                                struct msghdr *msghdr, struct sk_buff* skb)
>>> +{
>>> +     struct sctp_nxtinfo nxtinfo;
>>> +
>>> +     if (sctp_ulpevent_is_notification(event)){
>>> +             return;
>>> +     }
>>> +
>>> +     /* Sockets API Extensions for SCTP
>>> +      * Section 5.3.6 SCTP Next Receive Information Structure (SCTP_NXTINFO)
>>> +      *
>>> +      * nxt_sid: 16 bits (unsigned integer)
>>> +      *
>>> +      * The SCTP stack places the next message's stream number in
>>> +      * this value.
>>> +     */
>>> +     nxtinfo.nxt_sid = event->stream;
>>> +
>>> +     /* nxt_ppid: 32 bits (unsigned integer)
>>> +      *
>>> +      * This value is the same information that was passed by the
>>> +              * upper layer in the peer application for the next message.  Please
>>> +              * note  that the SCTP stack performs no byte order modification of
>>> +              * this field.  For example, if the DATA chunk has to contain a given
>>> +              * value in network byte order, the SCTP user has to perform the
>>> +              * ntohl() computation.
>>> +     */
>>> +     nxtinfo.nxt_ppid = event->ppid;
>>> +
>>> +     /* nxt_flags: 16 bits (unsigned integer)
>>> +      *
>>> +      * This field may contain any of the following flags and is
>>> +              * composed of a bitwise OR of these values.
>>> +     */
>>> +     nxtinfo.nxt_flags = event->flags;
>>> +     /* nxt_length: 32 bits (unsigned integer)
>>> +      *
>>> +      * This value is the length of the message currently within
>>> +      * the socket buffer.  This might NOT be the entire length of the
>>> +      * message, since a partial delivery may be in progress.  Only if the
>>> +      * flag SCTP_COMPLETE is set in the nxt_flags field does this field
>>> +      * represent the size of the entire next message.
>>> +     */
>>> +     nxtinfo.nxt_length = skb->len;
>>> +
>>> +     /* nxt_assoc_id: sizeof(sctp_assoc_t)
>>> +      * The association handle field of the next message,
>>> +      * nxt_assoc_id, holds the identifier for the association
>>> +      * announced in the SCTP_COMM_UP notification.  All
>>> +      * notifications for a given association have the same
>>> +      * identifier.  This field is ignored for one-to-one style
>>> +      * sockets.
>>> +      */
>>> +     nxtinfo.nxt_assoc_id = sctp_assoc2id(event->asoc);
>>> +
>>> +     put_cmsg(msghdr, IPPROTO_SCTP, SCTP_NXTINFO,
>>> +              sizeof(struct sctp_nxtinfo), (void *)&nxtinfo);
>>> +}
>>> +void sctp_ulpevent_read_rcvinfo(const struct sctp_ulpevent *event,
>>> +                                struct msghdr *msghdr)
>>> +{
>>> +     struct sctp_rcvinfo rinfo;
>>> +
>>> +     if (sctp_ulpevent_is_notification(event)){
>>> +             return;
>>> +     }
>>> +
>>> +     /* Sockets API Extensions for SCTP
>>> +      * Section 5.3.5 SCTP Receive Information Structure (SCTP_SNDRCV)
>>> +      *
>>> +      * rcv_sid: 16 bits (unsigned integer)
>>> +      *
>>> +      * The SCTP stack places the message's stream number in this
>>> +      * value.
>>> +     */
>>> +     rinfo.rcv_sid = event->stream;
>>> +
>>> +     /* rcv_ssn: 16 bits (unsigned integer)
>>> +      * This value contains the stream sequence number that the
>>> +      * remote endpoint placed in the DATA chunk.  For fragmented
>>> +      * messages, this is the same number for all deliveries of the
>>> +      * message (if more than one recvmsg() is needed to read
>>> +      * the message)
>>> +     */
>>> +     rinfo.rcv_ssn = event->ssn;
>>> +
>>> +     /* rcv_ppid: 32 bits (unsigned integer)
>>> +      *
>>> +      * This value is the same information that was passed by the
>>> +      * upper layer in the peer application.  Please note that the SCTP
>>> +      * stack performs no byte order modification of this field.
>>> +      * For example, if the DATA chunk has to contain a given
>>> +      * value in network byte order, the SCTP user has to perform the
>>> +      * ntohl() computation.
>>> +     */
>>> +     rinfo.rcv_ppid = event->ppid;
>>> +
>>> +     /* rcv_flags: 16 bits (unsigned integer)
>>> +      *
>>> +      * This field may contain any of the following flags and is composed of
>>> +      * a bitwise OR of these values.
>>> +      *
>>> +      * recvmsg() flags:
>>> +      *
>>> +      * SCTP_UNORDERED - This flag is present when the message was sent
>>> +      *                 non-ordered.
>>> +      */
>>> +
>>> +     rinfo.rcv_flags = event->flags;
>>> +
>>> +     /* rcv_tsn: 32 bits (unsigned integer)
>>> +      *
>>> +      * This field holds a TSN that was assigned to one of the SCTP
>>> +      * DATA chunks.
>>> +      */
>>> +     rinfo.rcv_tsn = event->tsn;
>>> +
>>> +     /* rcv_cumtsn: 32 bits (unsigned integer)
>>> +      *
>>> +      * This field will hold the current cumulative TSN as known
>>> +      * by the underlying SCTP layer.
>>> +      */
>>> +     rinfo.rcv_cumtsn = event->cumtsn;
>>> +
>>> +     /* rcv_assoc_id: sizeof (sctp_assoc_t)
>>> +      *
>>> +      * The association handle field, sinfo_assoc_id, holds the identifier
>>> +      * for the association announced in the COMMUNICATION_UP notification.
>>> +      * All notifications for a given association have the same identifier.
>>> +      * Ignored for one-to-one style sockets.
>>> +      */
>>> +     rinfo.rcv_assoc_id = sctp_assoc2id(event->asoc);
>>> +
>>> +     /* rcv_context: 32 bits (unsigned integer)
>>> +      *
>>> +      * This value is an opaque 32-bit context datum that was
>>> +      * set by the user with the SCTP_CONTEXT socket option.  This
>>> +      * value is passed back to the upper layer if an error occurs on
>>> +      * the send of a message and is retrieved with each undelivered
>>> +      * message.
>>> +     */
>>> +     rinfo.rcv_context = event->asoc->default_rcv_context;
>>> +
>>> +     put_cmsg(msghdr, IPPROTO_SCTP, SCTP_RCVINFO,
>>> +              sizeof(struct sctp_rcvinfo), (void *)&rinfo);
>>> +}
>>> +
>>>  /* Copy out the sndrcvinfo into a msghdr.  */
>>>  void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
>>>                                  struct msghdr *msghdr)
>>>
>>>
>>> sctp.h.patch
>>>
>>>
>>> diff (GNU diffutils) 3.3
>>> Copyright (C) 2013 Free Software Foundation, Inc.
>>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
>>> This is free software: you are free to change and redistribute it.
>>> There is NO WARRANTY, to the extent permitted by law.
>>>
>>> Written by Paul Eggert, Mike Haertel, David Hayes,
>>> Richard Stallman, and Len Tower.
>>> --- include/uapi/linux/sctp.h 2014-01-20 03:40:07.000000000 +0100
>>> +++ /home/geo/buildkernel/core/linux3/src/linux-3.13/include/uapi/linux/sctp.h        2014-05-22 03:47:12.357300905 +0200
>>> @@ -59,6 +59,10 @@
>>>
>>>  typedef __s32 sctp_assoc_t;
>>>
>>> +#define SCTP_FUTURE_ASSOC 0
>>> +#define SCTP_CURRENT_ASSOC 1
>>> +#define SCTP_ALL_ASSOC 2
>>> +
>>
>> Not used by the patched code
>>
> 
> Oh, thought I had removed those. Thanks for pointing it out:-)
> 
>>>  /* The following symbols come from the Sockets API Extensions for
>>>   * SCTP <draft-ietf-tsvwg-sctpsocket-07.txt>.
>>>   */
>>> @@ -90,13 +94,17 @@ typedef __s32 sctp_assoc_t;
>>>  #define SCTP_AUTH_KEY        23
>>>  #define SCTP_AUTH_ACTIVE_KEY 24
>>>  #define SCTP_AUTH_DELETE_KEY 25
>>>  #define SCTP_PEER_AUTH_CHUNKS        26
>>>  #define SCTP_LOCAL_AUTH_CHUNKS       27
>>>  #define SCTP_GET_ASSOC_NUMBER        28
>>>  #define SCTP_GET_ASSOC_ID_LIST       29
>>>  #define SCTP_AUTO_ASCONF       30
>>>  #define SCTP_PEER_ADDR_THLDS 31
>>>
>>> +#define SCTP_RECVRCVINFO     36
>>> +#define SCTP_RECVNXTINFO     37
>>> +#define SCTP_DEFAULT_SNDINFO 38
>>> +
>>>  /* Internal Socket Options. Some of the sctp library functions are
>>>   * implemented using these socket options.
>>>   */
>>> @@ -112,7 +120,7 @@ typedef __s32 sctp_assoc_t;
>>>  #define SCTP_GET_ASSOC_STATS 112     /* Read only */
>>>
>>>  /*
>>> - * 5.2.1 SCTP Initiation Structure (SCTP_INIT)
>>> + * 5.3.1 SCTP Initiation Structure (SCTP_INIT)
>>>   *
>>>   *   This cmsghdr structure provides information for initializing new
>>>   *   SCTP associations with sendmsg().  The SCTP_INITMSG socket option
>>> @@ -132,14 +140,19 @@ struct sctp_initmsg {
>>>  };
>>>
>>>  /*
>>> - * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>>> + * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>>>   *
>>>   *   This cmsghdr structure specifies SCTP options for sendmsg() and
>>>   *   describes SCTP header information about a received message through
>>>   *   recvmsg().
>>>   *
>>> + *   (DEPRECATED) - SCTP_SNDINFO (described in Section 5.3.4) and SCTP_RCVINFO
>>> + *                  (described in Section 5.3.5) split this information.  These
>>> + *               structures should be used, when possible, since SCTP_SNDRCV
>>> + *                  is deprecated.
>>> + *
>>>   *   cmsg_level    cmsg_type      cmsg_data[]
>>> - *   ------------  ------------   ----------------------
>>> + *   ------------  -----------    ----------------------
>>>   *   IPPROTO_SCTP  SCTP_SNDRCV    struct sctp_sndrcvinfo
>>>   *
>>>   */
>>> @@ -155,6 +168,66 @@ struct sctp_sndrcvinfo {
>>>       sctp_assoc_t sinfo_assoc_id;
>>>  };
>>>
>>> +/*
>>> + * 5.3.4 SCTP Send Information Structure (SCTP_SNDINFO)
>>> + *
>>> + *   This cmsghdr structure specifies SCTP options for sendmsg().
>>> + *
>>> + *   cmsg_level    cmsg_type      cmsg_data[]
>>> + *   ------------  ------------   -------------------
>>> + *   IPPROTO_SCTP  SCTP_SNDINFO   struct sctp_sndinfo
>>> + *
>>> + */
>>> +
>>> +struct sctp_sndinfo {
>>> +     __u16 snd_sid;
>>> +     __u16 snd_flags;
>>> +     __u32 snd_ppid;
>>> +     __u32 snd_context;
>>> +     sctp_assoc_t snd_assoc_id;
>>> +};
>>> +
>>> +/*
>>> + * 5.3.5 SCTP Receive Information Structure (SCTP_RCVINFO)
>>> + *
>>> + *   This cmsghdr structure specifies SCTP options for sendmsg().
>>> + *
>>> + *   cmsg_level    cmsg_type      cmsg_data[]
>>> + *   ------------  ------------   -------------------
>>> + *   IPPROTO_SCTP  SCTP_RCVINFO   struct sctp_rcvinfo
>>> + *
>>> + */
>>> +struct sctp_rcvinfo {
>>> +     __u16 rcv_sid;
>>> +     __u16 rcv_ssn;
>>> +     __u16 rcv_flags;
>>> +     __u32 rcv_ppid;
>>> +     __u32 rcv_tsn;
>>> +     __u32 rcv_cumtsn;
>>> +     __u32 rcv_context;
>>> +     sctp_assoc_t rcv_assoc_id;
>>> +};
>>> +
>>> +/*
>>> + * 5.3.6. SCTP Next Receive Information Structure (SCTP_NXTINFO)
>>> + *
>>> + *   This cmsghdr structure describes SCTP receive information of the next
>>> + *   message that will be delivered through recvmsg() if this information
>>> + *   is already available when delivering the current message.
>>> + *
>>> + *   cmsg_level    cmsg_type      cmsg_data[]
>>> + *   ------------  ------------   -------------------
>>> + *   IPPROTO_SCTP  SCTP_NXTINFO   struct sctp_nxtinfo
>>> + *
>>> + */
>>> +struct sctp_nxtinfo {
>>> +    __u16 nxt_sid;
>>> +    __u16 nxt_flags;
>>> +    __u32 nxt_ppid;
>>> +    __u32 nxt_length;
>>> +    sctp_assoc_t nxt_assoc_id;
>>> +};
>>> +
>>>  /*
>>>   *  sinfo_flags: 16 bits (unsigned integer)
>>>   *
>>> @@ -168,6 +241,7 @@ enum sctp_sinfo_flags {
>>>       SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
>>>       SCTP_SACK_IMMEDIATELY = 8,      /* SACK should be sent without delay */
>>>       SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */
>>> +     SCTP_COMPLETE = 16,
>>>  };
>>>
>>>  typedef union {
>>> @@ -178,14 +252,20 @@ typedef union {
>>>
>>>  /* These are cmsg_types.  */
>>>  typedef enum sctp_cmsg_type {
>>> -     SCTP_INIT,              /* 5.2.1 SCTP Initiation Structure */
>>> +     SCTP_INIT,              /* 5.3.1 SCTP Initiation Structure */
>>>  #define SCTP_INIT    SCTP_INIT
>>> -     SCTP_SNDRCV,            /* 5.2.2 SCTP Header Information Structure */
>>> +     SCTP_SNDRCV,            /* 5.3.2 SCTP Header Information Structure */
>>>  #define SCTP_SNDRCV  SCTP_SNDRCV
>>> +     SCTP_SNDINFO,
>>> +#define SCTP_SNDINFO SCTP_SNDINFO
>>> +     SCTP_RCVINFO,
>>> +#define SCTP_RCVINFO SCTP_RCVINFO
>>> +     SCTP_NXTINFO,
>>> +#define SCTP_NXTINFO SCTP_NXTINFO
>>>  } sctp_cmsg_t;
>>>
>>>  /*
>>> - * 5.3.1.1 SCTP_ASSOC_CHANGE
>>> + * 6.1.1. SCTP_ASSOC_CHANGE
>>>   *
>>>   *   Communication notifications inform the ULP that an SCTP association
>>>   *   has either begun or ended. The identifier for a new association is
>>> @@ -223,7 +303,7 @@ enum sctp_sac_state {
>>>  };
>>>
>>>  /*
>>> - * 5.3.1.2 SCTP_PEER_ADDR_CHANGE
>>> + * 6.1.2. SCTP_PEER_ADDR_CHANGE
>>>   *
>>>   *   When a destination address on a multi-homed peer encounters a change
>>>   *   an interface details event is sent.  The information has the
>>> @@ -256,7 +336,7 @@ enum sctp_spc_state {
>>>
>>>
>>>  /*
>>> - * 5.3.1.3 SCTP_REMOTE_ERROR
>>> + * 6.1.3. SCTP_REMOTE_ERROR
>>>   *
>>>   *   A remote peer may send an Operational Error message to its peer.
>>>   *   This message indicates a variety of error conditions on an
>>> @@ -276,10 +356,14 @@ struct sctp_remote_error {
>>>
>>>
>>>  /*
>>> - * 5.3.1.4 SCTP_SEND_FAILED
>>> + * 6.1.4. SCTP_SEND_FAILED
>>>   *
>>>   *   If SCTP cannot deliver a message it may return the message as a
>>>   *   notification.
>>> + *
>>> + *   (DEPRECATED) - Please note that this notification is deprecated.  Use
>>> + *                  SCTP_SEND_FAILED_EVENT instead.
>>> + *
>>>   */
>>>  struct sctp_send_failed {
>>>       __u16 ssf_type;
>>> @@ -309,7 +393,7 @@ enum sctp_ssf_flags {
>>>  };
>>>
>>>  /*
>>> - * 5.3.1.5 SCTP_SHUTDOWN_EVENT
>>> + * 6.1.5. SCTP_SHUTDOWN_EVENT
>>>   *
>>>   *   When a peer sends a SHUTDOWN, SCTP delivers this notification to
>>>   *   inform the application that it should cease sending data.
>>> @@ -322,7 +406,7 @@ struct sctp_shutdown_event {
>>>  };
>>>
>>>  /*
>>> - * 5.3.1.6 SCTP_ADAPTATION_INDICATION
>>> + * 6.1.6 SCTP_ADAPTATION_INDICATION
>>>   *
>>>   *   When a peer sends a Adaptation Layer Indication parameter , SCTP
>>>   *   delivers this notification to inform the application
>>> @@ -337,7 +421,7 @@ struct sctp_adaptation_event {
>>>  };
>>>
>>>  /*
>>> - * 5.3.1.7 SCTP_PARTIAL_DELIVERY_EVENT
>>> + * 6.1.7 SCTP_PARTIAL_DELIVERY_EVENT
>>>   *
>>>   *   When a receiver is engaged in a partial delivery of a
>>>   *   message this notification will be used to indicate
>>> @@ -354,7 +438,7 @@ struct sctp_pdapi_event {
>>>  enum { SCTP_PARTIAL_DELIVERY_ABORTED=0, };
>>>
>>>  /*
>>> - * 5.3.1.8.  SCTP_AUTHENTICATION_EVENT
>>> + * 6.1.8.  SCTP_AUTHENTICATION_EVENT
>>>   *
>>>   *  When a receiver is using authentication this message will provide
>>>   *  notifications regarding new keys being made active as well as errors.
>>> @@ -372,7 +456,7 @@ struct sctp_authkey_event {
>>>  enum { SCTP_AUTH_NEWKEY = 0, };
>>>
>>>  /*
>>> - * 6.1.9. SCTP_SENDER_DRY_EVENT
>>> + * 6.1.9. SCTP_SENDER_DRY_EVENT (DEPRECATED)
>>>   *
>>>   * When the SCTP stack has no more user data to send or retransmit, this
>>>   * notification is given to the user. Also, at the time when a user app
>>> @@ -386,9 +470,13 @@ struct sctp_sender_dry_event {
>>>       sctp_assoc_t sender_dry_assoc_id;
>>>  };
>>>
>>> +
>>>  /*
>>> - * Described in Section 7.3
>>> + * Described in Section 6.2.1.
>>>   *   Ancillary Data and Notification Interest Options
>>> + *
>>> + *   (DEPRECATED) - Use the SCTP_EVENT option described in Section 6.2.2.
>>> + *                  instead.
>>>   */
>>>  struct sctp_event_subscribe {
>>>       __u8 sctp_data_io_event;
>>> @@ -404,7 +492,7 @@ struct sctp_event_subscribe {
>>>  };
>>>
>>>  /*
>>> - * 5.3.1 SCTP Notification Structure
>>> + * 6.1 SCTP Notification Structure
>>>   *
>>>   *   The notification structure is defined as the union of all
>>>   *   notification types.
>>> @@ -472,7 +560,7 @@ typedef enum sctp_sn_error {
>>>  } sctp_sn_error_t;
>>>
>>>  /*
>>> - * 7.1.1 Retransmission Timeout Parameters (SCTP_RTOINFO)
>>> + * 8.1.1 Retransmission Timeout Parameters (SCTP_RTOINFO)
>>>   *
>>>   *   The protocol parameters used to initialize and bound retransmission
>>>   *   timeout (RTO) are tunable.  See [SCTP] for more information on how
>>> @@ -486,7 +574,7 @@ struct sctp_rtoinfo {
>>>  };
>>>
>>>  /*
>>> - * 7.1.2 Association Parameters (SCTP_ASSOCINFO)
>>> + * 8.1.2 Association Parameters (SCTP_ASSOCINFO)
>>>   *
>>>   *   This option is used to both examine and set various association and
>>>   *   endpoint parameters.
>>> @@ -501,7 +589,7 @@ struct sctp_assocparams {
>>>  };
>>>
>>>  /*
>>> - * 7.1.9 Set Peer Primary Address (SCTP_SET_PEER_PRIMARY_ADDR)
>>> + * 8.3.1 Set Peer Primary Address (SCTP_SET_PEER_PRIMARY_ADDR)
>>>   *
>>>   *  Requests that the peer mark the enclosed address as the association
>>>   *  primary. The enclosed address must be one of the association's
>>> @@ -514,7 +602,7 @@ struct sctp_setpeerprim {
>>>  } __attribute__((packed, aligned(4)));
>>>
>>>  /*
>>> - * 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
>>> + * 8.1.9 Set Primary Address (SCTP_PRIMARY_ADDR)
>>>   *
>>>   *  Requests that the local SCTP stack use the enclosed peer address as
>>>   *  the association primary. The enclosed address must be one of the
>>> @@ -526,11 +614,8 @@ struct sctp_prim {
>>>       struct sockaddr_storage ssp_addr;
>>>  } __attribute__((packed, aligned(4)));
>>>
>>> -/* For backward compatibility use, define the old name too */
>>> -#define sctp_setprim sctp_prim
>>> -
>>>  /*
>>> - * 7.1.11 Set Adaptation Layer Indicator (SCTP_ADAPTATION_LAYER)
>>> + * 8.1.10 Set Adaptation Layer Indicator (SCTP_ADAPTATION_LAYER)
>>>   *
>>>   * Requests that the local endpoint set the specified Adaptation Layer
>>>   * Indication parameter for all future INIT and INIT-ACK exchanges.
>>> @@ -540,7 +625,7 @@ struct sctp_setadaptation {
>>>  };
>>>
>>>  /*
>>> - * 7.1.13 Peer Address Parameters  (SCTP_PEER_ADDR_PARAMS)
>>> + * 8.1.12 Peer Address Parameters  (SCTP_PEER_ADDR_PARAMS)
>>>   *
>>>   *   Applications can enable or disable heartbeats for any peer address
>>>   *   of an association, modify an address's heartbeat interval, force a
>>> @@ -574,7 +659,7 @@ struct sctp_paddrparams {
>>>  } __attribute__((packed, aligned(4)));
>>>
>>>  /*
>>> - * 7.1.18.  Add a chunk that must be authenticated (SCTP_AUTH_CHUNK)
>>> + * 8.3.2.  Add a chunk that must be authenticated (SCTP_AUTH_CHUNK)
>>>   *
>>>   * This set option adds a chunk type that the user is requesting to be
>>>   * received only in an authenticated way.  Changes to the list of chunks
>>> @@ -585,7 +670,7 @@ struct sctp_authchunk {
>>>  };
>>>
>>>  /*
>>> - * 7.1.19.  Get or set the list of supported HMAC Identifiers (SCTP_HMAC_IDENT)
>>> + * 8.1.17.  Get or set the list of supported HMAC Identifiers (SCTP_HMAC_IDENT)
>>>   *
>>>   * This option gets or sets the list of HMAC algorithms that the local
>>>   * endpoint requires the peer to use.
>>> @@ -611,7 +696,7 @@ struct sctp_hmacalgo {
>>>  #define shmac_number_of_idents       shmac_num_idents
>>>
>>>  /*
>>> - * 7.1.20.  Set a shared key (SCTP_AUTH_KEY)
>>> + * 8.3.3.  Set a shared key (SCTP_AUTH_KEY)
>>>   *
>>>   * This option will set a shared secret key which is used to build an
>>>   * association shared key.
>>> @@ -624,7 +709,7 @@ struct sctp_authkey {
>>>  };
>>>
>>>  /*
>>> - * 7.1.21.  Get or set the active shared key (SCTP_AUTH_ACTIVE_KEY)
>>> + * 8.1.18.  Get or set the active shared key (SCTP_AUTH_ACTIVE_KEY)
>>>   *
>>>   * This option will get or set the active shared key to be used to build
>>>   * the association shared key.
>>> @@ -637,7 +722,7 @@ struct sctp_authkeyid {
>>>
>>>
>>>  /*
>>> - * 7.1.23.  Get or set delayed ack timer (SCTP_DELAYED_SACK)
>>> + * 8.1.19.  Get or set delayed ack timer (SCTP_DELAYED_SACK)
>>>   *
>>>   * This option will effect the way delayed acks are performed.  This
>>>   * option allows you to get or set the delayed ack time, in
>>> @@ -662,7 +747,7 @@ struct sctp_assoc_value {
>>>  };
>>>
>>>  /*
>>> - * 7.2.2 Peer Address Information
>>> + * 8.2.2 Peer Address Information (SCTP_GET_PEER_ADDR_INFO)
>>>   *
>>>   *   Applications can retrieve information about a specific peer address
>>>   *   of an association, including its reachability state, congestion
>>> @@ -698,7 +783,7 @@ enum sctp_spinfo_state {
>>>  };
>>>
>>>  /*
>>> - * 7.2.1 Association Status (SCTP_STATUS)
>>> + * 8.2.1 Association Status (SCTP_STATUS)
>>>   *
>>>   *   Applications can retrieve current status information about an
>>>   *   association, including association state, peer receiver window size,
>>> @@ -719,7 +804,7 @@ struct sctp_status {
>>>  };
>>>
>>>  /*
>>> - * 7.2.3.  Get the list of chunks the peer requires to be authenticated
>>> + * 8.2.3.  Get the list of chunks the peer requires to be authenticated
>>>   *         (SCTP_PEER_AUTH_CHUNKS)
>>>   *
>>>   * This option gets a list of chunks for a specified association that
>>> @@ -844,3 +929,33 @@ struct sctp_paddrthlds {
>>>  };
>>>
>>
>> The section updates should be its own patch.  Anything that's
>> not pertaining to the functionality you are submitting needs to
>> be either removed or put into paches of their own.
> 
> Right, I forgot to mention that. Ok, I'll make a separate patch for that.
>>
>> Looking forward to the updated patches.
>> Thanks
>> -vlad
>>
>>>  #endif /* _UAPI_SCTP_H */
>>> +
>>> +
>>> +/* These are the sendv_flags in the sctp_sendv_spa struct */
>>> +#define SCTP_SEND_SNDINFO_VALID              0x00000001
>>> +#define SCTP_SEND_PRINFO_VALID               0x00000002
>>> +#define SCTP_SEND_AUTHINFO_VALID     0x00000004
>>> +
>>> +struct sctp_sendv_spa {
>>> +    __u32 sendv_flags;
>>> +    struct sctp_sndinfo sendv_sndinfo;
>>> +    /* struct sctp_prinfo sendv_prinfo;
>>> +     * struct sctp_authinfo sendv_authinfo;
>>> +     */
>>> +};
>>> +
>>> +#define SCTP_SENDV_NOINFO    0
>>> +#define SCTP_SENDV_SNDINFO   1
>>> +#define SCTP_SENDV_SPA               3
>>> +
>>> +struct sctp_recvv_rn {
>>> +    struct sctp_rcvinfo recvv_rcvinfo;
>>> +    struct sctp_nxtinfo recvv_nxtinfo;
>>> +};
>>> +
>>> +#define SCTP_RECVV_NOINFO    0
>>> +#define SCTP_RECVV_RCVINFO   1
>>> +#define SCTP_RECVV_NXTNFO    2
>>> +#define SCTP_RECVV_RN                3
>>> +
>>> +
>>>
>>

