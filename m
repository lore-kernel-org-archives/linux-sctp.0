From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 19 Dec 2013 14:37:01 +0000
Subject: Re: Send fail notifications
Message-Id: <52B3048D.7080209@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52B1AA25.3000700@mojatatu.com>
In-Reply-To: <52B1AA25.3000700@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/18/13 10:20, Vlad Yasevich wrote:
> On 12/18/2013 09:06 AM, Jamal Hadi Salim wrote:

> You receive one notification per chunk.  This is the way lksctp
> implemented failure notification.  Whether this is the right or
> wrong way to do it may be up for debate.
>

Ok, assuming the chunk size is corellated to MTU.
With large enough MTU i do receive the full notification + original
message in one read.

> As I said in the private thread that started this, current spec
> is referring to messages when it talks about SEND_FAILED[_EVENT].
> It covers the case where the whole message has failed and when
> partial message has failed, but it misses the case where parts
> of message failed for different reasons (SENT vs. UNSENT).  In
> particular the setting sinfo_flags in the sndrcvinfo structure
> aren't covered in this case.
>
> So, even when talking about messages, it's feasible that you would
> receive multiple notifications for the same message.  One may
> specify things like:
>     ssf_flags = SENT
>     sinfo.sinfo_flags = DATA_FIRST_FRAG
>
> the other may have:
>    ssf_info = UNSENT
>    sinfo.sinfo_flags = DATA_LAST_FRAG
>
> The EOR flags would be sent on each notification if was received
> by your application in full, since in this case EOR signals the
> end of a particular notification, the the end of the user data
> message we are reporting about.
>
> You could look at the sinfo_flags.  These flags will mirror the flags
> from the chunk thus allowing you to kind-of reassemble the data.

Aha, thanks.
Yes, I think these would good enough - painful but sufficient.
I wasnt paying close attention to the sinfo flags earlier
I still expect to receive the full message (although i have complained
about receiving the full message in the past ;->). I see the flag
starting with "2" middle is "0" and termination is "1". Sample log
for one of the messages that failed on my side is:
------
handle_send_failed: Data(cntx 91267) 1024B (0x2) possibly left
handle_send_failed: Data(cntx 91267) 1024B (0x0) possibly left
handle_send_failed: Data(cntx 91267) 1024B (0x0) possibly left
handle_send_failed: Data(cntx 91267) 1024B (0x0) possibly left
handle_send_failed: Data(cntx 91267) 1024B (0x0) possibly left
handle_send_failed: Data(cntx 91267) 1024B (0x0) possibly left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 1024B (0x0) never left
handle_send_failed: Data(cntx 91267) 892B (0x1) never left
-----


> The hitch here is the following text in the spec:
>     ssf_info:  This field includes the ancillary data (struct
>        sctp_sndrcvinfo) used to send the undelivered message
>                       ^^^^^^^^^^^^^^^^^^^^^^^
> lksctp follows that by simply copying the user supplied data, thus
> missing things like chunk ssn, tsn and other fields that could
> be useful in identifying this part of the message.
>

I am probably fine with what you described above.


> That really is the only reliable way to tell if the parts came from the
> same message.
> In fact, if you look at the description of sinfo_context in Section
> 5.3.2, you'll see that this is exactly what it's there for.
>

I love that feature ;-> So for now i will have to use both.
Note, our current use does not desire to retransmit such
a message - if it didnt make it then it is obsolete. But
we need to keep track which particular message didnt get
through; and for that we only need the first chunk.

cheers,
jamal
