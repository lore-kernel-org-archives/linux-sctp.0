From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 09 Aug 2018 08:40:52 +0000
Subject: Re: [PATCH v2 1/2] net/sctp: Make wrappers for accessing in/out streams
Message-Id: <dbda6c3d-36ee-35e1-e0a0-0c86e2929e3c@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <20180803162102.19540-2-khorenko@virtuozzo.com>
 <20180803204011.GH5482@localhost.localdomain>
In-Reply-To: <20180803204011.GH5482@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On 08/03/2018 11:40 PM, Marcelo Ricardo Leitner wrote:
> On Fri, Aug 03, 2018 at 07:21:01PM +0300, Konstantin Khorenko wrote:
>> This patch introduces wrappers for accessing in/out streams indirectly.
>> This will enable to replace physically contiguous memory arrays
>> of streams with flexible arrays (or maybe any other appropriate
>> mechanism) which do memory allocation on a per-page basis.
>>
>> Signed-off-by: Oleg Babin <obabin@virtuozzo.com>
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>>
>> ---
>> v2 changes:
>>  sctp_stream_in() users are updated to provide stream as an argument,
>>  sctp_stream_{in,out}_ptr() are now just sctp_stream_{in,out}().
>> ---
>
> ...
>
>>
>>  struct sctp_stream {
>> -	struct sctp_stream_out *out;
>> -	struct sctp_stream_in *in;
>> +	struct flex_array *out;
>> +	struct flex_array *in;
>
> If this patch was meant to be a preparation, shouldn't this belong to
> the next patch instead?

Marcelo,

agree, that will be better, will move the hunk along with changes in
sctp_stream_alloc_{in,out}().

Thank you!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team
