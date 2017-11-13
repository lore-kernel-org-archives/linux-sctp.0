From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 13 Nov 2017 15:15:40 +0000
Subject: Re: [PATCH net] sctp: check stream reset info len before making reconf chunk
Message-Id: <CADvbK_debq8umStFwEiBrMj09X31TC+36_s41bTive9Pa8Ohaw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <9ad1a0713999f4771e6f1050f4d17dc2d9ab1fe8.1510551567.git.lucien.xin@gmail.com>
 <20171113150934.GB7876@hmswarspite.think-freely.org>
In-Reply-To: <20171113150934.GB7876@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, syzkaller <syzkaller@googlegroups.com>

On Mon, Nov 13, 2017 at 11:09 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Nov 13, 2017 at 01:39:27PM +0800, Xin Long wrote:
>> Now when resetting stream, if both in and out flags are set, the info
>> len can reach:
>>   sizeof(struct sctp_strreset_outreq) + SCTP_MAX_STREAM(65535) +
>>   sizeof(struct sctp_strreset_inreq)  + SCTP_MAX_STREAM(65535)
>> even without duplicated stream no, this value is far greater than the
>> chunk's max size.
>>
>> _sctp_make_chunk doesn't do any check for this, which would cause the
>> skb it allocs is huge, syzbot even reported a crash due to this.
>>
>> This patch is to check stream reset info len before making reconf
>> chunk and return NULL if the len exceeds chunk's capacity.
>>
>> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> ---
>>  net/sctp/sm_make_chunk.c | 7 +++++--
>>  net/sctp/stream.c        | 8 +++++---
>>  2 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
>> index 514465b..a21328a 100644
>> --- a/net/sctp/sm_make_chunk.c
>> +++ b/net/sctp/sm_make_chunk.c
>> @@ -3598,14 +3598,17 @@ struct sctp_chunk *sctp_make_strreset_req(
>>       __u16 stream_len = stream_num * 2;
>>       struct sctp_strreset_inreq inreq;
>>       struct sctp_chunk *retval;
>> -     __u16 outlen, inlen;
>> +     int outlen, inlen;
>>
>>       outlen = (sizeof(outreq) + stream_len) * out;
>>       inlen = (sizeof(inreq) + stream_len) * in;
>>
>> +     if (outlen + inlen > SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_chunkhdr))
>> +             return ERR_PTR(-EINVAL);
>> +
> Why all the ERR_PTR manipulations here?  Just returning NULL, like the fuction
> has been doing is sufficient to set ENOMEM at both call sites
I don't like ERR_PTR handling here either,
But it shouldn't be ENOMEM, should it ?

It may confuse users, but I'm also ok to let it just return
ENOMEM as you wish. wdyt ?

>
> Neil
>
>>       retval = sctp_make_reconf(asoc, outlen + inlen);
>>       if (!retval)
>> -             return NULL;
>> +             return ERR_PTR(-ENOMEM);
>>
>>       if (outlen) {
>>               outreq.param_hdr.type = SCTP_PARAM_RESET_OUT_REQUEST;
>> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
>> index fa8371f..51a25bf 100644
>> --- a/net/sctp/stream.c
>> +++ b/net/sctp/stream.c
>> @@ -162,8 +162,8 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
>>
>>       kfree(nstr_list);
>>
>> -     if (!chunk) {
>> -             retval = -ENOMEM;
>> +     if (IS_ERR(chunk)) {
>> +             retval = PTR_ERR(chunk);
>>               goto out;
>>       }
>>
>> @@ -482,8 +482,10 @@ struct sctp_chunk *sctp_process_strreset_inreq(
>>       }
>>
>>       chunk = sctp_make_strreset_req(asoc, nums, str_p, 1, 0);
>> -     if (!chunk)
>> +     if (IS_ERR(chunk)) {
>> +             chunk = NULL;
>>               goto out;
>> +     }
>>
>>       if (nums)
>>               for (i = 0; i < nums; i++)
>> --
>> 2.1.0
>>
>>
