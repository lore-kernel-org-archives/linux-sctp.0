From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 06 Dec 2013 08:48:45 +0000
Subject: Re: [PATCH v4] sctp: check the rto_min and rto_max
Message-Id: <52A18F6D.9010606@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529FE2AD.5020700@huawei.com> <20131205133217.GA20349@hmsreliant.think-freely.org>
In-Reply-To: <20131205133217.GA20349@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 2013/12/5 21:32, Neil Horman wrote:
> On Thu, Dec 05, 2013 at 10:19:25AM +0800, Wang Weidong wrote:
>> rto_min should be smaller than rto_max while rto_max should be larger
>> than rto_min. Add two proc_handler for the checking. Add the check in
>> sctp_setsockopt_rtoinfo.
>> delete a blank line in proc_sctp_do_hmac_alg() declaration.
>>
>> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>> ---
>>  net/sctp/socket.c |  5 ++++
>>  net/sctp/sysctl.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>>  2 files changed, 74 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index 72046b9..2e1af1b 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -2818,6 +2818,11 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
>>  	if (copy_from_user(&rtoinfo, optval, optlen))
>>  		return -EFAULT;
>>  
>> +	if (rtoinfo.srto_min < 1 ||
>> +	    rtoinfo.srto_max > 86400000 ||
> These should be defiend to some descriptive value.
> 
> 
Hi Neil,

Should I define it in net/sctp/sctp.h, so sysctl.c can use it as well.
Or I just define it in the socket.c same as the definition in sysctl.c?

Regards.
Wang

> 


