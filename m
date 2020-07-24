From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 24 Jul 2020 12:56:04 +0000
Subject: Re: [PATCH] sctp: remove redundant initialization of variable status
Message-Id: <ff52bd0f-ff45-477d-4a66-8f8e98328122@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200724121753.16721-1-colin.king@canonical.com>
 <20200724125514.GD3399@localhost.localdomain>
In-Reply-To: <20200724125514.GD3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 24/07/2020 13:55, Marcelo Ricardo Leitner wrote:
> On Fri, Jul 24, 2020 at 01:17:53PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable status is being initialized with a value that is never read
>> and it is being updated later with a new value.  The initialization is
>> redundant and can be removed.
>>
>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Are you willing to send another to patch to fix the var ordering in
> reverse christmass tree in there?

Sure, I'll send a V2 to re-order the vars.

> 
>> ---
>>  net/sctp/protocol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>> index 7ecaf7d575c0..a0448f7c64b9 100644
>> --- a/net/sctp/protocol.c
>> +++ b/net/sctp/protocol.c
>> @@ -1368,7 +1368,7 @@ static struct pernet_operations sctp_ctrlsock_ops = {
>>  static __init int sctp_init(void)
>>  {
>>  	int i;
>> -	int status = -EINVAL;
>> +	int status;
>>  	unsigned long goal;
>>  	unsigned long limit;
>>  	unsigned long nr_pages = totalram_pages();
>> -- 
>> 2.27.0
>>
