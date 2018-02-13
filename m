From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Feb 2018 07:22:32 +0000
Subject: Re: [PATCH net] sctp: fix some copy-paste errors for file comments
Message-Id: <CADvbK_e0VkYWs0fKjUWz83QstXU29RQUP+K=VxzmXMvx+K3gjw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f799a5c7adc78c16bed32ac7601453b832f8a554.1518431434.git.lucien.xin@gmail.com>
 <20180212141234.GC21383@hmswarspite.think-freely.org>
In-Reply-To: <20180212141234.GC21383@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Feb 12, 2018 at 10:12 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Feb 12, 2018 at 06:30:34PM +0800, Xin Long wrote:
>> This patch is to fix the file comments in stream.c and
>> stream_interleave.c
>>
>> Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
>> Fixes: 0c3f6f655487 ("sctp: implement make_datafrag for sctp_stream_interleave")
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> ---
>>  net/sctp/stream.c            | 2 +-
>>  net/sctp/stream_interleave.c | 3 ++-
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
>> index cedf672..0850e2a 100644
>> --- a/net/sctp/stream.c
>> +++ b/net/sctp/stream.c
>> @@ -6,7 +6,7 @@
>>   *
>>   * This file is part of the SCTP kernel implementation
>>   *
>> - * These functions manipulate sctp tsn mapping array.
>> + * These functions work for sctp stream basic operation and reconfig.
>>   *
> If you're going to change it, I'm not sure I'd even put a comment in here.  If
> you insist on documenting the purpose of the file, I'd use something even more
> generic, like:
>
> This file contains sctp stream maniuplation primitives and helpers.
Sure, let's use this generic one, will post v2. Thanks.

>
> Neil
>
>>   * This SCTP implementation is free software;
>>   * you can redistribute it and/or modify it under the terms of
>> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
>> index 8c7cf8f..c19fd42 100644
>> --- a/net/sctp/stream_interleave.c
>> +++ b/net/sctp/stream_interleave.c
>> @@ -3,7 +3,8 @@
>>   *
>>   * This file is part of the SCTP kernel implementation
>>   *
>> - * These functions manipulate sctp stream queue/scheduling.
>> + * These functions implement sctp stream message interleaving, mostly
>> + * including I-DATA and I-FORWARD-TSN chunks process.
>>   *
>>   * This SCTP implementation is free software;
>>   * you can redistribute it and/or modify it under the terms of
>> --
>> 2.1.0
>>
>>
