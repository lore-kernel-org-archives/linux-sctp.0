From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 18 Nov 2017 18:20:04 +0000
Subject: Re: [PATCH net] sctp: report SCTP_ERROR_INV_STRM as cpu endian
Message-Id: <CADvbK_etQ8rUA-QaihvY34OZ_k+t5JbdGTn4Cm0CW1RGA=4pLg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <d4de9314041c0ebb1d1e5f49130b880788a30735.1510899302.git.lucien.xin@gmail.com>
 <20171117150459.GK6388@localhost.localdomain>
In-Reply-To: <20171117150459.GK6388@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Nov 17, 2017 at 11:04 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Fri, Nov 17, 2017 at 02:15:02PM +0800, Xin Long wrote:
>> rfc6458 demands the send_error in SCTP_SEND_FAILED_EVENT should
>> be in cpu endian, while SCTP_ERROR_INV_STRM is in big endian.
>>
>> This issue is there since very beginning, Eric noticed it by
>> running 'make C=2 M=net/sctp/'.
>>
>> This patch is to convert it before reporting it.
>
> Unfortunatelly we can't fix this as this will break UAPI. It will
> break applications that are currently matching on the current value.
yes, you're right, seems all other send_errors also come in big endian now.

what do you think of using:
sctp_chunk_fail(ch, (__force __u16)SCTP_ERROR_INV_STRM); or

sctp_chunk_fail(ch, (__force __u32)SCTP_ERROR_INV_STRM);

to avoid this warning ?

>
>>
>> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> ---
>>  net/sctp/stream.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
>> index a11db21..f86ceee 100644
>> --- a/net/sctp/stream.c
>> +++ b/net/sctp/stream.c
>> @@ -64,7 +64,7 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>>                */
>>
>>               /* Mark as failed send. */
>> -             sctp_chunk_fail(ch, SCTP_ERROR_INV_STRM);
>> +             sctp_chunk_fail(ch, be16_to_cpu(SCTP_ERROR_INV_STRM));
>>               if (asoc->peer.prsctp_capable &&
>>                   SCTP_PR_PRIO_ENABLED(ch->sinfo.sinfo_flags))
>>                       asoc->sent_cnt_removable--;
>> --
>> 2.1.0
>>
