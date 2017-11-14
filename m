From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 14 Nov 2017 08:27:41 +0000
Subject: Re: [PATCH net] sctp: check stream reset info len before making reconf chunk
Message-Id: <CADvbK_dJiVA9_x5RoepbXaKF7OesgiZp+DEhRdkyOkEh9zuaHw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <9ad1a0713999f4771e6f1050f4d17dc2d9ab1fe8.1510551567.git.lucien.xin@gmail.com>
 <20171113150934.GB7876@hmswarspite.think-freely.org> <CADvbK_debq8umStFwEiBrMj09X31TC+36_s41bTive9Pa8Ohaw@mail.gmail.com>
 <20171113195402.GG3675@localhost.localdomain>
In-Reply-To: <20171113195402.GG3675@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Dmitry Vyukov <dvyukov@google.com>, syzkaller <syzkaller@googlegroups.com>

On Tue, Nov 14, 2017 at 3:54 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Mon, Nov 13, 2017 at 11:15:40PM +0800, Xin Long wrote:
>> On Mon, Nov 13, 2017 at 11:09 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> > On Mon, Nov 13, 2017 at 01:39:27PM +0800, Xin Long wrote:
>> >> Now when resetting stream, if both in and out flags are set, the info
>> >> len can reach:
>> >>   sizeof(struct sctp_strreset_outreq) + SCTP_MAX_STREAM(65535) +
>> >>   sizeof(struct sctp_strreset_inreq)  + SCTP_MAX_STREAM(65535)
>> >> even without duplicated stream no, this value is far greater than the
>> >> chunk's max size.
>> >>
>> >> _sctp_make_chunk doesn't do any check for this, which would cause the
>> >> skb it allocs is huge, syzbot even reported a crash due to this.
>> >>
>> >> This patch is to check stream reset info len before making reconf
>> >> chunk and return NULL if the len exceeds chunk's capacity.
>> >>
>> >> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
>> >> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> >> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> >> ---
>> >>  net/sctp/sm_make_chunk.c | 7 +++++--
>> >>  net/sctp/stream.c        | 8 +++++---
>> >>  2 files changed, 10 insertions(+), 5 deletions(-)
>> >>
>> >> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
>> >> index 514465b..a21328a 100644
>> >> --- a/net/sctp/sm_make_chunk.c
>> >> +++ b/net/sctp/sm_make_chunk.c
>> >> @@ -3598,14 +3598,17 @@ struct sctp_chunk *sctp_make_strreset_req(
>> >>       __u16 stream_len = stream_num * 2;
>
> Unrelated, but.. won't stream_len overflow if stream_num >= 32768?
> When called form sctp_send_reset_streams() I don't see anything
> restricting it to such range.
right.

>
>> >>       struct sctp_strreset_inreq inreq;
>> >>       struct sctp_chunk *retval;
>> >> -     __u16 outlen, inlen;
>> >> +     int outlen, inlen;
>> >>
>> >>       outlen = (sizeof(outreq) + stream_len) * out;
>> >>       inlen = (sizeof(inreq) + stream_len) * in;
>> >>
>> >> +     if (outlen + inlen > SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_chunkhdr))
>> >> +             return ERR_PTR(-EINVAL);
>> >> +
>> > Why all the ERR_PTR manipulations here?  Just returning NULL, like the fuction
>> > has been doing is sufficient to set ENOMEM at both call sites
>> I don't like ERR_PTR handling here either,
>> But it shouldn't be ENOMEM, should it ?
>>
>> It may confuse users, but I'm also ok to let it just return
>> ENOMEM as you wish. wdyt ?
>
> Returning ENOMEM in the above error can be misleading. It's not that
> we cannot allocate it, it's that it won't fit the packet no matter how
> much memory we add to the system.
right.

let's move the check into sctp_send_reset_streams()

I believe this one fixes them both:
@@ -139,15 +139,31 @@ int sctp_send_reset_streams(struct sctp_association *asoc,

        str_nums = params->srs_number_streams;
        str_list = params->srs_stream_list;
-       if (out && str_nums)
-               for (i = 0; i < str_nums; i++)
-                       if (str_list[i] >= stream->outcnt)
-                               goto out;
+       if (str_nums) {
+               int param_len = 0;

-       if (in && str_nums)
-               for (i = 0; i < str_nums; i++)
-                       if (str_list[i] >= stream->incnt)
-                               goto out;
+               if (out) {
+                       for (i = 0; i < str_nums; i++)
+                               if (str_list[i] >= stream->outcnt)
+                                       goto out;
+
+                       param_len = str_nums * 2 +
+                                   sizeof(struct sctp_strreset_outreq);
+               }
+
+               if (in) {
+                       for (i = 0; i < str_nums; i++)
+                               if (str_list[i] >= stream->incnt)
+                                       goto out;
+
+                       param_len += str_nums * 2 +
+                                    sizeof(struct sctp_strreset_inreq);
+               }
+
+               if (param_len > SCTP_MAX_CHUNK_LEN -
+                               sizeof(struct sctp_reconf_chunk))
+                       goto out;
+       }


and int this fix,  it's good to do all checks only when str_nums !=0.
