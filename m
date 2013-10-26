From: wangweidong <wangweidong1@huawei.com>
Date: Sat, 26 Oct 2013 02:59:52 +0000
Subject: Re: [PATCH 1/4] sctp: merge two if statements to one
Message-Id: <526B3028.4060303@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382665805-13952-1-git-send-email-wangweidong1@huawei.com> <1382665805-13952-2-git-send-email-wangweidong1@huawei.com> <526B016D.6030301@gmail.com>
In-Reply-To: <526B016D.6030301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net, nhorman@tuxdriver.com
Cc: dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 2013/10/26 7:40, Vlad Yasevich wrote:
> On 10/24/2013 09:50 PM, Wang Weidong wrote:
>> Two if statements do the same work, maybe we can merge them to
>> one. There is just code simplification, no functional changes.
>>
>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>> ---
>>   net/sctp/auth.c | 12 ++++--------
>>   1 file changed, 4 insertions(+), 8 deletions(-)
>>
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
>>            * length fields set, so that we can allocated and use
>>            * them.  We can safely just check for name, for without the
>>            * name, we can't allocate the TFM.
>>                */
>> -        if (!sctp_hmac_list[id].hmac_name) {
>> +        if (id > SCTP_AUTH_HMAC_ID_MAX ||
>> +            !sctp_hmac_list[id].hmac_name) {
> 
> Can you please make the 2 parts of the 'if' statement above line up
> with each other instead of the code below.  I makes it easy to see what
> the whole 'if conditional' is.
> 
> Thanks
> -vlad
> 

Ok, I will resend a new version.
Thanks. 

>>               id = 0;
>>               continue;
>>           }
>>
> 
> 
> 


