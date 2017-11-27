From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 27 Nov 2017 10:58:11 +0000
Subject: Re: [PATCH net 3/5] sctp: only allow the asoc reset when the asoc outq is empty
Message-Id: <CADvbK_dUUoXDii7fQzvh7B__Pyk5MxmGriT8W_-id_y+HMCR9A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com> <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
 <3550c48ecea24515965aeb4753b2caac@AcuMS.aculab.com>
In-Reply-To: <3550c48ecea24515965aeb4753b2caac@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Mon, Nov 27, 2017 at 6:06 PM, David Laight <David.Laight@aculab.com> wrote:
> From: Xin Long
>> Sent: 25 November 2017 13:06
>>
>> As it says in rfc6525#section5.1.4, before sending the request,
>>
>>    C2:  The sender has either no outstanding TSNs or considers all
>>         outstanding TSNs abandoned.
>>
>> Prior to this patch, it tried to consider all outstanding TSNs abandoned
>> by dropping all chunks in all outqs with sctp_outq_free (even including
>> sacked, retransmit and transmitted queues) when doing this reset, which
>> is too aggressive.
>>
>> To make it work gently, this patch will only allow the asoc reset when
>> the sender has no outstanding TSNs by checking if unsent, transmitted
>> and retransmit are all empty with sctp_outq_is_empty before sending
>> and processing the request.
>
> Doesn't that rather defeat the point of a reset?
No, reset here means to reset the next tsn/ssn, not with the cost of
losing outstanding data, though RFC6525 allows to consider them
abandoned.
