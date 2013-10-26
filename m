From: wangweidong <wangweidong1@huawei.com>
Date: Sat, 26 Oct 2013 02:55:39 +0000
Subject: Re: [PATCH 1/4] sctp: merge two if statements to one
Message-Id: <526B2F2B.1050403@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382665805-13952-1-git-send-email-wangweidong1@huawei.com> <1382665805-13952-2-git-send-email-wangweidong1@huawei.com> <526A6C45.3080200@cogentembedded.com>
In-Reply-To: <526A6C45.3080200@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, davem@davemloft.net, nhorman@tuxdriver.com, vyasevich@gmail.com
Cc: dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 2013/10/25 21:04, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-10-2013 5:50, Wang Weidong wrote:
> 
>> Two if statements do the same work, maybe we can merge them to
>> one. There is just code simplification, no functional changes.
> 
>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>> ---
>>   net/sctp/auth.c | 12 ++++--------
>>   1 file changed, 4 insertions(+), 8 deletions(-)
> 
>    I understand what I noticed below is not your typos but maybe it's time to fix them?

Yeah, I will fix them.
Thanks.

> 
>> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
>> index 8c4fa5d..19fb0ae 100644
>> --- a/net/sctp/auth.c
>> +++ b/net/sctp/auth.c
>> @@ -539,18 +539,14 @@ struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc)
>>       for (i = 0; i < n_elt; i++) {
>>           id = ntohs(hmacs->hmac_ids[i]);
>>
>> -        /* Check the id is in the supported range */
>> -        if (id > SCTP_AUTH_HMAC_ID_MAX) {
>> -            id = 0;
>> -            continue;
>> -        }
>> -
>> -        /* See is we support the id.  Supported IDs have name and
>> +        /* Check the id is in the supported range. And
>> +         * see is we support the id.  Supported IDs have name and
> 
>    s/is/if/.
> 
>>            * length fields set, so that we can allocated and use
> 
>    s/allocated/allocate/.
> 
> WBR, Sergei
> 
> 
> 


